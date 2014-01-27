class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :ip
      t.string :name
      t.timestamp :start_time
      t.text :custom1
      t.text :custom2

      t.timestamps
    end
  end
end
