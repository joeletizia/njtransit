require 'pry'
class CreateTrainDataTable < ActiveRecord::Migration
  def change
    create_table :train_data do |t|
      t.timestamps
      t.string :line, :string
      t.string :train_id
      t.string :track, null: false
    end
  end
end
