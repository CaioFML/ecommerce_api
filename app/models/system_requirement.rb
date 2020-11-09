class SystemRequirement < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :operational_system, :storage, :processor, :memory, :video_board, presence: true
end
