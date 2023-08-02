# frozen_string_literal: true

class V1::SessionsController < ApplicationController
  def show
    current_user ? head(:ok) : head(:unauthorized)
  end

  def create
    @user = User.where(email: params[:email]).first

    return render json: { error: 'user not found' }, status: :not_found if @user.nil?

    if @user.valid_password?(params[:password])
      render :create, status: :created, locals: { token: jwt }
    else
      render json: { error: 'invalid credentials' }, status: :unauthorized
    end
  end

  def destroy
    current_user&.authentication_token = nil
    if current_user&.save
      head(:ok)
    else
      render json: { error: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def jwt
    JWT.encode(
      { user_id: @user.id, exp: (Time.now + 2.weeks).to_i },
      Rails.application.secrets.secret_key_base,
      'HS256'
    )
  end
end
