class Recipe < ApplicationRecord
  include ContentfulRenderable

  def self.content_type_id
    return "recipe"
  end

  validates :description, presence: true
  validates :title, presence: true, uniqueness: true
  validates :chef, presence: true
  validates :image_url, presence: true
  validates :contentful_id, presence: true, uniqueness: true
  validate :tags_validation

  private

  def tags_validation
    if self.tags != [] && ( self.tags == nil || self.tags.blank? )
      errors.add(:tags, "cannot be nil or blank")
    end
  end

end
