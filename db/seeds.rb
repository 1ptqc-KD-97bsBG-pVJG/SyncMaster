
require 'faker'

# Clear existing data
puts "Clearing existing data..."
# First, clear join tables
AppointmentProject.destroy_all
AppointmentAddress.destroy_all
UserAppointment.destroy_all
UserProject.destroy_all

# Then clear main tables
Appointment.destroy_all
Project.destroy_all
Address.destroy_all
User.destroy_all

# Create Users
puts "Creating users..."
10.times do |i|
  User.create!(
    email: Faker::Internet.unique.email,
    password: 'password123', # simple password for all test users
    name: Faker::Name.name,
    role: rand(0..2), # assuming you have 3 roles
    confirmed_at: Time.current # auto-confirm users for testing
  )
end

# Create Projects
puts "Creating projects..."
20.times do
  Project.create!(
    project_name: Faker::Company.unique.catch_phrase,
    description: Faker::Company.bs,
    note: Faker::Lorem.paragraph,
    status: rand(0..2), # adjust based on your status enum
    target_completion: Faker::Date.between(from: 1.month.from_now, to: 1.year.from_now),
    delivery_link: Faker::Internet.url
  )
end

# Create Addresses
puts "Creating addresses..."
30.times do
  Address.create!(
    street: Faker::Address.street_address,
    secondary: Faker::Address.secondary_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip_code,
    country: 'United States',
    address_type: rand(0..2) # adjust based on your address_type enum
  )
end

# Create Appointments
puts "Creating appointments..."
users = User.all
addresses = Address.all
projects = Project.all

15.times do
  appointment = Appointment.create!(
    appointment_type: rand(0..2),
    status: rand(0..2),
    note: Faker::Lorem.paragraph,
    scheduled_date: Faker::Date.between(from: 1.month.ago, to: 1.month.from_now),
    scheduled_start: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    scheduled_end: Faker::Time.between(from: DateTime.now, to: DateTime.now + 1),
    created_by_user: users.sample,
    completed_by_user: [users.sample, nil].sample, # randomly assign completed_by or leave nil
    employees: users.sample(rand(1..3))
  )

  # Associate random addresses and projects
  appointment.addresses << addresses.sample(rand(1..3))
  appointment.projects << projects.sample(rand(1..2))
end

puts "Seed completed!"