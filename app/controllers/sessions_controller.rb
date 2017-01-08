class SessionsController < ApplicationController
  def create
    user = User.find_by(email: sign_in_params[:email])

    if user && user.authenticate(sign_in_params[:password])
      session[:user_id] = user.id
      redirect_to user_tasks_path(user_id: user.id)
    else
      flash.now.alert = 'Email or Password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  private

  def sign_in_params
    params.require(:sessions).permit(:email, :password)
  end
end
