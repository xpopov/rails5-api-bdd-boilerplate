class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.text :url
      t.text :title
      t.text :h1, array: true, default: []
      t.text :h2, array: true, default: []
      t.text :h3, array: true, default: []
      t.text :links, array: true, default: []

      t.timestamps
    end
    add_index :pages, :url, unique: true
  end
end
