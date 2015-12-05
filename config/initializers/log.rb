Goliath::Request.log_block = proc do |env, response, elapsed_time|
  method = env[Goliath::Request::REQUEST_METHOD]
  path   = env[Goliath::Request::REQUEST_PATH]

  env.logger.info <<-STR
#{method} #{path} in #{'%.2f' % elapsed_time} ms
===> IP: #{env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || '-'}
===> Params: #{env['params'].inspect}
===> Response: #{response.body[0]}"
  STR
end
