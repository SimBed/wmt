class CreateResults < ActiveRecord::Migration[8.1]
  def change
    create_table :results do |t|
      t.integer :number, null: false
      t.decimal :score, precision: 5, scale: 2, null: false
      t.integer :position, null: false
      t.text :comment

      t.timestamps
    end

    add_index :results, :number
    add_index :results, :score
    add_index :results, :position
  end
end
