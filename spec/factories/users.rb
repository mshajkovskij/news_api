# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password = Faker::Internet.password

    username { Faker::Internet.unique.user_name }
    signature { Faker::Internet.unique.user_name }
    full_name { Faker::Name.name_with_middle }
    password { password }
    password_confirmation { password }
  end
end
