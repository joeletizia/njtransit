class CreateTrainData < ActiveRecord::Migration
  def change
    create_table :train_data do |t|
      t.string :line, :string
      t.integer :train_id
      t.string :track, null: false
    end

    add_index :train_data, :train_id, unique: true
  end
end
