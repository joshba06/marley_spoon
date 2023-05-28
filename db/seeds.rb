# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Recipe.destroy_all
SidekiqLog.destroy_all
10.times do
  available_tags = %W(vegan gluten-free no-diary vegetarian top-rated)
  title = "#{Faker::Emotion.adjective.capitalize} #{Faker::Food.dish}"
  Recipe.create(title: title,
                chef: Faker::Name.name,
                description: Faker::Food.description,
                tags: available_tags.sample(3),
                image_url: "https://raw.githubusercontent.com/lewagon/fullstack-images/master/uikit/breakfast.jpg",
                contentful_id: rand(999)
              )

end
