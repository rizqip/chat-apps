class NicknamesController < ApplicationController
  # Skip CSRF hanya untuk API, bukan untuk web interface
  skip_before_action :verify_authenticity_token, only: [:api_create]
  
  # Tambahkan constant untuk bad words
  BAD_WORDS = %w[anjing fuck shit bangsat kontol memek jancok jancuk asu ngentot babi].freeze
  MAX_NICKNAME_LENGTH = 20

  def new
    # Jika sudah punya nickname, langsung masuk ke chat
    redirect_to rooms_path if session[:nickname].present?
  end

  def create
    nickname = params[:nickname].presence&.strip
    
    # Validasi nickname kosong
    if nickname.blank?
      redirect_to new_nickname_path, alert: "Nickname tidak boleh kosong."
      return
    end

    # Validasi panjang nickname
    if nickname.length > MAX_NICKNAME_LENGTH
      redirect_to new_nickname_path, alert: "Nickname terlalu panjang, maksimal #{MAX_NICKNAME_LENGTH} karakter."
      return
    end

    # Filter kata kasar pada nickname
    if contains_bad_word?(nickname)
      redirect_to new_nickname_path, alert: "Nickname mengandung kata yang tidak pantas."
      return
    end

    # Sanitasi nickname
    sanitized_nickname = sanitize_nickname(nickname)

    # Simpan nickname dan warna acak ke session
    session[:nickname] = sanitized_nickname
    session[:nickname_color] = random_color

    redirect_to rooms_path, notice: "Selamat datang, #{sanitized_nickname}!"
  end

  def api_create
    nickname = params[:nickname].presence&.strip
    
    # Validasi nickname kosong
    if nickname.blank?
      render json: { error: "Nickname tidak boleh kosong." }, status: :unprocessable_entity
      return
    end

    # Validasi panjang nickname
    if nickname.length > MAX_NICKNAME_LENGTH
      render json: { error: "Nickname terlalu panjang, maksimal #{MAX_NICKNAME_LENGTH} karakter." }, status: :unprocessable_entity
      return
    end

    # Filter kata kasar pada nickname
    if contains_bad_word?(nickname)
      render json: { error: "Nickname mengandung kata yang tidak pantas." }, status: :unprocessable_entity
      return
    end

    # Sanitasi nickname
    sanitized_nickname = sanitize_nickname(nickname)

    # Set session data
    session[:nickname] = sanitized_nickname
    session[:nickname_color] = random_color
    
    render json: { 
      message: "Nickname disimpan.", 
      nickname: sanitized_nickname, 
      color: session[:nickname_color]
    }, status: :ok
  end
  
  def destroy
    # Hapus nickname dari session (logout nickname)
    reset_session
    redirect_to new_nickname_path, notice: "Kamu telah keluar dari chat."
  end

  private

  # Generate warna acak (HEX)
  def random_color
    "#" + "%06x" % (rand * 0xffffff)
  end

  # Cek apakah mengandung kata kasar
  def contains_bad_word?(text)
    BAD_WORDS.any? { |word| text.downcase.include?(word.downcase) }
  end

  # Sanitasi nickname (hapus tag HTML dan trim spasi)
  def sanitize_nickname(text)
    ActionController::Base.helpers.sanitize(text).strip
  end
end