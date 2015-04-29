module Celluloid
  module Sync

    unless defined? @@updated
      @@gem_path ||= File.expand_path("../../", __FILE__)
      $:.push( @@gem_path)

      puts "Synchronizing Celluloid Culture //"
      @@update = %x[cd #{@@gem_path}/culture; git pull]
      @@updated = @@update.include?("up-to-date")

      @@required ||= [
        "#{@@gem_path}/culture/sync",
        "#{@@gem_path}/culture/gems/loader"
      ]
      puts @@update
    end

    class << self
      def update!
        if @@updated
          puts "Celluloid Culture was updated."
          @@required.each { |rb| load(rb) }
          puts "Reloaded Culture::Sync itself."
        end
      end
    end

    unless @@updated
      require(@@required.last)
      GEM = Celluloid::Gems::SELF unless defined? GEM

      LIB_PATH = File.expand_path("../../lib/#{GEM.split("-").join("/")}", __FILE__)
      if File.exist?(version="#{LIB_PATH}/version.rb")
        require(version)
      end

      class << self

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

Celluloid::Sync.update!