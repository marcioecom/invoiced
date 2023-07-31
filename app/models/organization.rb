# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :contacts
  belongs_to :account

  validates :name, presence: true
  validates :address, presence: true
  validates :tax_payer_number, presence: true
end
