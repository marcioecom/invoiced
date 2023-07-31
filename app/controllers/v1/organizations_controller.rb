# frozen_string_literal: true

class V1::OrganizationsController < ApplicationController
  def create
    organization = current_account.organizations.build(organization_params)

    if organization.save
      render :create, locals: { organization: organization }, status: :created
    else
      render json: { errors: organization.errors }, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :address, :tax_payer_number)
  end
end
