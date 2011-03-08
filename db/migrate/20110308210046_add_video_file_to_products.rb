class AddVideoFileToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :video_file, :string
  end

  def self.down
    remove_column :products, :video_file
  end
end
