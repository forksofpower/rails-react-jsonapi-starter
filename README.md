# Rails 6 + React + jsonapi Start


### Getting Started
First generate a new rails api:
```shell
rails new rails-jsonapi --api --database=postgresql
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

Don't forget to add the `has_many` macro to the author model to complete the association.
```ruby
# app/models/author.rb
class Author < ApplicationRecord
    has_many :articles
end
```

Add some seed data to get started:
```shell
bundle add faker
```

```ruby
# db/seeds.rb
require 'faker'

Author.delete_all
Article.delete_all


25.times {
    Author.create( name: Faker::Book.unique.author)
}

500.times {
    Article.create({
        title: Faker::Book.title,
        body: Faker::Lorem.paragraphs(number: rand(5..7)),
        author: Author.limit(1).order("RANDOM()").first # sql random
    })
}
```

Setup the database, run migrations and generate seed data.
```shell
rails db:create db:migrate db:seed
```

## Setup `Api` module
Wrap the generated routes in a namespace block.
```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    resources :articles
    resources :authors
  end
end
```
Create a new `api` directory in `app/controllers` and move the generated controllers into that directory.
```shell
mkdir app/controllers/api
mv app/controllers/{articles,}
```
 Setup `ArticleController` and `AuthorController` with basic actions `:index` and `:show`. Take note of the `Api` module prefix.
```ruby
# app/controllers/articles_controller.rb
class Api::ArticlesController < ApplicationController
    before_action :find_article, only: :show
    def index
        @articles = Article.all
        render json: @articles
    end

    def show
        render json: @article
    end

    private
        def find_article
            @article = Article.find(params[:id])
        end
end
```
```ruby
# app/controllers/author_controller.rb
class AuthorsController < ApplicationController
    before_action :find_author, only: :show
    def index
        @authors = Author.all
        render json: @authors
    end

    def show
        render json: @author
    end
    
    private
        def find_author
            @author = Author.find(params[:id])
        end
end
```

## Fast JSONapi
Add the `fast_jsonapi` gem to the project.
```shell
bundle add 'fast_jsonapi'
```
We can now use the serializer generator that is bundled with `fast_jsonapi`.
```shell
rails g serializer Article title body
rails g serializer Author name
```

This will create two files:
```ruby
# app/serializers/article_serializer.rb
class ArticleSerializer < ApplicationSerializer
  attributes :title, :body
  belongs_to :author
end
```
```ruby
# app/serializers/author_serializer.rb
class AuthorArticleSerializer < ApplicationSerializer
  attributes :name
end
```

To keep it simple, we will only define the associations on the `ArticleSerializer`.
```ruby
# app/serializers/article_serializer.rb
class ArticleSerializer < ApplicationSerializer
  attributes :title, :body
  belongs_to :author
end
```

## Check for understanding
Run `rails s` to start up the rails server.

If you're not already using a rest client such as [Insomnia](https://insomnia.rest/) or [Postman](https://www.postman.com/), get with the times. Make a `GET` request to `localhost:3000/articles`. The response should look like this:
```json
{
  "data": [
    {
      "id": "1",
      "type": "article",
      "attributes": {
        "title": "The Last Enemy",
        "body": "..."
      },
      "relationships": {
        "author": {
          "data": {
            "id": "9",
            "type": "author"
          }
        }
      }
    },
    {
      "id": "2",
      "type": "article",
      "attributes": {
        "title": "Cover Her Face",
        "body": "..."
      },
      "relationships": {
        "author": {
          "data": {
            "id": "3",
            "type": "author"
          }
        }
      }
    },
    {
      "id": "3",
      "type": "article",
      "attributes": {
        "title": "Catcher In The Rye",
        "body": "..."
      },
      "relationships": {
        "author": {
          "data": {
            "id": "3",
            "type": "author"
          }
        }
      }
    }
  ],
  "included": [
    {
      "id": "9",
      "type": "author",
      "attributes": {
        "name": "Tawna Denesik PhD"
      }
    },
    {
      "id": "3",
      "type": "author",
      "attributes": {
        "name": "Mrs. Carmela Herzog"
      }
    }
  ]
}
```
This is frankly a confusing format to wrap your head around at first, but once we dig in you will understand the reasoning. YOU SHOULD READ ABOUT THIS YOURSELF...


## Setup React

