class CreateQrCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :qr_codes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :qr_code

      t.timestamps
    end
  end
end
