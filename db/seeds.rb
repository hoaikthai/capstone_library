User.create!(name:  "Librarian 1",
             email: "librarian@capstone.org",
             password:              "foobar",
             password_confirmation: "foobar",
             role: "librarian",
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              role: "user",
              activated: true,
              activated_at: Time.zone.now)
end