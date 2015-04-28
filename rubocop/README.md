# About
[RuboCop](https://github.com/bbatsov/rubocop) is a ruby static code analyzer.
It's more than just a lint. It verifies the code against ruby best practices and performs code correctness analysis.
Celluloid culture doesn't always agree with all rubocop default policies and so we provide a rubocop configuration file that overrides its default behavior.

# Integration
To automate the process, integrate `celluloid/culture` as a GIT submodule of your project, and include `culture/rupocop/.rubocop.yml` in your default rubocop config.

##### Add celluloid/culture as GIT submodule:
```sh
  git submodule add http://github.com:celluloid/culture.git
```

##### Include `culture/rupocop/rubocop.yml` in the `.rubocop.yml` in the root of your project:
```yml
inherit_from:
  - culture/rubocop/rubocop.yml
```

You are free to override other rules and specify the paths that rubocop should bypass, but that is not recommended.

# How to add rubocop to your project

##### Add rubocop gem into the bundler `Gemfile`:
```ruby
gem 'rubocop', require: false
```

##### Add a 'rubocop' target in your `Rakefile`

# Hints
It's possible to use rubocop for autocorrection of minor problems.

Always verify these changes by running: `bundle exec rubocop`

And once you are ready to auto-corret the issues you are shown, run it with the `-a` option:
```sh
bundle exec rubocop -a
```
