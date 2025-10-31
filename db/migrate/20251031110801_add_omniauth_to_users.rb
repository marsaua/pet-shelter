class AddOmniauthToUsers < ActiveRecord::Migration[8.0]
  def change
    # ці колонки відсутні — додаємо:
    add_column :users, :name, :string
    add_column :users, :image, :string

    # якщо хочеш — можеш взагалі НІЧОГО не додавати, а просто видалити вміст change,
    # але найчастіше name/image корисні.
    #
    # НЕ додаємо бо вже є:
    # add_column :users, :google_access_token, :text
    # add_column :users, :google_refresh_token, :text
    # add_column :users, :google_token_expires_at, :datetime
    # add_column :users, :provider, :string
    # add_column :users, :uid, :string

    # НЕ ставимо індекс на [:provider, :uid], якщо цих колонок немає
  end
end
