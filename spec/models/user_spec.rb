# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:signature) }
    it { should validate_presence_of(:full_name) }
    it { should validate_uniqueness_of(:username).ignoring_case_sensitivity }
    it { should validate_uniqueness_of(:signature).ignoring_case_sensitivity }
    it { should validate_length_of(:password).is_at_least(6) }
  end
end
