module Celluloid
  module Sync
    GEM_PATH ||= File.expand_path("../../", __FILE__)
    $LOAD_PATH.push(GEM_PATH)

    SELF = Dir["#{File.expand_path('../../', __FILE__)}/*.gemspec"].first.gsub(".gemspec", "").split("/").last
    fail "Missing gemspec." unless SELF

    # TODO: This will likely need to be done differently if INSIDE a cut gem.

    case File.basename($PROGRAM_NAME)
    when "bundle", "rspec"
      puts "Celluloid::Sync //"
      `cd #{GEM_PATH}/culture; git pull origin master`
    end

    require("#{GEM_PATH}/culture/gems/loader")

    LIB_PATH = File.expand_path("../../lib", __FILE__)
    LIB_GEMPATH = "#{LIB_PATH}/#{SELF.split('-').join('/')}"
    $LOAD_PATH.push(LIB_PATH)

    puts "#{LIB_GEMPATH}/version.rb"
    if File.exist?(version = "#{LIB_GEMPATH}/version.rb")
      require(version)
    end
  end
end
