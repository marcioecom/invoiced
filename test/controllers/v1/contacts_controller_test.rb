# frozen_string_literal: true

require 'test_helper'

class V1::ContactsControllerTest < ActionDispatch::IntegrationTest
  test 'should get only contacts for leap stark' do
    account = accounts(:leap_stark)

    not_leap_stark_contact = contacts(:two)

    get v1_contacts_path(account_id: account.id)

    contacts = JSON.parse(@response.body)['data']

    contact_ids = contacts.map { |contact| contact['id'] }

    assert_response :success
    assert_not_includes contact_ids, not_leap_stark_contact.id
  end

  test 'should create contact under the correct org' do
    account = accounts(:leap_stark)
    org = account.organizations.first

    first_name = Faker::Name.name
    last_name = Faker::Name.name
    email = Faker::Internet.email

    post(
      v1_organization_contacts_path(account_id: account.id, organization_id: org.id),
      params: {
        contact: {
          first_name: first_name,
          last_name: last_name,
          email: email
        }
      }
    )

    assert_response :created

    contact = JSON.parse(@response.body)['data']['contact']

    assert_equal contact['firstName'], first_name
    assert_equal contact['lastName'], last_name
    assert_equal contact['email'], email
  end

  test 'should update contact under the correct org' do
    account = accounts(:leap_stark)
    org = account.organizations.first
    contact = contacts(:one)

    first_name = Faker::Name.name
    last_name = Faker::Name.name
    email = Faker::Internet.email

    put(
      v1_organization_contact_path(account_id: account.id, organization_id: org.id, id: contact.id),
      params: {
        contact: {
          first_name: first_name,
          last_name: last_name,
          email: email
        }
      }
    )

    assert_response :ok

    res_contact = JSON.parse(@response.body)['data']['contact']

    assert_equal first_name, res_contact['firstName']
    assert_equal last_name, res_contact['lastName']
    assert_equal email, res_contact['email']
  end

  test 'should destroy contact under the correct org' do
    account = accounts(:leap_stark)
    org = account.organizations.first
    contact = contacts(:one)

    delete(
      v1_organization_contact_path(account_id: account.id, organization_id: org.id, id: contact.id)
    )

    assert_response :no_content
  end
end
