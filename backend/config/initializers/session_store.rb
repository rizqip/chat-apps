# Pastikan file ini ada dan berisi:
Rails.application.config.session_store :cookie_store,
  key: '_chat_session',
  same_site: :lax, # Ubah dari :none ke :lax untuk development
  secure: Rails.env.production?, # Hanya secure di production
  domain: :all # Tambahkan ini untuk development