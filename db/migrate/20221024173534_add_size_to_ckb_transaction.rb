class AddSizeToCkbTransaction < ActiveRecord::Migration[6.1]
  def change
    add_column :ckb_transactions, :size, :integer
  end
end
