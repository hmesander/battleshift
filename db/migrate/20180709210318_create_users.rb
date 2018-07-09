class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :name
      t.string :password_digest
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
