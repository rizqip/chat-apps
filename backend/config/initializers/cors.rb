# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Ganti origin sesuai alamat frontend kamu
    origins [
      'http://localhost',
      'http://localhost:80',
      'http://localhost:3000',
      'http://localhost:5173',
      'http://127.0.0.1:5173',
      'http://tamago.web.id',
      'https://tamago.web.id', 
      'http://www.tamago.web.id',
      'https://www.tamago.web.id',
      'http://109.110.188.172',
      'https://109.110.188.172'
    ]

    resource '*',
      headers: :any,
      methods: [:get, :post, :patch, :put, :delete, :options, :head],
      credentials: true
  end
end
