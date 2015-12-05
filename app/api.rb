module Yep
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Yep::V1::Mention
  end
end
