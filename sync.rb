module Celluloid
  module Sync

    @@gem_path ||= File.expand_path("../../", __FILE__)
    $:.push( @@gem_path)

    require(File.expand_path("../gems/loader", __FILE__))
    GEM = Celluloid::Gems::SELF

    class << self

      def gems(loader)

        puts "loader? #{loader.class}"
        puts "git pull #{@gem_path}/culture"


      end
    end
  end
end