# frozen_string_literal: true

require 'test_helper'

class V1::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)

    @header = {
      'X-User-Email': user.email,
      'X-User-Token': user.authentication_token
    }
  end

  test 'should create organization under the correct account' do
    account = accounts(:leap_stark)

    organization_params = {
      name: Faker::Company.name,
      address: Faker::Address.full_address,
      tax_payer_number: Faker::Company.ein
    }

    post v1_organizations_path(
      account_id: account.id,
      params: { organization: organization_params }
    )

    assert_response :created

    organization = JSON.parse(@response.body)['data']['organization']

    assert organization['name'] == organization_params[:name]
    assert organization['address'] == organization_params[:address]
    assert organization['tax_payer_number'] == organization_params[:tax_payer_number]
  end

  test 'lists out organizations for account' do
    account = accounts(:leap_stark)

    org_one = organizations(:one)
    org_two = organizations(:two)

    get v1_organizations_path(account_id: account.id)

    organization_ids = JSON.parse(@response.body)['data'].map do |org|
      org['id']
    end

    assert_response :success
    assert_includes organization_ids, org_one.id
    assert_not_includes organization_ids, org_two.id
  end
end
