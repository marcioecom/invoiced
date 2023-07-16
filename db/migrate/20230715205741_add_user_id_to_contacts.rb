# frozen_string_literal: true

class AddUserIdToContacts < ActiveRecord::Migration[7.0]
  def change
    add_reference :contacts, :user, index: true, foreign_key: true
  end
end
