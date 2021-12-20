class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :body
      t.integer :views_count
      t.integer :positive_votes
      t.integer :negative_votes

      t.timestamps
    end
  end
end
