require 'rails_helper'

RSpec.describe UsersPolicy, type: :policy do
  let(:user) { create :user, admin: true }
  let(:record) { create :user }

  subject { described_class.new(user, record) }

  context 'when user is admin' do
    it { is_expected.to permit_actions([:index, :update, :load_avatar]) }
  end

  context 'when user has default permissions' do
    let(:user) { create :user, admin: false }

    it { is_expected.to forbid_actions([:index, :update, :load_avatar]) }
  end

  context 'when user is self record' do
    let!(:user) { create :user, admin: false }
    let!(:record) { user }

    it { is_expected.to forbid_actions([:index]) }
    it { is_expected.to permit_actions([:update, :load_avatar]) }
  end
end
