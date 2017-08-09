class User < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :videos, through: :profiles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  before_create :create_parent_digest
  validates :pin, presence: true, length:{ is: 4 }, confirmation: true
  
  attr_accessor :pin, :pin_confirmation
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine::cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  private
  
    def create_parent_digest
      self.parent_digest = User.digest(pin)
    end
end
