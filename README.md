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

Add `ArticleController` and `AuthorController` with basic actions `:index` and `:show`.
```ruby
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
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
bundle add 'gast_jsonapi'
```
We can now use the serializer generator that is bundled with `fast_jsonapi`.
