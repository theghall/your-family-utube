class User < ApplicationRecord
  has_many :profiles, dependent: :destroy
  has_many :general_settings, dependent: :destroy
  has_many :profile_settings, through: :profiles
  has_many :tags, dependent: :destroy
  has_many :videos, through: :profiles
  belongs_to :account_type
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  after_validation :create_parent_digest
  validates :pin, presence: true, length:{ is: 4 }, confirmation: true
  
  attr_accessor :pin, :pin_confirmation
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine::cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.authenticate?(digest, password)
    BCrypt::Password.new(digest).is_password?(password)
  end
  
  def valid_pin?(pin)
    Devise::Encryptor.compare(self.class, parent_digest, pin) # User.authenticate?(parent_digest, pin)
  end
    
  private
  
    def create_parent_digest
      self.parent_digest = Devise::Encryptor.digest(self.class, pin) # User.digest(pin)
    end
end
