class Group < ApplicationRecord
  validates :name, presence: true
  # has_many :group_announcement
  # has_many :group_meeting
  has_many :events, dependent: :destroy
  has_many :groupchats, dependent: :destroy
  has_and_belongs_to_many :users
end
