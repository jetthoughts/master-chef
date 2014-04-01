class Account < ActiveRecord::Base
  validates :name, presence: true
end
