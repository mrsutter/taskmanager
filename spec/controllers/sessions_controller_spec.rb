require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  it 'signs in/out' do
    post(
      :create,
      params: {
        sessions: { email: fake_user.email, password: 'wrongpassword' }
      }
    )
    expect(response).to render_template('new')
    expect(session[:user_id]).to be_nil

    creds = { email: fake_user.email, password: 'fakepassword' }
    post :create, params: { sessions: creds }
    expect(session[:user_id]).to eq(fake_user.id)
    expect(response).to redirect_to(user_tasks_path(user_id: fake_user.id))

    delete :destroy, params: { id: fake_user.id }
    expect(session[:user_id]).to be_nil
  end
end
