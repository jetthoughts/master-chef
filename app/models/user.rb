class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable, :async

  validates :email, uniqueness: true

  has_many :projects, inverse_of: :user
  has_many :available_deployments, through: :projects, source: :deployments


  has_many :deployments, inverse_of: :user

  def name
    [first_name, last_name].join ' '
  end

  def superadmin?
    role == 'super_admin'
  end
  alias_method :super_admin?, :superadmin?

end
