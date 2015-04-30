module Celluloid
  module Sync
    GEM_PATH ||= File.expand_path("../../", __FILE__)
    $LOAD_PATH.push(GEM_PATH)

    celluloid = File.expand_path('../celluloid/celluloid.gemspec', GEM_PATH)
    puts "celluloid"
    if File.exist? celluloid
      puts "found celluloid locally"
      $LOAD_PATH.unshift(File.expand_path( '../lib/', celluloid))
    end
    # TODO: This will likely need to be done differently if INSIDE a cut gem.

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
