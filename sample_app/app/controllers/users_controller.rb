class UsersController < ApplicationController
 before_action :signed_in_user, only: [:index,:edit, :update, :destroy]
 before_action :correct_user,   only: [:edit, :update]
 before_action :admin_user,     only: :destroy

  def index
   @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
     @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)    # 実装は終わっていないことに注意!
    if @user.save
    	sign_in @user
    	flash[:success] = "Welcome to the Sample App!"
    	redirect_to @user
      # 保存の成功をここで扱う。
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
# Before actions

    

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  
    
 
end

