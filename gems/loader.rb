require "yaml"

module Celluloid
  module Gems
    extend self

    DEFAULT_CFG = ".celluloid.yml"

    def load(cfg)
      return unless File.exist? cfg
      cfg = YAML.load_file(cfg)
      return unless cfg
      cfg["gems"].each do |name, spec|
        self? name
        yield name, spec
      end
    end

    # Avoid gems loading themselves.
    def self? name
      puts "self? #{name} #{__FILE__}"
    end

    def gemspec(gem, cfg=DEFAULT_CFG)
      Gems.load(cfg) do |name, spec|
        req = spec["gemspec"] || []
        gem.add_dependency(name, *req)
      end
    end

    def bundler(bundler, cfg=DEFAULT_CFG)
      Gems.load(cfg) do |name, spec|
        req = spec["bundler"] || {}
        req = req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        bundler.gem(name, req)
      end
    end
  end
end
