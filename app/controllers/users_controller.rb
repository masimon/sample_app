class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :no_user,      :only => [:new, :create]
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    #if params[:id]
    #  # Signed in already, redirect to root
    #  redirect_to(root_path)
    #end
    @user = User.new
    @title = "Sign up"
  end

  def edit
    @title = "Edit user"
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up - Error... Try Again!"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      @user.password = ""
      @user.password_confirmation = ""
      render 'edit'
    end
  end
 
  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:failure] = "Admin users can't remove own account"
    else
      @user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end

  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      if current_user
        if not current_user.admin?
          redirect_to(root_path)
        end
      else # noone signed in
        redirect_to(signin_path)
      end
#      redirect_to(root_path) unless (current_user ? current_user.admin? : false)
    end
    
    def no_user
      if signed_in?
        flash[:notice]="You must sign out to create a new account"
        redirect_to(root_path) 
      end
    end
    
end

