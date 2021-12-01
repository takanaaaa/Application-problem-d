class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

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
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:tag_name].split(nil)
    if @book.save
      @book.save_tag(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @tag_list = @book.tags.pluck(:tag_name).join(" ")
  end

  def update
    @book = Book.find(params[:id])
    tag_list = params[:book][:tag_name].split(nil)
    if @book.update(book_params)
      @book.save_tag(tag_list)
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

  def search
    word = params[:word]
    tag = Tag.where(["tag_name LIKE?", "#{word}"])
    @books = Book.left_joins(:tag_maps).where(:tag_maps => {:tag_id => tag.ids})
    @book = Book.new
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :evaluation)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

end
