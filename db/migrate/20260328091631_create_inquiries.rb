class CreateInquiries < ActiveRecord::Migration[7.1]
  def change
    create_table :inquiries do |t|
      t.string     :name,    null: false
      t.string     :phone,   null: false
      t.string     :email
      t.references :service, null: true, foreign_key: true
      t.text       :message
      t.integer    :status,  default: 0, null: false

      t.timestamps
    end

    add_index :inquiries, :status
    add_index :inquiries, :created_at
  end
end
