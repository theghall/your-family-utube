class Profile < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  validate :name_not_blank
  
  private
    def name_not_blank
        if name && name.strip.length == 0
            errors.add(:name, "Name cannot be blank")
        end
    end
end
