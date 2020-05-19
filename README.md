# Rails 6 + React + jsonapi serializer


### Getting Started
First generate a new rails api:
```shell
rails new rails-jsonapi --api
cd rails-jsonapi
```

Set generator configs in `config/application.rb`:
```ruby
module RailsJsonapi
    class Application < Rails::Application
        ...
        # generator config
        config.generators do |g|
        g.test_framework  false
        g.stylesheets     false
        g.helper          false
        g.javascripts     false
        end
    end
end
```