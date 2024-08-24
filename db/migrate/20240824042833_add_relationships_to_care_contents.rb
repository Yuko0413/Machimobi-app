class AddRelationshipsToCareContents < ActiveRecord::Migration[6.1]
  def change
    add_column :care_contents, :relationship_1, :string
    add_column :care_contents, :relationship_2, :string
    add_column :care_contents, :relationship_3, :string
  end
end
