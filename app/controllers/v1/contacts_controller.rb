# frozen_string_literal: true

class V1::ContactsController < ApplicationController
  include V1::Contacts::Response

  def index
    @contacts = current_account.contacts.order(created_at: :desc)

    render :index, status: :ok
  end

  def create
    contact = current_organization.contacts.build(contact_params)

    create_and_reder_contact(contact) || render_invalid_response(contact)
  end

  def update
    contact = current_organization.contacts.find(params[:id])

    return render json: { error: 'contact not found' }, status: :not_found if contact.nil?

    update_and_render_contact(contact, contact_params) || render_invalid_response(contact)
  end

  def destroy
    contact = current_organization.contacts.find(params[:id])

    return render json: { error: 'contact not found' }, status: :not_found if contact.nil?

    destroy_and_render_contact(contact) || render_invalid_response(contact)
  end

  private

  def current_organization
    @current_organization ||= current_account.organizations.find(params[:organization_id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email)
  end
end
