class LedController
  attr_accessor :mode, :blink_interval

  def initialize(opts)
    @mode = opts.fetch(:mode, :blink)
    @blink_interval = opts.fetch(:blink_interval, 0.5)

    @last_toggle = Time.now
    @led = Led.new(pin: 23)
  end

  def start_loop
    loop do
      case mode
      when :blink then toggle_led if time_to_toggle?
      when :off then led.turn(:off) if led.on?
      when :on then led.turn(:on) if led.off?
      end

      sleep 0.01
    end
  end

  private
  attr_reader :led
  attr_accessor :last_toggle

  def time_to_toggle?
    Time.now - last_toggle >= blink_interval
  end

  def toggle_led
    led.toggle
    self.last_toggle = Time.now
  end
end
