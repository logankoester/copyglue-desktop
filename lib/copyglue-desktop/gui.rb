module CopyGlue
  module CGDesktop
    module CGGUI
      include Java
      include_class 'java.awt.event.ActionListener'
      include_class 'java.awt.BorderLayout'
      include_class 'javax.swing.JButton'
      include_class 'javax.swing.JFrame'
      include_class 'javax.swing.JLabel'
      include_class 'javax.swing.JTextField'
      import java.awt.Toolkit
      import java.awt.TrayIcon

      class CGTrayApplication

        attr_accessor :icon_filename
        attr_accessor :menu_items

        def initialize(name = 'Tray Application')
          @menu_items = []
          @name       = name
        end

        def item(label, &block)
          item = java.awt.MenuItem.new(label)
          item.add_action_listener(block)
          @menu_items << item
        end

        def checkbox_item(label, state = false, &block)
          item = java.awt.CheckboxMenuItem.new(label, state)
          item.add_item_listener(block)
          @menu_items << item
        end

        def run
          popup = java.awt.PopupMenu.new
          @menu_items.each{|i| popup.add(i)}

          # Give the tray an icon and attach the popup menu to it
          image    = java.awt.Toolkit::default_toolkit.get_image(@icon_filename)
          tray_icon = TrayIcon.new(image, @name, popup)
          tray_icon.image_auto_size = true

          # Finally add the tray icon to the tray
          tray = java.awt.SystemTray::system_tray
          tray.add(tray_icon)
        end

      end

      class CGPrefsApplication < JFrame
        def initialize(name = 'Preferences', w = 500, h = 500, pos = :center)
          super name
          setSize w, h
          
          # Center the window
          position(pos)
          setLayout BorderLayout.new(20, 20)

          api_key_label = add_label "API Key (check your mobile device)"
          api_key = add_text_field(8)

          save = add_button("Connect!") do
            close if CGService.instance.save_api_key(api_key.getText)
          end

          add api_key_label, BorderLayout::WEST
          add api_key, BorderLayout::EAST
          add save, BorderLayout::SOUTH

          pack
          display
        end

        def display
          setVisible true
        end

        def close
          setVisible false
          dispose
        end

        def add_button(label, &block)
          button = JButton.new label
          button.addActionListener block
          button
        end

        def add_text_field(size = 20) 
          JTextField.new(size)
        end

        def add_label(text)
          JLabel.new text
        end

        def position(pos)
          if pos == :center
            dim = Toolkit.getDefaultToolkit.getScreenSize
            w = getSize.width
            h = getSize.height
            x = (dim.width - w) / 2
            y = (dim.height - h) / 2
            setLocation x, y
          elsif pos.is_a? Array
            setLocation pos[0], pos[1]
          end
        end
      end
    end
  end
end
