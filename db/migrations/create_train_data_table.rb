class CreateTrainData < ActiveRecord::Migration
  def change
    create_table :train_data do |t|
      t.string :line, :string
      t.integer :train_id, :integer
      t.string :track, null: false
    end
  end
end
