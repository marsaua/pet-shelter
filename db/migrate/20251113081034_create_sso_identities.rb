class CreateSsoIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :sso_identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :provider, null: false
      t.string  :uid,      null: false
      t.string  :access_token
      t.string  :refresh_token
      t.datetime :token_expires_at
      t.string  :name
      t.string  :image
      t.json :data, default: {}

      t.timestamps
    end
    add_index :sso_identities, [:provider, :uid], unique: true
  end
end
