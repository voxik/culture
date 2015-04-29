module Celluloid
  module Sync

    @@gem_path ||= File.expand_path("../../", __FILE__)
    $:.push( @@gem_path)

    puts "Synchronizing Celluloid Culture //"
    @@update = `cd #{@@gem_path}/culture; git pull`
    @@updated = @@update.include?("up-to-date")
    @@required ||= ["#{@@gem_path}/culture/sync"]
    
    require(@@required << File.expand_path("../gems/loader", __FILE__))
    GEM = Celluloid::Gems::SELF unless defined? GEM

    LIB_PATH = File.expand_path("../../lib/#{GEM.split("-").join("/")}", __FILE__)
    if File.exist?(version="#{LIB_PATH}/version.rb")
      require(version)
    end

    class << self

      def update!
        if @@updated
          puts "Celluloid Culture was updated."
          @@required.each { |rb| load(rb) }
          puts "Reloaded Culture::Sync itself."
        end
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

Celluloid::Sync.update!