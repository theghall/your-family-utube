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
  validates :pin, presence: true, length: { is: 4 }, confirmation: true, if: :pin_change?
  after_validation :create_parent_digest
  before_create :set_account_type
  
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
  
    # Because Devise won't skip validation of no change
    def pin_change?
      # default for parent_digest is "", so must be create
      return true if self.parent_digest.empty?

      pin = (self.pin.nil? ? '' : self.pin.strip)

      pin_confirmation = (self.pin_confirmation.nil? ? '' : self.pin_confirmation.strip)

      return !pin.empty? && !pin_confirmation.empty? && !self.parent_digest.empty?
    end

    def create_parent_digest
      self.parent_digest = Devise::Encryptor.digest(self.class, pin) unless pin.nil? || pin.empty?
    end

    def set_account_type
      self.account_type_id = AccountType.type_id('free')
    end
end
