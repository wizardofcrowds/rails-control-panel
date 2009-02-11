class CreateSpecialGems < ActiveRecord::Migration
  def self.up
    create_table :special_gems do |t|
      t.string :name
      t.string :result_status
      t.text :result_stdout
      t.text :result_stderr
      t.string :version
      t.timestamps
    end
  end

  def self.down
    drop_table :special_gems
  end
end
