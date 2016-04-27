class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.references :section, index: true, foreign_key: true
      t.text :name
      t.text :link
      t.text :file_type

      t.timestamps null: false
    end
  end
end
