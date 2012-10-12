require 'thor/group'

module Paprika
  class DirAlreadyExists < StandardError
  end

  class Generator < Thor::Group
    include Thor::Actions
    namespace ""
    desc "Generate a Chrome extension"

    argument :name, :type => :string, :desc => "Name of the extension", :default => "My First Extension"
    argument :description, :type => :string, :desc => "Description of the extension", :default => "The first extension that I made."
    source_root File.expand_path("../../templates", __FILE__)

    class_option :popup, :default => true, :type => :boolean
    class_option :options, :default => false, :type => :boolean
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

    def create_background
      copy_file "background.js", "javascripts/background.js" if options[:options] || options[:background]
    end

    def create_popup_haml
      copy_file "popup.haml", "views/popup.haml" if options[:popup]
    end

    def create_content_js
      copy_file "content.js", "javascripts/content.js"
    end

    def create_options_haml
      copy_file "options.haml", "views/options.haml" if options[:options]
    end

    def create_options_js
      copy_file "options.js", "javascripts/options.js" if options[:options]
    end

    def add_gemfile
      copy_file "Gemfile"
      inside do
        run "bundle install"
      end
    end
  end
end
