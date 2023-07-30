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
end
