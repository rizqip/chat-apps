class RoomMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create], if: -> { request.format.json? }
  
  before_action :set_room

  BAD_WORDS = %w[anjing fuck shit bangsat kontol memek].freeze
  MAX_MESSAGE_LENGTH = 500

  def create
    nickname = session[:nickname]
    color = session[:nickname_color]

    puts "=== RoomMessagesController#create ==="
    puts "Nickname: #{nickname}, Color: #{color}"
    puts "Room ID: #{params[:room_id]}"
    puts "Message: #{params.dig(:room_message, :message)}"

    # Validasi untuk HTML request
    unless nickname.present? && color.present?
      puts "ERROR: Nickname or color missing"
      respond_to do |format|
        format.html { redirect_to new_nickname_path, alert: "Silakan masukkan nickname terlebih dahulu." }
        format.json { render json: { error: "Silakan masukkan nickname terlebih dahulu." }, status: :unauthorized }
      end
      return
    end

    message = params.dig(:room_message, :message).to_s.strip

    # Validasi duplicate message
    if session[:last_message_text] == message
      puts "ERROR: Duplicate message"
      respond_to do |format|
        format.html { redirect_to @room, alert: "Jangan kirim pesan yang sama berulang-ulang." }
        format.json { render json: { error: "Jangan kirim pesan yang sama berulang-ulang." }, status: :unprocessable_entity }
      end
      return
    end
    session[:last_message_text] = message

    # Validasi panjang pesan
    if message.length > MAX_MESSAGE_LENGTH
      puts "ERROR: Message too long"
      respond_to do |format|
        format.html { redirect_to @room, alert: "Pesan terlalu panjang, maksimal #{MAX_MESSAGE_LENGTH} karakter." }
        format.json { render json: { error: "Pesan terlalu panjang, maksimal #{MAX_MESSAGE_LENGTH} karakter." }, status: :unprocessable_entity }
      end
      return
    end

    # Filter kata kasar
    if contains_bad_word?(message)
      puts "ERROR: Bad word detected"
      respond_to do |format|
        format.html { redirect_to @room, alert: "Pesan mengandung kata yang tidak pantas." }
        format.json { render json: { error: "Pesan mengandung kata yang tidak pantas." }, status: :unprocessable_entity }
      end
      return
    end

    # Sanitasi pesan
    sanitized_message = sanitize_message(message)

    @room_message = @room.room_messages.new(
      message: sanitized_message,
      nickname: nickname,
      color: color
    )
    if @room_message.save
        puts "SUCCESS: Message saved with ID #{@room_message.id}"
        
        # Broadcast ke Action Cable - PASTIKAN FORMAT INI
        broadcast_data = {
          id: @room_message.id,
          nickname: @room_message.nickname,
          content: @room_message.message,
          color: @room_message.color,
          created_at: @room_message.created_at.iso8601
        }
        
        puts "Broadcasting to room_#{@room.id}: #{broadcast_data}"
        
        # Gunakan stream_from bukan stream_for
        ActionCable.server.broadcast(
          "room_#{@room.id}",
          broadcast_data
        )

        puts "Broadcast completed!"

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @room }
          format.json { 
            render json: { 
              message: "Pesan berhasil dikirim",
              data: broadcast_data
            }, status: :created 
          }
        end
      else
      puts "ERROR: Failed to save message - #{@room_message.errors.full_messages}"
      respond_to do |format|
        format.html { render 'rooms/show', status: :unprocessable_entity }
        format.json { render json: { error: 'Gagal menyimpan pesan' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
    puts "Room found: #{@room.name} (ID: #{@room.id})"
  end

  def contains_bad_word?(text)
    BAD_WORDS.any? { |word| text.downcase.include?(word) }
  end

  def sanitize_message(text)
    ActionController::Base.helpers.sanitize(text)
  end
end