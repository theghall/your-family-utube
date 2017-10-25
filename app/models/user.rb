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
  validate :pin, :validate_pin
  after_validation :create_parent_digest
  
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
  
    def change_in_pin(pin, pin_confirmation)
      # default for parent_digest is "", so must be create
      return true if self.parent_digest.empty?

      return !pin.empty? && !pin_confirmation.empty? && !self.parent_digest.empty?
    end

    # Cannot find way to have Devise skip validation if user is editing account
    # but does not change pin. So, I have to do stuff Rails would normally do for me
    def validate_pin
      pin = self.pin.nil? ? '' : self.pin.strip
      pin_confirmation = self.pin_confirmation.nil? ? '' : self.pin_confirmation.strip

      return unless change_in_pin(pin, pin_confirmation)

      if pin.empty?
        errors.add(:pin, 'cannot be blank')
      else
        if pin.length != 4
          errors.add(:pin, 'is not 4 characters')
        elsif pin != pin_confirmation
          errors.add(:pin_confirmation, 'does not match pin.')
        end
      end
    end

    def create_parent_digest
      self.parent_digest = Devise::Encryptor.digest(self.class, pin) unless pin.nil? || pin.empty?
    end
end
