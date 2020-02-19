# frozen_string_literal: true

class News < ApplicationRecord
  belongs_to :user

  accepts_nested_attributes_for :user

  validates :header,
            :announcement,
            :text,
            :status,
            presence: true

  state_machine :status, initial: :unpublished do
    state :unpublished
    state :published

    event :publish do
      transition unpublished: :published
    end
  end
end
