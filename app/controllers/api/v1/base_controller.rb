module Api
  module V1
    class BaseController < ActionController::API
      include JwtAuthenticatable
      rescue_from ActiveRecord::RecordNotFound, with: -> { render json: { error: "No encontrado" }, status: :not_found }
      rescue_from ActiveRecord::RecordInvalid,  with: ->(e) { render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity }
    end
  end
end