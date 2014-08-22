module RubyHashcat
  class API < Sinatra::Application
    get '/location.json' do
      content_type :json

      if settings.debug
        pp params
      end

      {:location => settings.ocl_location}.to_json
    end

    get '/rules.json' do
      content_type :json

      if settings.debug
        pp params
      end

      list = Dir.entries("#{settings.ocl_location}/rules/")
      list.delete('.')
      list.delete('..')
      {:rules => list}.to_json
    end
  end
end