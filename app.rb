require 'sinatra'
require 'digest'
require 'rubygems'
require 'active_record'
require "google/api_client"
require "google_drive"


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'Users.db'
)

class User < ActiveRecord::Base
	validates :Login, presence: true
	validates :Passwd, presence: true
end

enable :sessions


# Authorizes with OAuth and gets an access token.
client = Google::APIClient.new
auth = client.authorization
auth.client_id = ""		# client id
auth.client_secret = ""				# client secret key
auth.scope =
    "https://www.googleapis.com/auth/drive " +
    "https://spreadsheets.google.com/feeds/"
auth.redirect_uri = "" 			# redirect URI
print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
print("2. Enter the authorization code shown in the page: ")
auth.code = $stdin.gets.chomp
auth.fetch_access_token!
access_token = auth.access_token

# Creates a session.
s = GoogleDrive.login_with_oauth(access_token)

# First worksheet of
# https://docs.google.com/spreadsheets/d/1rHQsEl-p_h6heKZW70R9xISEdTlyl1lgQXMgE2f9qZg/edit#gid=1403440044
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
worksheets = s.spreadsheet_by_key("1rHQsEl-p_h6heKZW70R9xISEdTlyl1lgQXMgE2f9qZg").worksheets


get '/' do
	erb :index
end

get '/login' do
	erb :login
end

post '/authorization' do
	@login = params[:login]
	md5 = Digest::MD5.new
	md5.update params[:passwd]
	@pass_hash = md5.hexdigest

	unless User.where(Login: @login, Passwd: @pass_hash).any?
		erb :access_denied
	else
		session[:login] = @login
		redirect to('/grades/' + @login)
	end
end

get '/singup' do
	erb :registration
end

post '/registration' do
	@login = params[:login]
	md5 = Digest::MD5.new
	md5.update params[:passwd]
	@pass_hash = md5.hexdigest

	@test = User.find_by(Login: @login)
	if @test
		redirect to('/singup') 
	end

	@user = User.create(Login: @login, Passwd: @pass_hash)

	redirect to('/grades/' + @login)
	'done'
end

get '/grades/:login' do
	@login = params[:login]

	puts "login in session: #{session[:login]}"
	puts "login from url: #{@login}"
	redirect to('/login') if session[:login] != @login

	@marks = Hash.new{|hash, key| hash[key] = Hash.new}
	worksheets.each do |ws|
		(2..ws.num_rows).each do |i|
			if ws[i, 1] == @login
				(2..ws.num_cols).each do |j|
					@marks[ws.title][ws[1, j]] = ws[i, j]
				end
			end
		end
	end

	@marks.each {|subj, p| p['Ocena'] = p.values.map{|x| x.to_f}.inject(:+)/p.length}

	erb :page

end