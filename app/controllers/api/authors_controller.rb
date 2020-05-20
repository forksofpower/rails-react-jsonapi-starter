class Api::AuthorsController < ApplicationController
    before_action :find_author, only: :show
    def index
        @authors = Author.all
        options = { include: [:articles]}
        render json: AuthorSerializer.new(@authors, options).serializable_hash
    end

    def show
        options = { include: [:articles]}
        render json: AuthorSerializer(@author, options).serializable_hash
    end
    
    private
        def find_author
            @author = Author.find(params[:id])
        end
end