class AddLineUserIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :line_user_id, :string
    add_index :users, :line_user_id, unique: true

    # 既存のレコードに対してデフォルト値を設定
    reversible do |dir|
      dir.up do
        User.reset_column_information
        User.find_each do |user|
          user.update_columns(line_user_id: SecureRandom.uuid)
        end
        change_column_null :users, :line_user_id, false
      end
    end
  end
end

