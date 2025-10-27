class RoomsController < ApplicationController
  # Skip CSRF untuk create action jika request JSON
  skip_before_action :verify_authenticity_token, only: [:create], if: -> { request.format.json? }

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
    @room = Room.new(permitted_parameters)

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
    if @room.update(permitted_parameters)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :new
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
end