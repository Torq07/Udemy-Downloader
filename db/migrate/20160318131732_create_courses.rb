class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.text :name
      t.string :url

      t.timestamps null: false
    end
  end
end
