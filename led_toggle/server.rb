#!/usr/bin/ruby 

require 'rpi_gpio'
require 'sinatra'

set :bind, '0.0.0.0'
PIN = 23

RPi::GPIO.set_numbering :bcm

get '/' do
  RPi::GPIO.setup PIN, as: :input
  @current_state = RPi::GPIO.high?(PIN) ? :high : :low
  RPi::GPIO.setup PIN, as: :output, initialize: @current_state
  erb :index 
end

post '/led/toggle' do
  begin
    RPi::GPIO.setup PIN, as: :input
    new_state = RPi::GPIO.high?(PIN) ? :low : :high
    RPi::GPIO.setup PIN, :as => :output, initialize: new_state
  #rescue Errno::EBUSY => e
    # do nothing
  end
  redirect to('/')
end

__END__

@@ layout
<html>
<head>
  <title>Led example</title>
</head>

<body>
  <%= yield %>
</body>
</html>


@@ index
<p style="font-size: 1.2em">Светодиод <strong><%= @current_state == :high ? 'включен' : 'выключен' %></strong></p>
<form action='/led/toggle' method='POST'>
  <button type='submit' name='submit'>Переключить</button>
</form>
