class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :uuid
      t.boolean :activated
      t.datetime :active_until
      t.references :provider
      t.timestamps
    end
  end
end
