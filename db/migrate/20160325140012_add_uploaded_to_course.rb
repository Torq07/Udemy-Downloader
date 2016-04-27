class AddUploadedToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :upload, :boolean
  end
end
