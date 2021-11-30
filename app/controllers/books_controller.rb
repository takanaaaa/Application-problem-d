class BooksController < ApplicationController

  def show
    @newBook = Book.new
    @book = Book.find(params[:id])
  end

  def index
    @book = Book.new
    if params[:sort] == "newArrive"
      @books = Book.order(created_at: :desc)
    elsif params[:sort] == "evaluation"
      @books = Book.order(evaluation: :desc)
    else
      @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :evaluation)
  end

end
