class ApplicationController < ActionController::Base
  # configuración de devise que verifica estar logged in antes de entrar a cualquier vista
  before_action :authenticate_user!
end
