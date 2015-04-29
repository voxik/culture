require "yaml"

module Celluloid
  module Sync
    def self.gems(loader)
      case loader.class.name
      when "Gem::Specification"
        Gems.gemspec(loader)
      when "Bundler::Dsl"
        Gems.gemfile(loader)
      else
        puts "Fell through: #{loader}"
      end
    end
  end
  module Gems
    extend self

    # TODO: Better way to do this I'm sure.
    SELF = begin
      path = __FILE__.split("/")
      path.pop(3)
      path.last
    end

    GEMS = begin
      path = File.expand_path(__FILE__).split("/")
      path.pop
      path.push("dependencies.yml")
      path.join("/")
    end
    # /TODO

    unless @dependencies ||= nil
      @dependencies = YAML.load_file(GEMS) if File.exist?(GEMS)
    end

    unless @dependencies.is_a? Hash && @dependencies.any?
      fail "Celluloid cannot find its dependencies."
    end

    def loader
      @dependencies.each do |name, spec|
        next if name == SELF
        yield name, spec
      end
    end

    def gemspec(gem)
      loader do |name, spec|
        req = spec["gemspec"] || []
        gem.add_dependency(name, *req)
      end
    end

    def gemfile(dsl)
      loader do |name, spec|
        req = spec["bundler"] || {}
        req = req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        dsl.gem(name, req)
      end
    end
  end
end
