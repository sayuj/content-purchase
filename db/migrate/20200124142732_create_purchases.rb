class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.references :user
      t.string :content_type
      t.bigint :content_id
      t.references :purchase_option
      t.datetime :expire_at

      t.timestamps
    end
  end
end
