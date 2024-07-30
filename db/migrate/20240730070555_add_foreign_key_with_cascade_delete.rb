class AddForeignKeyWithCascadeDelete < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :care_contents, :users
    add_foreign_key :care_contents, :users, on_delete: :cascade

    remove_foreign_key :qr_codes, :users
    add_foreign_key :qr_codes, :users, on_delete: :cascade
  end
end
