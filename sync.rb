module Celluloid
  module Sync

    @@gem_path ||= File.expand_path("../../", __FILE__)
    $:.push( @@gem_path)

    require(File.expand_path("../gems/loader", __FILE__))
    GEM = Celluloid::Gems::SELF unless defined? GEM

    LIB_PATH = File.expand_path("../lib/#{GEM.split("-").join("/")}", __FILE__)
    if File.exist?(version="#{LIB_PATH}/version.rb")
      require(version)
    end

    puts "#{[LIB_PATH,lib]}"

    class << self

      def gems(loader)

        puts "loader? #{loader.class}"
        puts "git pull #{@gem_path}/culture"

      end
    end
  end
end