class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable, :async

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  has_many :projects

  def name
    [first_name, last_name].join ' '
  end

  def superadmin?
    role == 'super_admin'
  end
  alias_method :super_admin?, :superadmin?

end
