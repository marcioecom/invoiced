# frozen_string_literal: true

require 'test_helper'

class V1::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)

    @header = {
      'X-User-Email': user.email,
      'X-User-Token': user.authentication_token
    }
  end

  test 'creates account for user' do
    account_params = {
      name: Faker::Company.name,
      tax_payer_id: Faker::Company.ein,
      tax_rate: 7.0,
      address: Faker::Address.full_address,
      default_currency: 'BRL'
    }

    post(
      v1_accounts_path,
      headers: @header,
      params: { account: account_params }
    )

    assert_response :success

    account = JSON.parse(@response.body)['data']['account']

    assert account['name'] == account_params[:name]
    assert account['tax_payer_id'] == account_params[:tax_payer_id]
    assert account['tax_rate'] == account_params[:tax_rate]
    assert account['address'] == account_params[:address]
    assert account['default_currency'] == account_params[:default_currency]
  end
end
