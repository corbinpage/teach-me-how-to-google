class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :status
      t.string :error
      t.text :search_info_string
      t.string :item_titles
      t.string :item_links
      t.string :item_display_links
      t.text :item_snippets
      t.string :custom1
      t.string :custom2
      t.text :custom3
      t.references :search, index: true

      t.timestamps
    end
  end
end
