# frozen_string_literal: true

require 'rails_helper'

RSpec.describe News, type: :model do
  describe 'associations' do
    it { should belong_to(:user).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:header) }
    it { should validate_presence_of(:announcement) }
    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:status) }
  end
end
