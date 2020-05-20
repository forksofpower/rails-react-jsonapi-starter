class Api::ArticlesController < ApplicationController
    before_action :find_article, only: :show
    def index
        @articles = Article.limit(2)
        options = { include: [:author]}

        render json: ArticleSerializer.new(
            @articles.preload(:author), 
            options
        ).serializable_hash
    end

    def show
        options = {:include => [:author]}
        render json: ArticleSerializer.new(@article, options).serializable_hash
    end

    private
        def find_article
            @article = Article.find(params[:id])
        end
end