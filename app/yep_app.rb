module Yep
  class App < Goliath::API
    use Goliath::Rack::Params
    use Goliath::Rack::Render

    def response(env)
      Yep::API.call(env)
    end
  end
end
