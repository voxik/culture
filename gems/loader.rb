require "yaml"

module Celluloid
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

    @@dependencies ||= nil
    unless @dependencies
      @@dependencies = if File.exist?(GEMS)
        YAML.load_file(GEMS)
      end
    end

    unless @@dependencies.is_a? Hash and @@dependencies.any?
      raise "Celluloid cannot find its dependencies."
    end

    def load
      @@dependencies.each do |name, spec|
        next if name == SELF
        yield name, spec
      end
    end

    def gemspec(gem)
      Gems.load do |name, spec|
        req = spec["gemspec"] || []
        gem.add_dependency(name, *req)
      end
    end

    def bundler(bundler)
      Gems.load do |name, spec|
        req = spec["bundler"] || {}
        req = req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        bundler.gem(name, req)
      end
    end
  end
end
