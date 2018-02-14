class CreateSlackUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :slack_users do |t|
      t.string :team_id
      t.string :user_id
      t.string :address

      t.timestamps
    end

    add_index :slack_users, %i[team_id user_id], unique: true
  end
end
