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

genre_array = ["Computer science, information & general works", "Philosophy & psychology",
"Religion", "Social sciences", "Language", "Science", "Technology", "Arts & recreation",
"Literature", "History & geography"]

10.times do |n|
  Dewey.create(code: n, genre: genre_array[n])
end

dewey = Array.new
1000.times do |n|
  dewey[n] = genre_array[n/100]
end

99.times do |n|
  name = Faker::Book.title
  author = Faker::Book.author
  publisher = Faker::Book.publisher
  pages = Faker::Number.between(100,2000)
  publication_date = Faker::Date.between(30.years.ago, Date.today)
  availability = Faker::Number.between(3,20)
  description = Faker::Lorem.paragraph(30)
  number_of_borrowing_days = Faker::Number.between(14,28)
  dewey_code = Faker::Number.between(0,999)
  genre = dewey[dewey_code]
  Book.create!(name: name,
               author: author,
               genre: genre,
               pages: pages,
               publisher: publisher,
               publication_date: publication_date,
               availability: availability,
               description: description,
               number_of_borrowing_days: number_of_borrowing_days,
               dewey_code: dewey_code)
end

Borrowing.create!(user_id: 3, 
                  book_id: 4, 
                  borrowed_time: Time.now - 28.days,
                  due_date: Time.now - 14.days,
                  verified: true,
                  number_of_extension: 2,
                  request: nil)
