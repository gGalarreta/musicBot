class SessionController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new session_params
    if @user.save
       p "hola"
    end
  end

  private

    def session_params
      params.require(:user).permit(:email, :password)
    end

end
