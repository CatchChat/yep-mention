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
  }
}
        STR
        req = EM::HttpRequest.new("#{ENV['ELASTICSEARCH_URL']}/users/user/_search?form=0&size=5&source=#{CGI.escape(source)}").get
        result = ActiveSupport::JSON.decode req.response
        hits = result['hits']['hits'] rescue []

        hits.map do |user|
          {
            id: AES256.encrypt_id(user['_id']),
            avatar: { thumb_url: user['_source']['avatar'] ? "https://s3.cn-north-1.amazonaws.com.cn/#{ENV['AWS_AVATARS_BUCKET']}/#{user['_source']['avatar']}" : nil },
            username: user['_source']['username'],
            nickname: user['_source']['nickname']
          }
        end
      end
    end
  end
end
