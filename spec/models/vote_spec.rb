require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }

  it { should have_db_column(:value).with_options(default: 0) }
  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_range(-1..1) }
end
