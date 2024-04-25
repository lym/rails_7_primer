# This file should ensure the existence of records required to run the
# application in every environment (production, development, test). The code
# here should be idempotent so that it can be executed at any point in every
# environment. The data can then be loaded with the bin/rails db:seed command
# (or created alongside the database with db:setup).
#

# Create the main test/sample user
User.create!(
  name: 'John Smith',
  email: 'jsmith@anonmail.com',
  admin: true,
  password: 'weakpass',
  password_confirmation: 'weakpass',
  activated: true,
  activated_at: Time.zone.now
)

# Generate a couple more users
200.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email(name: name, separators: ['.'])
  password = 'weakpass'

  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end
