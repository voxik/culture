require "yaml"

module Celluloid
  module Gems
    extend self

    DEFAULT_CFG = ".celluloid.yml"

    def load(cfg)
      return unless File.exists? cfg
      cfg = YAML.load_file(cfg)
      return unless cfg
      cfg["gems"].each do |name, spec|
        yield name, spec
      end
    end

    def gemspec(gem, cfg=DEFAULT_CFG)
      Gems.load(cfg) do |name, spec|
        req = spec["gemspec"] or []
        gem.add_dependency(name, *req)
      end
    end

    def bundler(bundler, cfg=DEFAULT_CFG)
      Gems.load(cfg) do |name, spec|
        req = spec["bundler"] or {}
        req = req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        bundler.gem(name, req)
      end
    end
  end
end
