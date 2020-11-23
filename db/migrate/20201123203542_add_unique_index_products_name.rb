class AddUniqueIndexProductsName < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :name, unique: true
  end
end
