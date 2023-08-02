# frozen_string_literal: true

class V1::OrganizationsController < ApplicationController
  def index
    organizations = current_account.organizations.order(created_at: :desc)
    render :index, locals: { organizations: organizations }
  end

  def show
    organization = current_account.organizations.find_by(id: params[:id])

    if organization
      render :show, locals: { organization: organization }
    else
      render json: { errors: 'organization not found' }, status: :not_found
    end
  end

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
