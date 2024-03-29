# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokens::Create do
  let!(:user) { create(:user) }
  subject { Tokens::Create.new(user) }
  let(:attributes) { %w[id email admin expires_in salt] }

  it 'return generated token' do
    decoded_token = JWT.decode subject.call.token, nil, false

    expect(decoded_token.first['email']).to eq user.email
    expect(decoded_token.first.keys).to match_array(attributes)
  end

  it 'tokens quantity adjustment' do
    expect(user.access_tokens.count).to eq 0
    5.times { subject.call }
    expect(user.access_tokens.count).to eq 3
  end
end