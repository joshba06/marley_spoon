class Recipe < ApplicationRecord
  include ContentfulRenderable

  def self.content_type_id
    return "recipe"
  end

  

end
