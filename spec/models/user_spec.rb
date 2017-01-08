require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = fake_user
  end

  context 'when validates' do
    it 'check presence of email' do
      u = User.create(password: Faker::Internet.password(8))
      expect(u.errors[:email]).not_to be_empty
    end

    it 'check presence of password' do
      u = User.create(email: Faker::Internet.free_email)
      expect(u.errors[:password]).not_to be_empty
    end

    it 'check uniquiness of email' do
      u = User.create(
        email: @user.email,
        password: Faker::Internet.password(8)
      )
      expect(u.errors[:email]).not_to be_empty
    end

    it 'delete all assigned tasks' do
      task = @user.tasks.create(name: 'test')
      expect(@user.reload.tasks.count).to eq(1)
      @user.destroy
      expect(Task.where(id: task.id)).to be_empty
    end
  end
end
