module Celluloid
  module Sync

    unless defined? @@updated
      @@gem_path ||= File.expand_path("../../", __FILE__)
      $:.push( @@gem_path)

      # TODO: This will likely need to be done differently if INSIDE a cut gem.

      puts "Synchronizing Celluloid Culture //"
      @@update = `cd #{@@gem_path}/culture; git pull`
      @@updated = !@@update.include?("up-to-date")

      @@required ||= [
        "#{@@gem_path}/culture/sync.rb",
        "#{@@gem_path}/culture/gems/loader"
      ]
    else
      @updated = false
    end

    class << self
      def updated?
        @@updated
      end
      if @@updated
        puts "Was updated."
        def update!
          if @@updated
            puts "Celluloid Culture was updated."
            @@required.each { |rb| load(rb) }
            puts "Reloaded Culture::Sync itself:\n#{@@update}"
          end
        end
      else
        puts "Was not updated."  
        require(@@required.last)
        GEM = Celluloid::Gems::SELF unless defined? GEM

        LIB_PATH = File.expand_path("../../lib/#{GEM.split("-").join("/")}", __FILE__)
        if File.exist?(version="#{LIB_PATH}/version.rb")
          require(version)
        end

        def gems(loader)
          case loader.class
          when Gem::Specification
            Gems.gemspec(loader)
          when Bundler::Dsl
            Gems.bundler(loader)
          end
        end

      end
    end
  end
end

Celluloid::Sync.update! if Celluloid::Sync.updated?