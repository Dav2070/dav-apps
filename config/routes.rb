Rails.application.routes.draw do

	# StartsController
	root 'starts#index'
	get 'privacy', to: 'starts#privacy'
	get 'pricing', to: 'starts#pricing'

	# UsersController
	get 'login', to: 'users#login'
	post 'login', to: 'users#login_action'
	get 'logout', to: 'users#logout'
	get 'signup', to: 'users#signup'
	post 'signup', to: 'users#signup_action'
	get 'user', to: 'users#show'
	post 'user', to: 'users#update'

	get 'password_reset', to: 'users#password_reset'
	post 'password_reset', to: 'users#password_reset_action'
	get 'reset_password/:password_confirmation_token', to: 'users#reset_password', as: 'reset_password'
	post 'reset_password/:password_confirmation_token', to: 'users#reset_password_action'
	get 'resend_activation_email', to: 'users#resend_activation_email'
	post 'resend_activation_email', to: 'users#resend_activation_email_action'
	get 'confirm_user/:id/:email_confirmation_token', to: 'users#confirm_user'
	get 'change_email/:id/:email_confirmation_token', to: 'users#change_email'
	get 'change_password/:id/:password_confirmation_token', to: 'users#change_password'
	get 'reset_new_email/:id', to: 'users#reset_new_email'

	# AppsController
	get 'apps', to: 'apps#index'
end
