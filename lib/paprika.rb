require 'thor/group'

module Paprika
  class DirAlreadyExists < StandardError
  end

  class Generator < Thor::Group
    include Thor::Actions
    namespace ""
    argument :name, :type => :string, :desc => "Name of the extension", :default => "My First Extension"
    argument :description, :type => :string, :desc => "Description of the extension", :default => "The first extension that I made."
    source_root File.expand_path("../../templates", __FILE__)

    class_option :content, :default => true, :type => :boolean
    class_option :option, :default => false, :type => :boolean
    class_option :background, :default => false, :type => :boolean

    def create_tree
      unless File.exists?(name) || File.directory?(name)
        Dir.mkdir name
      else
        raise DirAlreadyExists, "The directory #{name} already exists, aborting. Maybe move it out of the way before continuing?"
      end

      Dir.mkdir "#{name}/views"
      Dir.mkdir "#{name}/stylesheet"
      Dir.mkdir "#{name}/javascripts"
      Dir.mkdir "#{name}/javascripts/vendor"
      self.destination_root = name
    end

    def create_icon
      copy_file "icon.png"
    end

    def create_manifest
      template "manifest.json"
    end

    def copy_vendors
      copy_file "vendor/jquery.js", "javascripts/vendor/jquery.js"
    end

    def create_background_haml
      template "background.haml", "views/background.haml" if options[:background]
    end

    def create_background_js
      template "background.js", "javascripts/background.js" if options[:option] || options[:background]
    end

    def create_content_haml
      copy_file "content.haml", "javascripts/content.haml" if options[:content]
    end

    def create_content_js
      template "content.js", "javascripts/content.js" if options[:content]
    end

    def create_options_haml
      template "options.haml", "views/options.haml" if options[:option]
    end

    def create_options_js
      template "options.js", "javascripts/options.js" if options[:option]
    end
  end
end