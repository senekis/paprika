require 'haml'
require 'paprika/generator'

module Paprika
  class Tasks < Thor
    desc "compile", "Compile sass and haml"
    def compile
      Dir["**/*.haml"].each do |file|
        html_file = file.sub /\.haml$/, '.html'
        template = File.read(file)
        haml_engine = Haml::Engine.new(template, :filename => file)
        output = haml_engine.render
        File.open(html_file, "w") { |f| f.write output }
        puts "Compile >> #{file}"
      end

      Dir["**/*.sass"].each do |file|
        css_file = file.sub /\.haml$/, '.html'
        template = File.read(file)
        sass_engine = Sass::Engine.new(template)
        output = sass_engine.render
        File.open(css_file, "w") { |f| f.write output }
        puts "Compile >> #{file}"
      end
    end

    desc "pack_extension", "Package your extension - file extension 'crx'"
    method_option :extension_path, :aliases => "-f", :desc => "Location of the extension's folder"
    def pack_extension(extension_path)
      run "google-chrome --pack-extension=#{extension_path}"
    end
  end
end