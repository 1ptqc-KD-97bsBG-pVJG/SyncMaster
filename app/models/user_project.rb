class UserProject < ApplicationRecord
  belongs_to :user, foreign_key: 'employee_id'
  belongs_to :project
end