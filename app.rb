#m41162520002
#m47975403002

require 'sinatra'
require 'csv'
require_relative 'lib/mxitbroadcast.rb'

enable :sessions

get '/' do
	erb :send
end

post '/' do
	ENV['MXIT_KEY'] = params[:mxit_key]
	ENV['MXIT_SECRET'] = params[:mxit_secret]
	ENV['MXIT_APP_NAME'] = params[:mxit_app_name]

	csv = CSV.open(params[:recipients][:tempfile].path, :skip_blanks => true)
	
	csv.each_slice(500) do |users|
		begin
			MxitAPI.send_message(users.join(','), params[:message])
		rescue
			next
		end
	end

	redirect to ('/done')

end

get '/done' do
	erb :done
end

error do
  'Sorry there was a nasty error: ' + env['sinatra.error'].message.to_s
end