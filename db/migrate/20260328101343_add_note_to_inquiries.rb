class AddNoteToInquiries < ActiveRecord::Migration[7.1]
  def change
    add_column :inquiries, :note, :text
  end
end
