#m41162520002
#m47975403002

#todo
#change val of button while posting  $this.val("i'm finally done!"); // pfewww, that's was hard work!
#disbale button while posting $inputs.prop("disabled", true);
#spinjs? http://fgnass.github.io/spin.js/
#background job https://github.com/faye/faye https://github.com/resque/resque

require 'sinatra'
require 'csv'
require_relative 'lib/mxitbroadcast.rb'

enable :sessions

get '/' do
	erb :send
end

post '/broadcast' do
	ENV['MXIT_KEY'] = params[:mxit_key]
	ENV['MXIT_SECRET'] = params[:mxit_secret]
	ENV['MXIT_APP_NAME'] = params[:mxit_app_name]

	#csv = CSV.open(params[:recipients][:tempfile].path, :skip_blanks => true)

	#Net::HTTP.get(URI(params[:recipients]))

	csv = CSV.parse(Net::HTTP.get(URI(params[:recipients])), :skip_blanks => true)

	csv.each_slice(500) do |users|
		begin
			MxitAPI.send_message(users.join(','), params[:message])
		rescue
			next
		end
	end

end

error do
  'Sorry there was a nasty error: ' + env['sinatra.error'].message.to_s
end