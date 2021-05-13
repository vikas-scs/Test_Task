class V1::BooksController < ApplicationController
	def index
    render json: Book.all
  end
	def create
      book = Book.new(book_params)
      book.save
      render json: book
	end
	def show
		@book = Book.where(id: params[:id])
		render json: @book ,status: :created
		
	end
	def update
		book = Book.where(id: params[:id])
        book.update(book_params)
         render json: book
	end

	def destroy
		Book.destroy(params[:id])
	end


	private
	def book_params
		params.require(:book).permit(:name, :author)
	end
end
