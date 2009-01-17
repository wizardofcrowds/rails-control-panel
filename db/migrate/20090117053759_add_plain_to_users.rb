class AddPlainToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :plain, :string
  end

  def self.down
    remove_column :users, :plain, :string
  end
end
