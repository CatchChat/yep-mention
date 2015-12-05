require 'em-synchrony'
require 'em-synchrony/em-http'
require 'active_support'

module Yep
  module V1
    class Mention < Grape::API
      version 'v1', using: :path
      format :json

      params do
        requires :q, regexp: /\A[a-zA-Z0-9_]+\z/
      end
      get 'typeahead' do
        lowercased_word = params[:q].to_s.downcase
        source = <<-STR
{
  "query":{
    "prefix":{
      "username":"#{lowercased_word}"
    }
  },
  "sort":{
    "last_sign_in_at":"desc"
  }
}
        STR
        req = EM::HttpRequest.new("#{ENV['ELASTICSEARCH_URL']}/users/user/_search?form=0&size=5&source=#{CGI.escape(source)}").get
        result = ActiveSupport::JSON.decode req.response

        result['hits']['hits'].map do |user|
          {
            id: AES256.encrypt_id(user['_id']),
            avatar_url: user['_source']['avatar_url'],
            username: user['_source']['username'],
            nickname: user['_source']['nickname']
          }
        end
      end
    end
  end
end
