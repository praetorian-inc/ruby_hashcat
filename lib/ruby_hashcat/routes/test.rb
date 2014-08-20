module RubyHashcat
  class API < Sinatra::Application
    get '/test-get' do
      content_type :json
      pp Hresta::Parse.hash(params)
      params.to_json
    end

    post '/test-post' do
      content_type :json
      pp Hresta::Parse.hash(params)
      params.to_json
    end
  end
end