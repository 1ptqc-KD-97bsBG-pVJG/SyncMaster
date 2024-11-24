class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Define role constants if not already defined
  ROLES = {
    client: 0,
    employee: 1,
    admin: 2
  }

  # Add role methods
  def employee?
    role == ROLES[:employee] || role == ROLES[:admin]
  end

  def admin?
    role == ROLES[:admin]
  end

  def client?
    role == ROLES[:client]
  end
end
