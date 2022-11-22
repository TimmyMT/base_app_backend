class CreateRefreshTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :refresh_tokens do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :access_token, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end
