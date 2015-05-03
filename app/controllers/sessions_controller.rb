class SessionsController < ApplicationController

  # POST /users/sign_in
  def create
    user = User.find_by_email(sign_in_params[:email])
    if( user && user.authenticate(sign_in_params[:password]) )
      render json: user.reload, status: :created
    else
      render json: { credentials: "Invalid email or password" }, status: :unauthorized
    end
  end


  # DELETE /users/sign_out
  def destroy
    user = current_user
    if user
      user.sign_out
      head :ok
    else
      head :unauthorized
    end
  end

  # GET /user
  def show
    if current_user
      head :ok
    else
      head :unauthorized
    end
  end

  protected
  def sign_in_params
    params.permit(:email,:password)
  end
end
