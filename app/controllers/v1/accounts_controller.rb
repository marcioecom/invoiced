# frozen_string_literal: true

class V1::AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    accounts = current_user.accounts
    render :index, locals: { accounts: accounts }
  end

  def create
    account = current_user.accounts.build(account_params)

    if account.save
      render :create, status: :created, locals: { account: account }
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  def updated
    @account = current_user.accounts.friendly.find(params[:id])

    if @account.update(account_params)
      render :update
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :address, :tax_rate, :tax_payer_id, :default_currency)
  end
end
