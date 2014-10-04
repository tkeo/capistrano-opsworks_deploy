# Capistrano::OpsworksDeploy

deploy app using AWS OpsWorks API with capistrano 3

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-opsworks_deploy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-opsworks_deploy

## Usage

Add this line to Capfile

```
require 'capistrano/opsworks_deploy'
```

Set AWS credentials to environment variables

```
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

Write OpsWorks settings to deploy config file

```ruby
set :opsworks_stack_id, '...'
set :opsworks_app_id, '...'
set :opsworks_instance_ids, ['...']
```

Deploy app

```
$ cap opsworks:deploy
```

Deploy app with migration

```
$ cap opsworks:deploy:migrate
```

### Executing recipes

You can also execute recipes by writing task

```ruby
desc 'execute recipe foobar'
task :foobar do
  set :opsworks_recipes, 'foobar'
  invoke 'opsworks:execute_recipes'
end
```

## Contributing

1. Fork it ( https://github.com/tkeo/capistrano-opsworks_deploy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
