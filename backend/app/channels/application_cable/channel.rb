module ApplicationCable
  class Channel < ActionCable::Channel::Base
    private

    def broadcast_to(model, message)
      puts "=== Action Cable Broadcasting ==="
      puts "Model: #{model}"
      puts "Message: #{message}"
      puts "================================="
      super
    end
  end
end