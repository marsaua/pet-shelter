class RemoveGoogleColumnsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :google_uid, :string
    remove_column :users, :google_access_token, :string
    remove_column :users, :google_refresh_token, :string
    remove_column :users, :google_token_expires_at, :datetime
    remove_column :users, :google_calendar_id, :string
  end
end
