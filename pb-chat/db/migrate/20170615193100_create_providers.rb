class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :uuid
      t.boolean :active
      t.string :host
      t.timestamps
    end
  end
end
