class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.text :title, null: false
      t.string :tags, array: true, default: [], null: false
      t.text :description, null: false
      t.string :chef, null: false
      t.text :image_url, null: false
      t.string :contentful_id, null: false

      t.timestamps
    end
  end
end
