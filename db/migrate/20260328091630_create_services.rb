class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string  :name,        null: false
      t.text    :description
      t.string  :category,    null: false
      t.decimal :price_rub,   precision: 10, scale: 2
      t.integer :position,    default: 0, null: false
      t.boolean :active,      default: true, null: false

      t.timestamps
    end

    add_index :services, :category
    add_index :services, :position
    add_index :services, :active
  end
end
