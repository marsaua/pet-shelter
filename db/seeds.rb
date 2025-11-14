# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample dogs for testing
dogs_data = [
  {
    name: "Buddy",
    sex: "male",
    age_month: 24,
    size: "medium",
    breed: "Golden Retriever",
    status: "available"
  },
  {
    name: "Luna",
    sex: "female",
    age_month: 18,
    size: "small",
    breed: "Beagle",
    status: "available"
  },
  {
    name: "Max",
    sex: "male",
    age_month: 36,
    size: "large",
    breed: "German Shepherd",
    status: "adopted"
  },
  {
    name: "Bella",
    sex: "female",
    age_month: 12,
    size: "small",
    breed: "Chihuahua",
    status: "available"
  },
  {
    name: "Charlie",
    sex: "male",
    age_month: 48,
    size: "medium",
    breed: "Labrador",
    status: "available"
  }
]

dogs_data.each do |dog_attrs|
  Dog.find_or_create_by!(name: dog_attrs[:name]) do |dog|
    dog.sex = dog_attrs[:sex]
    dog.age_month = dog_attrs[:age_month]
    dog.size = dog_attrs[:size]
    dog.breed = dog_attrs[:breed]
    dog.status = dog_attrs[:status]
  end
end

puts "Created #{Dog.count} dogs"

User.find_or_create_by!(email: "anonymous@example.com") do |u|
  u.password = SecureRandom.base58(16)
  u.name     = "Anonymous"
  u.role     = :user if u.respond_to?(:role=)
end
puts "Seeded default user: anonymous@example.com"

