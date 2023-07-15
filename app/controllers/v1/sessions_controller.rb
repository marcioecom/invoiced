# frozen_string_literal: true

class V1::SessionsController < ApplicationController
  def create
    @user = User.where(email: params[:email]).first

    return render json: { error: 'user not found' }, status: :not_found if @user.nil?

    if @user.valid_password?(params[:password])
      render :create, status: :created
    else
      head(:unauthorized)
    end
  end

  def destroy; end
end
