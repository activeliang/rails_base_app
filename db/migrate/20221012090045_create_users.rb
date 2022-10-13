class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, index: { unique: true }
      t.string :password_digest
      t.boolean :is_freeze, default: false
      t.string :role, :mark 
      t.timestamps
    end
  end
end
