# frozen_string_literal: true

FactoryBot.define do
  factory :news do
    user
    header { Faker::Lorem.sentence }
    announcement { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraph }
  end
end
