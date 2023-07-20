# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :contacts
  belongs_to :account
end
