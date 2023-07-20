# frozen_string_literal: true

class AddIndexForAccountSlug < ActiveRecord::Migration[7.0]
  def change
    add_index :accounts, :slug, unique: true
  end
end
