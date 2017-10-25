class AccountType < ApplicationRecord
  has_many :users

  validates :name, presence: :true
  validates :video_limit, inclusion: { in: [true, false] }
  validate :valid_max, :max_videos

  def self.type_id(name)
    AccountType.where(name: name).pluck(:id).first
  end

  def self.type_name(account_type_id)
    AccountType.where(id: account_type_id).pluck(:name).first
  end

  def self.has_limit(account_type_id)
    AccountType.where(id: account_type_id).pluck(:video_limit).first
  end

  def self.limit(account_type_id)
    AccountType.where(id: account_type_id).pluck(:max_videos).first
  end

  private

    def valid_max
      if video_limit && max_videos.nil?
        errors.add(:max_videos, 'cannot be null if limit is true')
      elsif video_limit && max_videos < 1 
        errors.add(:max_videos, 'must be greater than zero if limit is true')
      elsif !video_limit && !max_videos.nil?
        errors.add(:max_videos, 'must be null if limit is false')
      end
    end
end
