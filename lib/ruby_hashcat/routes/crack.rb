module RubyHashcat
  class API < Sinatra::Application
    post '/new/crack.json' do
      content_type :json
      path = File.dirname(__FILE__)

      begin
        hc = RubyHashcat::Objects::Hash.new(params[:id], settings.ocl_location)
        hc.hash = params[:hash][:tempfile]
        hc.word_list = params[:word_list][:tempfile]
        hc.rules = params[:rule_sets]
        hc.type = params[:type]
      rescue RubyHashcat::Objects::Hash::InvalidHashId => e
        return {:error => e.message}.to_json
      rescue RubyHashcat::Objects::Hash::InvalidHashWordList => e
        return {:error => e.message}.to_json
      end

    end
  end
end