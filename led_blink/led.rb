class Led
  STATES = {high: :on, low: :off}.freeze

  def initialize(opts)
    @pin = opts.fetch(:pin)
  end

  def on?
    current == :on
  end

  def off?
    current == :off
  end

  def turn(desired)
    level = {off: :low, on: :high}[desired]
    setup(as: :output, initialize: level)
  end

  def toggle
    switch_to = current == :on ? :off : :on
    turn( switch_to )
  end

  private
  attr_reader :pin

  def setup(opts)
    RPi::GPIO.setup(pin, opts)
  end

  def current
    setup(as: :input)
    current = RPi::GPIO.high?(pin) ? :high : :low
    setup(as: :output, initialize: current)

    STATES[current]
  end
end
