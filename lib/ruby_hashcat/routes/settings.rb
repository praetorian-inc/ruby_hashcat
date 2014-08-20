module RubyHashcat
  class API < Sinatra::Application
    get '/location.json' do
      content_type :json
      {:location => settings.ocl_location}.to_json
    end

    get '/rules.json' do
      content_type :json
      list = Dir.entries("#{settings.ocl_location}/rules/")
      list.delete('.')
      list.delete('..')
      {:rules => list}.to_json
    end
  end
end