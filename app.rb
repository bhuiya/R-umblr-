require 'sinatra'
require 'mailgun'
# require 'restart'
require './models'
require 'sinatra/reloader'
#require 'byebug'

set :session_secret, ENV['SEI_SESSION_SECRECT']
enable :sessions
get '/' do
		erb :login
end

post ('/login') do
	@email = params[:email]
	@password = params[:password2]
	user = User.find_by(email: @email)
  if @email=="" or  @password==""
     erb :login
	end
	if user.nil?
		 erb :login
	elsif user.password!= @password
     erb :login
	else
  	session[:user_id] = user.id
	  redirect '/dashboard'
  end
end

get('/logout') do

  if  session[:user_id]!=nil
      session[:user_id]=nil
  end
    redirect '/'
end


get '/dashboard' do
   user_id = session[:user_id]
   @user = User.find(user_id)
   @userpost = Userpost.all
   @all_post=   @userpost.count
	 @user = User.find_by(id: session[:user_id])
	 @userpost= @user.userposts
	 @current_post= @userpost.count
	 erb :drashboard_view, layout: :dashboardlayout
end

post ('/drashboard_view') do
   @subject = params[:subject]
   @catagory= params[:catagory]
   @editor_val = params[:editor1]
	 Userpost.create(title: @subject,
				 catagory:@catagory,
	 description: @editor_val,
						   user_id: session[:user_id])
   redirect './post/create'
end

get '/post/create' do
	 @userpost = Userpost.all
	 @all_post=   @userpost.count
	 @user = User.find_by(id: session[:user_id])
	 @userpost= @user.userposts
   @current_post= @userpost.count
   erb :drashboard_view, layout: :dashboardlayout
end

post '/new_user' do
  	@val1=   params[:password1].to_s
		@val2 =  params[:password2].to_s
		if @val1 == @val2
			if @val1.length < 6
		    	@length = @val1.length
        	erb :new_user
	 		else
         @username= params[:user_name]
				 @password =  params[:password1]
				 @email = params[:email]
				 @dob = params[:dob]
				 existing_email = User.find_by(email: @email)
         existing_user = User.find_by(username: @username)
				 if existing_user != nil
				   	@existing_user=true
				  	erb :new_user
			   elsif existing_email!= nil
            @existing_email=true
						erb :new_user
				 else
            User.create(username: @username,
										          password:@password,
																email: @email,
																		dob: @dob)
  			      erb :login
	 		   end
  	  end
	 	else
		  erb :new_user, layout: :dashboardlayout
	 end
end

get '/user/all/post' do
  @userpost = Userpost.all
  @all_post=   @userpost.count
	erb :user_all_post , layout: :dashboardlayout
end

get '/user/post' do
  @user = User.find_by(id: session[:user_id])
  @userpost= @user.userposts
  erb :user_post , layout: :dashboardlayout
end

get '/user/post/:userid/:id' do
  @post= Userpost.find_by(id: params[:id])
  @post_id= params[:id]
	@post_userid = params[:userid]
	@post_description = @post.description
	@post_title = @post.title
	@post_catagory  = @post.catagory
	session[:id]= @post_id
  erb :postedit, layout: :dashboardlayout
end

post ('/user/post/update/:userid/:id') do
	@user_post= Userpost.find_by(id: params[:id])
	@user_post.update(
        title: params[:subject],
				catagory: params[:catagory],
				description: params[:editor1])
	redirect './post/update'
end

get '/users' do
   @users = User.all
	 erb :users , layout: :dashboardlayout
 end

get '/settings' do
 	@users = User.find(session[:user_id])
 	erb :settings , layout: :dashboardlayout
end

get '/catagories' do
 	erb :catagories , layout: :dashboardlayout
end

get '/post/update' do
  @userpost = Userpost.all
 	@all_post=   @userpost.count
 	@user = User.find_by(id: session[:user_id])
 	@userpost= @user.userposts
 	@current_post= @userpost.count
	erb :drashboard_view, layout: :dashboardlayout
end

get '/delete/account' do
  @user = User.find(session[:user_id])
  @user.destroy
	if  session[:user_id]!=nil
		       session[:user_id]=nil
	end
  redirect '/'
end
