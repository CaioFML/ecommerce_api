class AddUniqueIndexCouponCode < ActiveRecord::Migration[6.0]
  def change
    add_index :coupons, :code, unique: true
  end
end
