class CreateUrlData < ActiveRecord::Migration[6.0]
  def change
    create_table :url_data do |t|
      t.text :source_url, null: false
      t.string :token, null: false
      t.text :sanitized_url, null: false

      t.timestamps
    end

    add_index :url_data, :token, unique: true
    add_index :url_data, :sanitized_url, unique: true
  end
end
