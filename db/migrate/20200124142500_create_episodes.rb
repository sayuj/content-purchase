class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.string :title
      t.integer :number
      t.text :plot

      t.timestamps
    end
  end
end
