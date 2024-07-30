class CreateCareContents < ActiveRecord::Migration[6.1]
  def change
    create_table :care_contents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :preferred_name
      t.string :phone_number
      t.text :custom_message
      t.bigint :template_id
      t.text :message

      t.timestamps
    end
  end
end
