require "yaml"

module Celluloid
  module Sync
    def self.gems(loader)
      case loader.class
      when Gem::Specification
        Gems.gemspec(loader)
      when Bundler::Dsl
        Gems.bundler(loader)
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
      @dependencies = if File.exist?(GEMS)
        YAML.load_file(GEMS)
      end
    end

    unless @dependencies.is_a? Hash and @dependencies.any?
      fail "Celluloid cannot find its dependencies."
    end

    puts "Celluloid dependencies prepared."

    def loader
      @dependencies.each{ |name, spec|
        next if name == SELF
        puts "Updating #{name}?"
        yield name, spec
      }
    end

    def gemspec(gem)
      puts "Priming #{SELF}.gemspec."
      loader { |name, spec|
        req = spec["gemspec"] || []
        gem.add_dependency(name, *req)
      }
    end

    def gemfile(dsl)
      puts "Priming Gemfile."
      loader { |name, spec|
        req = spec["bundler"] || {}
        req = req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        dsl.gem(name, req)
      }
    end
  end
end
