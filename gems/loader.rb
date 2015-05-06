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
    extend Forwardable
    def_delegators :"Celluloid::Sync", :gem_name

    undef gems rescue nil
    def gems
      File.expand_path("../dependencies.yml", __FILE__)
    end

    unless @dependencies ||= nil
      @dependencies = YAML.load_file(gems) if File.exist?(gems)
    end

    unless @dependencies.is_a?(Hash) && @dependencies.any?
      fail "Celluloid cannot find its dependencies."
    end

    def core_gem?(name=gem_name)
      return false unless @dependencies[gem_name].is_a? Hash
      @dependencies["#{name}"]["dependency"] == "core"
    end

    # Returns true if this gem is *not* in the dependencies list at all,
    # and the name of the gem passed in *is* the core gem.
    def needs_core?(name)
      return false if @dependencies.keys.include?(gem_name)
      core_gem?(name)
    end

    def gemspec(gem)
      loader do |name, spec|
        req = spec["gemspec"] || []
        # Rules for dependencies, to avoid so-called circular dependency:
        # - Only the core gem lists all the modules as runtime depedencies.
        # - If this gem is not in the dependencies list, then it needs the core gem at runtime;
        #   the module gems are development dependencies only.
        # - If the dependency is a module, it is only a development dependency to other modules,
        #   and even the core gem is a development dependency. It is not expected to be used alone.
        meth = case spec["dependency"]
               when "core", "module"
                 # For the core gem, all modules are runtime dependencies.
                 # For external gems, only the core gem is a runtime dependency.
                 if core_gem? || needs_core?(name)
                   :add_runtime_dependency
                 else
                   :add_development_dependency
                 end
               when "development"
                 :add_development_dependency
               else
                 :add_dependency
               end
        gem.send(meth, name, *req)
      end
    end

    def gemfile(dsl)
      loader do |name, spec|
        version = spec["version"] ||= ">= 0"
        params = [name, version]
        req = spec["bundler"] || {}
        params << req.each_with_object({}) { |(k, v), o| o[k.to_sym] = v }
        current = dsl.dependencies.find { |d| d.name == name }
        dsl.dependencies.delete(current) if current
        dsl.gem(*params)
      end
    end

    private

    def loader
      @dependencies.each do |name, spec|
        next if name == gem_name
        spec ||= {}
        yield name, spec
      end
    end
  end
end
