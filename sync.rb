module Celluloid
  module Sync

    class < self
      def gem_path
        File.expand_path("../../", __FILE__)
      end
      def gem_name
        Dir["#{File.expand_path('../../', __FILE__)}/*.gemspec"].first.gsub(".gemspec", "").split("/").last
      end
      def gem_name?
        !gem_name.nil?
      end
      def lib_path
        File.expand_path("../../lib", __FILE__)
      end
      def lib_gempath
        "#{lib_path}/#{gem_name.split('-').join('/')}"
      end
    end

    fail "Missing gemspec." unless gem_name?
    $LOAD_PATH.push(gem_path)
    $LOAD_PATH.push(lib_path)


    # TODO: This will likely need to be done differently if INSIDE a cut gem.

    case File.basename($PROGRAM_NAME)
    when "bundle"
      puts $ARGV
      puts "Celluloid::Sync //"
      `cd #{gem_path}/culture; git pull origin master`
    end

    require("#{gem_path}/culture/gems/loader")
    if File.exist?(version = "#{lib_gempath}/version.rb")
      require(version)
    end
  end
end
