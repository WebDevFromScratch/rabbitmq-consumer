class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.json :rates
      t.string :uuid

      t.timestamps
    end
  end
end
