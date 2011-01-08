module CopyGlue
  module CGDesktop
    class CGService
      include Singleton

      def initialize
        @enabled = false
        @clipboard_text = local_clipboard

        # Listen for new clips from the mobile device
        @pusher = PusherClient::Socket.new(PUSHER_KEY).connect(true)
        if load_api_key
          @pusher.subscribe("#{@api_key}-ANDROID")
          @pusher["#{@api_key}-ANDROID"].bind('new_clips') do |data|
            Clipboard.copy(JSON.parse(data)['text'])
          end
        end
      end

      def enable
        @clipboard_text = ""
        @enabled = true
        CGDesktop.logger.debug "ClipSync service enabled"
      end 

      def disable
        @enabled = false
        CGDesktop.logger.debug "ClipSync service disabled"
      end

      def run
        if @enabled
          paste = local_clipboard
          if paste != @clipboard_text
            # Validate (text under 1k)
            @clipboard_text = paste
            post_to_server
          end
        end
      end

      def save_api_key(key)
        CGDesktop.logger.debug "Saving API Key: #{key}"
        @api_key = key
        file = File.open(CONFIG_FILENAME, 'w') do |f| 
          f.write({:api_key => @api_key}.to_yaml)
        end
        true # TODO validate first
      end

      def load_api_key
        begin
          @config = YAML.load_file(CONFIG_FILENAME)
          @api_key = @config[:api_key]
          CGDesktop.logger.debug "API key read from config file (#{@api_key})"
          true
        rescue
          CGDesktop.logger.debug "No readable config file"
          false
        end
      end

      def post_to_server
        puts "Sent #{@clipboard_text} to server (pretend)"
      end

      def local_clipboard
        if OS.windows?
          Clipboard.paste
        elsif OS.mac?
          Clipboard.paste
        else
          # Only the ctrl+c/ctrl+v clipboard on Linux
          Clipboard.paste('clipboard')
        end
      end
    end
  end
end
