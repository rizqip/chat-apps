# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Ganti origin sesuai alamat frontend kamu
    origins 'http://localhost', 'http://localhost:80', 'http://localhost:5173', 'http://127.0.0.1:5173'

    resource '*',
      headers: :any,
      methods: [:get, :post, :patch, :put, :delete, :options, :head],
      credentials: true
  end
end
