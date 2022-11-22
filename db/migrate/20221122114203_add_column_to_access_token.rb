class AddColumnToAccessToken < ActiveRecord::Migration[6.0]
  def change
    add_column :access_tokens, :refresh, :string
  end
end
