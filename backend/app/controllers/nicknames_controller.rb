class NicknamesController < ApplicationController
  # Skip CSRF hanya untuk API, bukan untuk web interface
  skip_before_action :verify_authenticity_token, only: [:api_create]
  
  def new
    # Jika sudah punya nickname, langsung masuk ke chat
    redirect_to rooms_path if session[:nickname].present?
  end

  def create
    nickname = params[:nickname].presence&.strip
    if nickname.blank?
      redirect_to new_nickname_path, alert: "Nickname tidak boleh kosong."
    else
      # Simpan nickname dan warna acak ke session
      session[:nickname] = nickname
      session[:nickname_color] = random_color

      redirect_to rooms_path, notice: "Selamat datang, #{nickname}!"
    end
  end

  def api_create
    nickname = params[:nickname].presence&.strip
    if nickname.blank?
      render json: { error: "Nickname tidak boleh kosong." }, status: :unprocessable_entity
    else
      # Set session data
      session[:nickname] = nickname
      session[:nickname_color] = random_color
      
      render json: { 
        message: "Nickname disimpan.", 
        nickname: nickname, 
        color: session[:nickname_color]
      }, status: :ok
    end
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
end