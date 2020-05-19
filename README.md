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

Generate the models and controllers:
```shell
rails g resource Author name:string
rails g resource Article title:string body:text author:references
```

Don't forget to add the `has_many` macro to the author model to complete the association:
```ruby
# app/models/author.rb
class Author < ApplicationRecord
    has_many :articles
end
```