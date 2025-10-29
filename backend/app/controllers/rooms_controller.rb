class RoomsController < ApplicationController
  # Skip CSRF untuk create action jika request JSON
  skip_before_action :verify_authenticity_token, only: [:create], if: -> { request.format.json? }

  # Tambahkan constant untuk bad words
  BAD_WORDS = %w[anjing fuck shit bangsat kontol memek jancok jancuk asu ngentot babi].freeze
  MAX_ROOM_NAME_LENGTH = 50

  # Loads:
  # @rooms = all rooms
  # @room = current room when applicable
  before_action :load_entities

  def index
    @rooms = Room.all

    respond_to do |format|
      format.html # untuk versi Rails view
      format.json { render json: @rooms } # untuk API React
    end
  end

  def new
    @room = Room.new
  end
  
  def create
    room_name = permitted_parameters[:name]&.strip
    
    # Validasi room name kosong
    if room_name.blank?
      respond_to do |format|
        format.html do
          flash[:alert] = "Nama room tidak boleh kosong."
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { error: "Nama room tidak boleh kosong." }, status: :unprocessable_entity }
      end
      return
    end

    # Validasi panjang room name
    if room_name.length > MAX_ROOM_NAME_LENGTH
      respond_to do |format|
        format.html do
          flash[:alert] = "Nama room terlalu panjang, maksimal #{MAX_ROOM_NAME_LENGTH} karakter."
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { error: "Nama room terlalu panjang, maksimal #{MAX_ROOM_NAME_LENGTH} karakter." }, status: :unprocessable_entity }
      end
      return
    end

    # Filter kata kasar pada room name
    if contains_bad_word?(room_name)
      respond_to do |format|
        format.html do
          flash[:alert] = "Nama room mengandung kata yang tidak pantas."
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { error: "Nama room mengandung kata yang tidak pantas." }, status: :unprocessable_entity }
      end
      return
    end

    # Sanitasi room name
    sanitized_room_name = sanitize_room_name(room_name)
    
    @room = Room.new(name: sanitized_room_name)

    respond_to do |format|
      if @room.save
        format.html do
          flash[:notice] = "Room created successfully"
          redirect_to room_path(@room)
        end
        format.json { render json: @room, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: @room.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    room_name = permitted_parameters[:name]&.strip
    
    # Validasi room name kosong
    if room_name.blank?
      flash[:alert] = "Nama room tidak boleh kosong."
      render :edit, status: :unprocessable_entity
      return
    end

    # Validasi panjang room name
    if room_name.length > MAX_ROOM_NAME_LENGTH
      flash[:alert] = "Nama room terlalu panjang, maksimal #{MAX_ROOM_NAME_LENGTH} karakter."
      render :edit, status: :unprocessable_entity
      return
    end

    # Filter kata kasar pada room name
    if contains_bad_word?(room_name)
      flash[:alert] = "Nama room mengandung kata yang tidak pantas."
      render :edit, status: :unprocessable_entity
      return
    end

    # Sanitasi room name
    sanitized_room_name = sanitize_room_name(room_name)

    if @room.update(name: sanitized_room_name)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @room = Room.find(params[:id])
    @room_messages = @room.room_messages.order(created_at: :asc)
    @room_message = RoomMessage.new(room: @room)

    respond_to do |format|
      format.html
      format.json do
        render json: {
          id: @room.id,
          name: @room.name,
          messages: @room_messages.map do |msg|
            {
              id: msg.id,
              nickname: msg.nickname,
              content: msg.message,
              created_at: msg.created_at
            }
          end
        }
      end
    end
  end

  protected

  def load_entities
    @rooms = Room.all
    @room = Room.find(params[:id]) if params[:id]
  end

  def permitted_parameters
    params.require(:room).permit(:name)
  end
  
  def require_nickname
    if session[:nickname].blank?
      redirect_to new_nickname_path, alert: "Please enter your nickname first."
    end
  end

  private

  # Cek apakah mengandung kata kasar
  def contains_bad_word?(text)
    BAD_WORDS.any? { |word| text.downcase.include?(word.downcase) }
  end

  # Sanitasi room name (hapus tag HTML dan trim spasi)
  def sanitize_room_name(text)
    ActionController::Base.helpers.sanitize(text).strip
  end
end