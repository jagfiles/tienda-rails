module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_from_jwt!
  end

  private

  def authenticate_from_jwt!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render json: { error: "Token requerido" }, status: :unauthorized unless token

    payload = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256").first
    @current_user = User.find(payload["sub"])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: "Token inválido" }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end