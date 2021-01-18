class ChangeDiscountsToBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    rename_table :discounts, :bulk_discounts
  end
end
