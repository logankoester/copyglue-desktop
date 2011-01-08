module CopyGlue
  module CGDesktop
    class CGApplication
      def self.run!
        tray_thread = Thread.new do
          app = CGGUI::CGTrayApplication.new(APP_NAME)
          app.icon_filename = 'res/icon.gif'

          # Menu entry to toggle CGService
          app.checkbox_item("Enable Sync", true) { |event|
            case(event.stateChange)
              when 1
                CGService.instance.enable
              when 2
                CGService.instance.disable
            end
          }

          app.item("Preferences") {
            display_preferences
          }
          
          # Menu entry to open the browser
          app.item("Visit homepage") {
            import java.awt.Desktop
            desktop = Desktop.get_desktop
            desktop.browse java.net.URI.new HOMEPAGE.to_s
          }

          # Menu entry to exit the application
          app.item('Exit') {
            java.lang.System::exit(0)
          }
          app.run
        end

        unless CGService.instance.load_api_key
          display_preferences
        end

        # Start the service in a new thread
        service_thread = Thread.new do
          CGService.instance.enable
          loop do
            CGService.instance.run
            sleep INTERVAL
          end
        end

        CGDesktop.logger.debug "Start at: #{Time.now}"
        service_thread.join
        tray_thread.join
        CGDesktop.logger.debug "End at: #{Time.now}"
      end

    protected
      def self.display_preferences
        prefs = CGGUI::CGPrefsApplication.new("Preferences")
      end

    end
  end
end
