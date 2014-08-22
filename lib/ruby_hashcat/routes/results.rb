module RubyHashcat
  class API < Sinatra::Application
    get '/results.json' do
      content_type :json

      if settings.debug
        pp params
      end

      hc = RubyHashcat::Objects::Hash.new(params[:id].to_i, settings.ocl_location)
      unless hc.exists?
        return {:status => 'error', :message => 'Invalid ID.'}.to_json
      end
      if hc.running?
        return {:status => 'running'}.to_json
      else
        return {:results => hc.results, :status => hc.status}.to_json
      end
    end
  end
end