require 'rails_helper'

RSpec.describe Web::TasksController, type: :controller do
  it 'randers root page' do
    get :index
    expect(response.code).to eq('200')
  end
end
