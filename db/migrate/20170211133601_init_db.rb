class InitDb < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :address
      t.timestamps
    end

    create_table :measurements do |t|
      t.string :name
      t.timestamps
    end

    create_table :stats do |t|
      t.integer :year
      t.decimal :total, precision: 8, scale: 2
      t.references :location, index: true, null: false, foreign_key: {to_table: :locations}
      t.references :measurement, index: true, null: false, foreign_key: {to_table: :measurements}
      t.timestamps
    end

    add_index :stats, [:location_id, :measurement_id]
  end
end
