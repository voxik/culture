module Celluloid
  module Sync
    GEM_PATH ||= File.expand_path("../../", __FILE__)
    $LOAD_PATH.push(GEM_PATH)

    # TODO: This will likely need to be done differently if INSIDE a cut gem.

    puts "Calling: #{Process.argv0}"
    puts "Synchronizing Celluloid Culture //"
    `cd #{GEM_PATH}/culture; git pull origin master`

    require("#{GEM_PATH}/culture/gems/loader")

    GEM = Celluloid::Gems::SELF unless defined? GEM
    LIB_PATH = File.expand_path("../../lib", __FILE__)
    LIB_GEMPATH = "#{LIB_PATH}/#{GEM.split('-').join('/')}"
    $LOAD_PATH.push(LIB_PATH)

    if File.exist?(version = "#{LIB_GEMPATH}/version.rb")
      require(version)
    end
  end
end
