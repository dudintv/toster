class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :value, default: 0
      t.references :votable, polymorphic: true
      t.references :user, foreign_key: true
      t.index [:user_id, :votable_id, :votable_type], unique: true

      t.timestamps
    end
  end
end
