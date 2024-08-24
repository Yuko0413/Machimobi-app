class AddPhoneNumbersToCareContents < ActiveRecord::Migration[6.1]
  def change
    add_column :care_contents, :phone_numbers, :json
  end
end
