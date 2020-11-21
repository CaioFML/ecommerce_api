class SystemRequirement < ApplicationRecord
  include NameSearchable
  include Paginatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :operational_system, :storage, :processor, :memory, :video_board, presence: true

  has_many :games, dependent: :restrict_with_error
end
