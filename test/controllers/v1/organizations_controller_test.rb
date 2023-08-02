# frozen_string_literal: true

require 'test_helper'

class V1::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)
    @account = accounts(:leap_stark)

    @header = {
      'X-User-Email': user.email,
      'X-User-Token': user.authentication_token
    }
  end

  test 'lists out organizations for account' do
    org_one = organizations(:one)
    org_two = organizations(:two)

    get v1_organizations_path(@account)

    organization_ids = JSON.parse(@response.body)['data'].map do |org|
      org['id']
    end

    assert_response :success
    assert_includes organization_ids, org_one.id
    assert_not_includes organization_ids, org_two.id
  end

  test 'should create organization under the correct account' do
    organization_params = {
      name: Faker::Company.name,
      address: Faker::Address.full_address,
      tax_payer_number: Faker::Company.ein
    }

    post(
      v1_organizations_path(@account),
      headers: @header,
      params: { organization: organization_params }
    )

    assert_response :created

    organization = JSON.parse(@response.body)['data']['organization']

    assert organization['name'] == organization_params[:name]
    assert organization['address'] == organization_params[:address]
    assert organization['tax_payer_number'] == organization_params[:tax_payer_number]
  end

  test 'should return unprocessable entity' do
    organization_params = {
      name: Faker::Company.name,
      tax_payer_number: ''
    }

    post(
      v1_organizations_path(@account),
      headers: @header,
      params: { organization: organization_params }
    )

    assert_response :unprocessable_entity

    response = JSON.parse(@response.body)['errors']

    assert response['address'].include?("can't be blank")
    assert response['tax_payer_number'].include?("can't be blank")
  end

  test 'should return specific organization' do
    organization = organizations(:one)

    get v1_organization_path(@account, id: organization.id)

    assert_response :success

    response = JSON.parse(@response.body)['data']['organization']

    assert response['name'] == organization.name
    assert response['address'] == organization.address
    assert response['tax_payer_number'] == organization.tax_payer_number
  end
end
