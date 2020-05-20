class ArticleSerializer < ApplicationSerializer
  attributes :title, :body
  belongs_to :author
end
