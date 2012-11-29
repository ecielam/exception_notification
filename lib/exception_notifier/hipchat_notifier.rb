class ExceptionNotifier
  class HipchatNotifier
    require 'hipchat'

    attr_accessor :subdomain
    attr_accessor :token
    attr_accessor :room
    attr_accessor :user_name
    attr_accessor :color

    def initialize(options)
      begin
        token      = options.delete(:token)
        room_name  = options.delete(:room_name)
        @user_name = options.delete(:user_name)
        @color     = options.delete(:color)

        @room      = HipChat::Client.new(token)[room_name]
      rescue
        @room = nil
      end
    end

    def exception_notification(exception)
      @room.send(@user_name,
        "A new exception occurred: '#{exception.message}' on '#{exception.backtrace.first}'",
        :color => @color) if active?
    end

    private

    def active?
      !@room.nil?
    end
  end
end
