# frozen_string_literal: true

class V1::ContactsController < ApplicationController
  def index
    @contacts = Contact.ActionController
    render json: @contacts, status: :ok
  end
end
