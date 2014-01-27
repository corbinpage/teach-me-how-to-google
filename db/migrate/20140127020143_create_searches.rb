class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :step
      t.integer :search_num
      t.text :search_text
      t.string :status
      t.references :session, index: true

      t.timestamps
    end
  end
end
