require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'sets the current user' do
    session[:user_id] = fake_user.id
    expect(subject.send(:current_user)).to eq(fake_user)
  end
end
