module Helpers
  def fake_user
    @fake_user ||= User.create(
      email: Faker::Internet.free_email,
      password: 'fakepassword'
    )
  end

  def sign_in(email, password)
    creds = { email: email, password: password }
    post '/sessions', params: { sessions: creds }
  end
end
