# frozen_string_literal: true

class V1::ContactsController < ApplicationController
  def index
    @contacts = current_user.contacts.order(created_at: :desc)

    render :index, status: :ok
  end

  def create
    @contact = current_user.contacts.build(contact_params)

    if @contact.save
      render :create, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact = current_user.contacts.where(id: params[:id]).first

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
