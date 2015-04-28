# About
[RuboCop](https://github.com/bbatsov/rubocop) is a ruby static code analyzer.
It's more than just a lint. It verifies the code against ruby best practices and performs code correctness analysis.
Celluloid community doesn't always agree with all rubocop default policies and thereby provides rubocop configuration file that overrides its default behaviour.

# Integration
To automate the process, mind to integrate celluloid/culture as GIT submodule of your project and include culture/rupocop/.rubocop.yml into your default rubocop config.

 - add celluloid/culture as GIT submodule:
```sh
  git submodule add git@github.com:celluloid/culture.git
```
Include culture/rupocop/rubocop.yml into the .rubocop.yml within the root of your project:
```yml
inherit_from:
  - culture/rubocop/rubocop.yml

```

You are free to override other rules and specify the paths that rubocop should bypass though it's not recommended.

# How to add rubocop to your project
- add rubocop gem into the bundler Gemfile:
```ruby
gem 'rubocop', require: false
```
- add 'rubocop' target into your Rakefile

# Hints
It's possible to use rubocop for autocorrection of minor problems. Always verify these changes.
To do that run it with -a option:
```sh
bundler exec rubocop -a
```
