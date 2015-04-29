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

    unless @@dependencies ||= nil
      @@dependencies = if File.exist?(GEMS)
        YAML.load_file(GEMS)
      end
    end

    unless @@dependencies.is_a? Hash and @@dependencies.any?
      raise "Celluloid cannot find its dependencies."
    end

    def loader
      @@dependencies.each{ |name, spec|
        next if name == SELF
        puts "Updating #{name}?"
        yield name, spec
      }
    end

    def gemspec(gem)
      loader { |name, spec|
        req = spec["gemspec"] || []
        gem.add_dependency(name, *req)
      }
    end

    def gemfile(dsl)
      loader { |name, spec|
        req = spec["bundler"] || {}
        req = req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        dsl.gem(name, req)
      }
    end
  end
end
