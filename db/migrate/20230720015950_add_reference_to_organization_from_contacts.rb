# frozen_string_literal: true

class AddReferenceToOrganizationFromContacts < ActiveRecord::Migration[7.0]
  def change
    add_reference :contacts, :organization, index: true, foreign_key: true
    remove_reference :contacts, :user, index: true
  end
end
