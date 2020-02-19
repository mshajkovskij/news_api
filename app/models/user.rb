# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :news

  validates :username,
            :signature,
            presence: true, uniqueness: true

  validates :full_name, presence: true

  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
