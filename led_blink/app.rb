require 'rpi_gpio'
RPi::GPIO.set_numbering :bcm

require 'sinatra/base'

require_relative './led'
require_relative './led_controller'

class App < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'

    led_controller = LedController.new(mode: :blink)
    set :led_controller, led_controller
    Thread.new{ led_controller.start_loop }
  end

  get '/' do
    @current_mode = settings.led_controller.mode
    @current_interval = settings.led_controller.blink_interval
    erb :index
  end

  post '/settings' do
    settings.led_controller.mode = params[:mode].to_sym
    settings.led_controller.blink_interval = params[:blink_interval].to_f
    redirect to('/')
  end
end


at_exit do
  RPi::GPIO.reset
end

