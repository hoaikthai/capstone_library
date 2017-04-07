User.create!(name:  "Librarian 1",
             email: "librarian@capstone.org",
             password:              "foobar",
             password_confirmation: "foobar",
             role: "librarian",
             activated: true,
             activated_at: Time.now)

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
              activated_at: Time.now)
end

99.times do |n|
  name = Faker::Book.title
  author = Faker::Book.author
  publisher = Faker::Book.publisher
  genre = Faker::Book.genre
  pages = Faker::Number.between(100,2000)
  publication_date = Faker::Date.between(30.years.ago, Date.today)
  availability = Faker::Number.between(3,20)
  description = Faker::Lorem.paragraph(30)
  number_of_borrowing_days = Faker::Number.between(14,28)
  Book.create!(name: name,
               author: author,
               genre: genre,
               pages: pages,
               publisher: publisher,
               publication_date: publication_date,
               availability: availability,
               description: description,
               number_of_borrowing_days: number_of_borrowing_days)
end

Borrowing.create!(user_id: 5, 
                  book_id: 4, 
                  borrowed_time: Time.now - 28.days,
                  due_date: Time.now - 14.days,
                  verified: true,
                  number_of_extension: 2,
                  request: nil)
