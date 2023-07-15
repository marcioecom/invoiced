# frozen_string_literal: true

class V1::ContactsController < ApplicationController
  def index
    @contacts = Contact.all
    render json: @contacts, status: :ok
  end

  def create
    @contact = Contact.new(contact_params)

    @contact.save
    render json: @contact, status: :created
  end

  def destroy
    @contact = Contact.where(id: params[:id]).first

    return render json: { error: 'contact not found' }, status: :not_found if @contact.nil?

    if @contact.destroy
      head(:no_content)
    else
      head(:unprocessable_entity)
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email)
  end
end
