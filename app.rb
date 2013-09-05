#m41162520002

require 'sinatra'
require_relative 'lib/mxitbroadcast.rb'

get '/' do
	erb :send
end

post '/' do
	ENV['MXIT_KEY'] = params[:mxit_key]
	ENV['MXIT_SECRET'] = params[:mxit_secret]
	ENV['MXIT_APP_NAME'] = params[:mxit_app_name]

	MxitAPI.send_message(params[:recipients], params[:message])

	"<a href='/'>Back</a><script>alert('Sent!')</script>"
end

error do
  'Sorry there was a nasty error: ' + env['sinatra.error'].message.to_s
end