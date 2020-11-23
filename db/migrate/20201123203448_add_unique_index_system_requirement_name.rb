class AddUniqueIndexSystemRequirementName < ActiveRecord::Migration[6.0]
  def change
    add_index :system_requirements, :name, unique: true
  end
end
