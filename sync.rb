module Celluloid
  module Sync

    @@gem_path ||= File.expand_path("../../", __FILE__)
    $:.push( @@gem_path)

    require(File.expand_path("../gems/loader", __FILE__))
    GEM = Celluloid::Gems::SELF unless defined? GEM

    LIB_PATH = File.expand_path("../../lib/#{GEM.split("-").join("/")}", __FILE__)
    if File.exist?(version="#{LIB_PATH}/version.rb")
      require(version)
    end

    puts "Synchronizing Celluloid Culture //"
    puts `cd #{@@gem_path}/culture; git pull`

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