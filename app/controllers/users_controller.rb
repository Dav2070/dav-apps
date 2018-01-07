class UsersController < ApplicationController
   #before_action :create_auth_object, only: [:login_action, :signup_action]

   def login
      
   end

   def login_action
      email = params[:email]
      password = params[:password]
      auth = get_auth_object

      begin
         user = auth.login(email, password)
         session[:jwt] = user.jwt
         puts user.jwt

         redirect_to root_path
      rescue StandardError => e
         flash.now[:danger] = e.message
         render 'login'
      end
   end

   def logout
      session[:jwt] = "";
   end

   def signup

   end

   def signup_action
      username = params[:username]
      email = params[:email]
      password = params[:password]
      password_confirmation = params[:password_confirmation]
      auth = get_auth_object

      begin
         if password == password_confirmation
            auth.signup(email, password, username)

            flash[:success] = "Thanks for signing up! You will receive an email to confirm your account."
            redirect_to root_path
         else
            flash.now[:danger] = "The password confirmation does not match your password"
         render 'signup'
         end
      rescue StandardError => e
         flash.now[:danger] = e.message
         render 'signup'
      end
   end

   private
   def get_auth_object
      Dav::Auth.new(api_key: ENV["DAV_API_KEY"], 
                           secret_key: ENV["DAV_SECRET_KEY"],
                           uuid: ENV["DAV_UUID"],
                           environment: Rails.env)
   end
end