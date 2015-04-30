require "yaml"

module Celluloid
  module Sync
    def self.gems(loader)
      case loader.class.name
      when "Gem::Specification"
        Gems.gemspec(loader)
      when "Bundler::Dsl"
        Gems.gemfile(loader)
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

    unless @dependencies.is_a?(Hash) && @dependencies.any?
      fail "Celluloid cannot find its dependencies."
    end

    def gemspec(gem)
      puts "run gemspec"
      loader do |name, spec|
        req = spec["gemspec"] || []
        if spec["dependency"] == "runtime"
          gem.add_runtime_dependency(name, *req)
        else
          gem.add_development_dependency(name, *req)
        end
      end
    end

    def gemfile(dsl)
      loader do |name, spec|
        version = spec["version"] ||= ">= 0"
        params = [ name, version ]
        req = spec["bundler"] || {}
        params << req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        if current = dsl.dependencies.find { |d| d.name == name }
          puts "#{current.requirements > version}"
          dsl.dependencies.delete(current)
        end
        dsl.gem(*params)
        current = dsl.dependencies.find { |d| d.name == name }
        puts "added: #{current}"
      end
    end

    private

    def loader
      @dependencies.each do |name, spec|
        next if name == SELF
        spec ||= {}
        yield name, spec
      end
    end
  end
end
