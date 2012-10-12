require 'thor/group'

module Paprika
  class DirAlreadyExists < StandardError
  end

  class Generator < Thor::Group
    include Thor::Actions
    namespace ""
    argument :name

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
    end
  end
end