require 'sinatra'
require 'dropbox_sdk'
enable :sessions #needed to persist state between requests


get '/' do
	redirect '/login'
end

get '/login' do
	app_key = 'imizwwjuoo2wn6j'
	app_secret = 'xoe8wjyvmocpq43'
	dropbox_session = DropboxSession.new(app_key, app_secret)
	session[:dropbox] = dropbox_session.serialize()
	authorize_url = dropbox_session.get_authorize_url("http://localhost:4567/files")
	# make the user sign in and authorize this token
	"Authorize <br /><a href=\""+ authorize_url+"\">url</a><br/>Please visit this website and press the 'Allow' button, then goto files here."

end

get '/files' do
	redirect '/login' unless session[:dropbox]
	dropbox_session = DropboxSession::deserialize(session[:dropbox])
	dropbox_session.get_access_token rescue redirect '/login'
	client = DropboxClient.new(dropbox_session, :app_folder)
	"linked account: "+ client.account_info().inspect
end

get '/logout' do
	session[:dropbox] = nil
	redirect '/login'
end