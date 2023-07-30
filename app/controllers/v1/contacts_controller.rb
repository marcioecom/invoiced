# frozen_string_literal: true

class V1::ContactsController < ApplicationController
  def index
    @contacts = current_account.contacts.order(created_at: :desc)

    render :index, status: :ok
  end

  def create
    @contact = current_organization.contacts.build(contact_params)

    if @contact.save
      render :create, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def update
    @contact = current_organization.contacts.find(params[:id])

    return render json: { error: 'contact not found' }, status: :not_found if @contact.nil?

    if @contact.update(contact_params)
      render :update, status: :ok
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact = current_organization.contacts.find(params[:id])

    return render json: { error: 'contact not found' }, status: :not_found if @contact.nil?

    if @contact.destroy
      head(:no_content)
    else
      head(:unprocessable_entity)
    end
  end

  private

  def current_account
    @current_account ||= Account.friendly.find(params[:account_id])
  end

  def current_organization
    @current_organization ||= current_account.organizations.find(params[:organization_id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email)
  end
end
