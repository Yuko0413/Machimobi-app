class CreateEmergencyContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :emergency_contacts do |t|
      t.string :phone_number
      t.string :relationship
      t.references :care_content, null: false, foreign_key: true

      t.timestamps
    end
  end
end
