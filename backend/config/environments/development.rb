require "active_support/core_ext/integer/time"

Rails.application.configure do
  # === KOMPILASI DASAR ===
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  # === CACHING ===
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = { "cache-control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
  end

  # Gunakan memory store untuk cache development
  config.cache_store = :memory_store

  # === STORAGE / MAILER ===
  config.active_storage.service = :local
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # === DATABASE / LOGGING ===
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true
  config.action_dispatch.verbose_redirect_logs = true

  # === ASSETS ===
  config.assets.quiet = true

  # === I18N & DEBUG ===
  # config.i18n.raise_on_missing_translations = true
  config.action_view.annotate_rendered_view_with_filenames = true
  config.action_controller.raise_on_missing_callback_actions = true

  # === ACTION CABLE ===
  # URL WebSocket untuk koneksi Turbo Stream / Chat
  config.action_cable.disable_request_forgery_protection = true
  config.action_cable.url = "ws://localhost:3000/cable"
  config.action_cable.mount_path = '/cable'
  
  # Izinkan koneksi dari semua asal http di dev (termasuk host docker)
  # config.action_cable.allowed_request_origins = [
    #   "http://localhost:3000",
    #   "http://127.0.0.1:3000",
    #   "http://0.0.0.0:3000",
    #   "http://localhost:5173",
    #   "http://127.0.0.1:5173"
    # ]
  config.action_cable.allowed_request_origins = *

  # Jika ingin lebih fleksibel (misalnya untuk frontend React atau port lain):
  # config.action_cable.allowed_request_origins = [ /http:\/\/.*/ ]

  # === REDIS (untuk caching dan Action Cable) ===
  # Gunakan Redis jika tersedia di Docker
  redis_url = ENV.fetch("REDIS_URL", "redis://redis:6379/1")
  config.cache_store = :redis_cache_store, { url: redis_url }

  config.action_controller.default_protect_from_forgery = true
  config.action_controller.allow_forgery_protection = true

  # === OPSIONAL ===
  # Jika nanti menggunakan Turbo::Streams
  # config.after_initialize do
  #   Turbo::Streams.configure do |streams|
  #     streams.redis = ConnectionPool.new(size: 5) { Redis.new(url: redis_url) }
  #   end
  # end

  # Izinkan host Docker (nama service) untuk development
  config.hosts << "backend"        # nama service backend di Docker Compose
  config.hosts << "frontend"       # jika frontend request langsung ke backend
  config.hosts << "localhost"
  config.hosts << "127.0.0.1"

  # Izinkan semua request origin untuk API / form submit dari frontend React
  config.action_controller.forgery_protection_origin_check = false
end
