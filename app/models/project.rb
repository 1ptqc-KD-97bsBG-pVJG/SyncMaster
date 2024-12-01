class Project < ApplicationRecord
  has_many :appointment_projects
  has_many :appointments, through: :appointment_projects

  has_many :user_projects
  has_many :users, through: :user_projects

  accepts_nested_attributes_for :users, allow_destroy: true
end