module RubyHashcat
  class API < Sinatra::Application
    get '/status.json' do
      content_type :json

      if settings.debug
        pp params
      end

      begin
        hc = RubyHashcat::Objects::Hash.new(params[:id].to_i, settings.ocl_location)
        unless hc.exists?
          return {:status => 'error', :message => 'Invalid ID.'}.to_json
        end

        if hc.running?
          return {:status => 'running'}.to_json
        else
          return {:status => 'complete'}.to_json
        end
      rescue => e
        return {:status => 'error', :message => e.message}.to_json
      end
    end

    get '/status-advanced.json' do
      content_type :json

      if settings.debug
        pp params
      end

      begin
        hc = RubyHashcat::Objects::Hash.new(params[:id].to_i, settings.ocl_location)
        unless hc.exists?
          return {:status => 'error', :message => 'Invalid ID.'}.to_json
        end
        return {:status => hc.status}.to_json
      rescue => e
        return {:status => 'error', :message => e.message}.to_json
      end
    end
  end
end