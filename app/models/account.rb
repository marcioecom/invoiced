# frozen_string_literal: true

class Account < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :address, presence: true
  validates :tax_rate, presence: true
  validates :tax_payer_id, presence: true
  validates :default_currency, presence: true

  has_many :organizations
  has_many :contacts, through: :organizations

  belongs_to :owner, class_name: 'User'
end
