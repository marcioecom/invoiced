# frozen_string_literal: true

module V1
  module Contacts
    # Response for contacts controller
    module Response
      extend ActiveSupport::Concern

      def create_and_reder_contact(contact)
        contact.save && render(:create, status: :created, locals: { contact: contact })
      end

      def update_and_render_contact(contact, params)
        contact.update(params) && render(:update, status: :ok, locals: { contact: contact })
      end

      def destroy_and_render_contact(contact)
        contact.destroy && head(:no_content)
      end

      def render_invalid_response(contact)
        render json: contact.errors, status: :unprocessable_entity
      end
    end
  end
end
