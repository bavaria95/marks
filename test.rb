require 'sinatra'
require 'digest'
require 'rubygems'
require 'active_record'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'Users.db'
)

class User < ActiveRecord::Base
	validates :Login, presence: true
	validates :Passwd, presence: true
end


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
		'lol'
		redirect to('/singup') 
	end

	@user = User.create(Login: @login, Passwd: @pass_hash)

	redirect to('/grades/' + @login)
	'done'
end

get '/grades/:login' do
	@login = params[:login]
	'qweee'

end