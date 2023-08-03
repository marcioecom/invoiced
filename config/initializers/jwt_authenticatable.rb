# frozen_string_literal: true

module Devise
  module Strategies
    class JWTAuthenticatable < Base
      def authenticate!
        token = retrieve_token
        return raise(:invalid) unless token.present?

        data = WebToken.decode(token)
        return raise(:invalid) if data == :expired

        resource = mapping.to.find(data['user_id'])
        return raise(:not_found_in_database) unless resource

        success! resource
      end

      private

      def retrieve_token
        auth_header.present? && auth_header.split(' ').last
      end

      def auth_header
        request.headers['Authorization']
      end
    end
  end
end
