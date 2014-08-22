module RubyHashcat
  class API < Sinatra::Application
    post '/crack.json' do
      content_type :json

      if settings.debug
        pp params
      end

      path = File.dirname(__FILE__)

      # Validate required parameters
      unless params[:id] and params[:type] and params[:attack] and params[:hash]
        return {error: 'Invalid Parameters. Please check the documentation.'}.to_json
      end

      begin
        hc = RubyHashcat::Objects::Hash.new(params[:id].to_i, settings.ocl_location)
        if hc.exists? and not hc.running?
          hc.clean
        end
        id = params[:id].to_i
        attack = params[:attack].to_i
        type = params[:type].to_i
        hash = "#{path}/../tmp/#{id}.hash"

        hc.attack = attack

        case attack
          when 1
            raise RubyHashcat::Objects::Hash::InvalidCombinationAttack unless File.exists?(params[:word_list][:tempfile]) and File.exists?(params[:word_list_2][:tempfile])
            word_list = "#{path}/../tmp/#{id}.dict"
            word_list_2 = "#{path}/../tmp/#{id}.dict2"
            tmp = []
            tmp << word_list.clone
            tmp << word_list_2.clone
            File.rename(params[:word_list][:tempfile], word_list)
            File.rename(params[:word_list_2][:tempfile], word_list_2)
            word_list = tmp
          else
            if params[:word_list]
              if params[:word_list][:tempfile]
                if File.exists?(params[:word_list][:tempfile])
                  word_list = "#{path}/../tmp/#{id}.dict"
                  File.rename(params[:word_list][:tempfile], word_list)
                end
              end
            end
        end

        if params[:rule_sets]
          hc.rules = params[:rule_sets]
        end
        if params[:username]
          hc.username = true
        end
        if params[:charset]
          hc.charset = params[:charset]
        end

        File.rename(params[:hash][:tempfile], hash)

        hc.hash = hash
        hc.word_list = word_list
        hc.type = type

        hc.crack(true)

        return {:status => 'success'}.to_json
      rescue RubyHashcat::Objects::Hash::RubyHashcatError => e
        return {:error => e.message}.to_json
      rescue => e
        return {:error => e.message, :error_backlog => e.backtrace, :error => e}.to_json
      end

    end
  end
end