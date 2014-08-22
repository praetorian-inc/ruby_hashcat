module RubyHashcat
  class API < Sinatra::Application
    post '/clean.json' do
      content_type :json
      hc = RubyHashcat::Objects::Hash.new(params[:id].to_i, settings.ocl_location)
      if hc.exists?
        hc.clean
        return {:status => 'success'}.to_json
      else
        return {:status => 'error', :message => 'Invalid ID.'}.to_json
      end
    end
  end
end