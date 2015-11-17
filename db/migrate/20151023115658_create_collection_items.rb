class CreateCollectionItems < ActiveRecord::Migration
  def change
    create_table :collection_items do |t|
      t.string :name
      t.references :collection, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
