# frozen_string_literal: true

json.data do
  json.user do
    json.call(
      @user,
      :email
    )
  end
  json.token token
end
