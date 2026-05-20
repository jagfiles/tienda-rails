module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        user = User.find_by(email: params.dig(:user, :email))
        if user&.valid_password?(params.dig(:user, :password))
          render json: {
            message: "Sesión iniciada",
            token: user.generate_jwt,
            user: { id: user.id, email: user.email, full_name: user.full_name, role: user.role }
          }
        else
          render json: { error: "Email o contraseña incorrectos" }, status: :unauthorized
        end
      end
    end
  end
end