class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, only: [:show, :destroy]

  def index
    @posts = Post.limit(10).includes(:photos, :user).order('created_at DESC')
  end

  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    if @post.photos.present?
      @post.save
      redirect_to root_path
      flash[:notice] = "投稿が保存されました"
    else
      render :new
      flash[:alert] = "投稿に失敗しました"
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      flash[:notice] = "投稿が削除されました" if @post.destroy
    else
      flash[:alert] = "投稿の削除に失敗しました"
    end
    redirect_to root_path
  end

  private
    def post_params
      params.require(:post).permit(:caption, photos_attributes: [:image]).merge(user_id: current_user.id)
    end

    def find_post
      @post = Post.find(params[:id])
    end
end
