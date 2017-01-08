namespace :utils do
  task populate_db: :environment do
    10.times do
      u = User.create(
        email: Faker::Internet.free_email,
        password: 'fakepassword'
      )
      5.times do
        u.tasks.create(
          name: Faker::Hipster.word,
          description: Faker::Hipster.sentence
        )
      end
    end
  end
end
