class ApplicationController < ActionController::Base
  # configuración de devise que verifica estar logged in antes de entrar a cualquier vista
  before_action :authenticate_with_token
  before_action :authenticate_user!

  private

  def authenticate_with_token
    if params[:api_token]
      user = User.find_by(api_token: params[:api_token])
      sign_in(user)
    end
  end
end
