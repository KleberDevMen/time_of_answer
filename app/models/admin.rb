class Admin < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable

  # Kaminari
  paginates_per 5

  validates_confirmation_of :password
  validates_uniqueness_of :email
end
