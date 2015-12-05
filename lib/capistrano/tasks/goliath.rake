namespace :goliath do

  desc 'Start server'
  task :start do
    on roles(:app) do
      worker_processes = fetch(:goliath_worker_processes).to_i || 1
      start_port       = fetch(:goliath_start_port).to_i || 9000
      pidfile_path     = fetch(:goliath_pidfile_path) || 'tmp/pid'
      goliath_env      = fetch(:goliath_env) || 'production'
       within "#{current_path}/#{pidfile_path}" do
        worker_processes.times do |n|
          port = start_port + n
          if test("[ -d #{port}.pid ]") && test("[ -d /proc/`cat #{port}.pid` ]")
            execute :kill, "-9 `cat #{port}.pid`"
          end
          execute :ruby, "yep_app.rb -e #{goliath_env} -p #{port} -d -l log/#{goliath_env}.log -P #{pidfile_path}/#{port}.pid"
        end
      end
    end
  end

  desc 'Stop server'
  task :stop do
    pidfile_path = fetch(:goliath_pidfile_path) || 'tmp/pid'
    within "#{current_path}/#{pidfile_path}" do
      pidfiles = capture(:ls, "*.pid").split("\n")
      pidfiles.each do |file|
        execute :kill, "TERM `cat #{file}`"
      end
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:app) do
      worker_processes = fetch(:goliath_worker_processes).to_i || 1
      start_port       = fetch(:goliath_start_port).to_i || 9000
      pidfile_path     = fetch(:goliath_pidfile_path) || 'tmp/pid'
      goliath_env      = fetch(:goliath_env) || 'production'
      within "#{current_path}/#{pidfile_path}" do
        start_port.upto(start_port + worker_processes - 1) do |port|
          if test("[ -d #{port}.pid ]") && test("[ -d /proc/`cat #{port}.pid` ]")
            execute :kill, "HUP `cat #{port}.pid`"
          else
            execute :ruby, "yep_app.rb -e #{goliath_env} -p #{port} -d -l log/#{goliath_env}.log -P #{pidfile_path}/#{port}.pid"
          end
        end
      end
    end
  end
end
