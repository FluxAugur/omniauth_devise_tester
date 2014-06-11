class UsersController < ApplicationController
  # before_filter :authenticate_user!
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_action :set_user, :finish_signup, except: [:new, :create]
  before_filter :set_user, only: [:show, :edit, :update]
  before_filter :validate_identity_for_user, only: [:edit, :update]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def finish_signup
    if request.patch? && params[:user]
      if current_user.update(user_params)
        # current_user.skip_reconfirmation!
        sign_in(current_user, bypass: true)
        redirect_to current_user, notice: "User was successfully updated."
      else
        @show_errors = true
      end
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def validate_identity_for_user
      redirect_to root_path unless @user == current_user
    end

    def user_params
      accessible = [:name, :email]
      accessible << [:password, :password_confirmation] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
