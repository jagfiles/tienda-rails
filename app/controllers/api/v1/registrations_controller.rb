module Api
  module V1
    class RegistrationsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        user = User.new(user_params)
        if user.save
          render json: {
            message: "Usuario registrado",
            token: user.generate_jwt,
            user: { id: user.id, email: user.email, full_name: user.full_name, role: user.role }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone)
      end
    end
  end
end