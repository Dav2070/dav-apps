class DevsController < ApplicationController

	before_action :require_user

	def index
		begin
			@dev = Dav::Dev.get(session[:jwt])
		rescue StandardError => e
			puts e.message
			flash[:danger] = "There was an error: " + e.message
			redirect_to root_path
		end
	end

	def create_app
		name = params[:name]
		description = params[:description]

		begin
			app = Dav::App.create(session[:jwt], name, description)
			redirect_to dev_path
		rescue StandardError => e
			puts replace_error_message(e.message)
			flash[:danger] = replace_error_message(e.message)
			redirect_to dev_path
		end
	end

	def general
		begin
			@users = Dav::Analytics.get_users(session[:jwt])["users"]
			@plan_count = Hash.new

			# Sort for the users chart
			default_period = 10 * 365 * 24 * 60 * 60		# 10 years
			sort_by = params["sort_by"]
			period = params["period"] ? params["period"] : default_period
			period_start = Time.now - period.to_i

			@sorted_users_period = Hash.new
			users_period = Array.new

			# Remove all logs that are outside the period
			@users.each do |user|
				user_date = DateTime.parse(user["created_at"])

				if user_date > period_start
					users_period.push(user)
				end
			end

			# Set the plan count
			@plan_count["Free"] = 0
			@plan_count["Plus"] = 0
			users_period.each do |user|
				plan = user["plan"]
				if plan == 0
					@plan_count["Free"] += 1
				elsif plan == 1
					@plan_count["Plus"] += 1
				end
			end

			@new_users_count = users_period.count

			if users_period.count == 0
				return
			end

			start_date = DateTime.parse(users_period.first["created_at"])
			first_date = DateTime.parse(@users.first["created_at"])
			end_date = DateTime.now

			if sort_by == "year"
				@sorted_users_period[format_year(start_date)] = 0
				@sorted_users_period[format_year(end_date)] = 0

				RailsDateRange(start_date..end_date + 1.years).every(years: 1).each do |date|
					@sorted_users_period[format_year(date)] = 0
	
					@users.each do |user|
						if (first_date..date).cover?(user["created_at"])
							@sorted_users_period[format_year(date)] += 1
						end
					end
				end
			elsif sort_by == "day"
				@sorted_users_period[format_day(start_date)] = 0
				@sorted_users_period[format_day(end_date)] = 0

				RailsDateRange(start_date..end_date + 1.day).every(days: 1).each do |date|
					@sorted_users_period[format_day(date)] = 0
	
					@users.each do |user|
						if (first_date..date).cover?(user["created_at"])
							@sorted_users_period[format_day(date)] += 1
						end
					end
				end
			elsif sort_by == "hour"
				@sorted_users_period[format_hour(start_date)] = 0
				@sorted_users_period[format_hour(end_date)] = 0

				RailsDateRange(start_date..end_date + 1.hour).every(hours: 1).each do |date|
					@sorted_users_period[format_hour(date)] = 0
	
					@users.each do |user|
						if (first_date..date).cover?(user["created_at"])
							@sorted_users_period[format_hour(date)] += 1
						end
					end
				end
			else	# Sort by month
				@sorted_users_period[format_month(start_date)] = 0
				@sorted_users_period[format_month(end_date)] = 0

				RailsDateRange(start_date..end_date + 1.months).every(months: 1).each do |date|
					@sorted_users_period[format_month(date)] = 0
	
					@users.each do |user|
						if (first_date..date).cover?(user["created_at"])
							@sorted_users_period[format_month(date)] += 1
						end
					end
				end
			end
			
		rescue StandardError => e
			puts e.message
			flash[:danger] = "There was an error: " + e.message
			redirect_to root_path
		end
	end

	def set_general_period
		period_length = params[:period].to_i
		period_format = params[:period_format]
		sort_by = params[:sort_by]

		period = convert_period_to_timestamp(period_format, period_length)

		redirect_to show_general_path(sort_by: sort_by, period: period)
	end

	def show
		@app = Dav::App.get(session[:jwt], params[:id])
	end

	def create_table
		name = params[:name]

		begin
			table = Dav::Table.create(session[:jwt], name, params[:id])
			redirect_to show_app_path(params[:id])
		rescue StandardError => e
			puts replace_error_message(e.message)
			flash[:danger] = replace_error_message(e.message)
			redirect_to show_app_path(params[:id])
		end
	end

	def show_table
		@table = Dav::Table.get(session[:jwt], params[:id], params[:name])
	end

	def show_event
		@event = Dav::Event.get_by_name(session[:jwt], params[:name], params[:id])

		default_period = 60 * 60 * 24 * 30	# Ca. one month
		sort_by = params["sort_by"]
		period = params["period"] ? params["period"] : default_period

		period_start = Time.now - period.to_i

		@sorted_date_logs = Hash.new
		@sorted_data_logs = Hash.new
		event_logs = Array.new

		# Remove all logs that are outside the period
		@event.logs.each do |log|
			log_date = DateTime.parse(log["created_at"])

			if log_date > period_start
				event_logs.push(log)
			end
		end

		if event_logs.count == 0
			return
		end

		# Set every entry between the first date and the last date to 0
		start_date = DateTime.parse(event_logs.first["created_at"])
		end_date = DateTime.parse(event_logs.last["created_at"])

		if sort_by == "year"
			RailsDateRange(start_date..end_date).every(years: 1).each do |log|
				@sorted_date_logs[format_year(log)] = 0
			end

			@sorted_date_logs[format_year(start_date)] = 0
			@sorted_date_logs[format_year(end_date)] = 0
		elsif sort_by == "month"
			RailsDateRange(start_date..end_date).every(months: 1).each do |log|
				@sorted_date_logs[format_month(log)] = 0
			end

			@sorted_date_logs[format_month(start_date)] = 0
			@sorted_date_logs[format_month(end_date)] = 0
		elsif sort_by == "hour"
			RailsDateRange(start_date..end_date).every(hours: 1).each do |log|
				@sorted_date_logs[format_hour(log)] = 0
			end

			@sorted_date_logs[format_hour(start_date)] = 0
			@sorted_date_logs[format_hour(end_date)] = 0
		else	# Sort by day
			RailsDateRange(start_date..end_date).every(days: 1).each do |log|
				@sorted_date_logs[format_day(log)] = 0
			end

			@sorted_date_logs[format_day(start_date)] = 0
			@sorted_date_logs[format_day(end_date)] = 0
		end

		event_logs.each do |log|
			log_date = DateTime.parse(log["created_at"])
			log_data = log["data"]

			if sort_by == "year"
				date = format_year(log_date)
			elsif sort_by == "month"
				date = format_month(log_date)
			elsif sort_by == "hour"
				date = format_hour(log_date)
			else	# Sort_by == day
				date = format_day(log_date)
			end

			# Count the date up by one
			@sorted_date_logs[date] = @sorted_date_logs[date] + 1

			if log_data
				if @sorted_data_logs[log_data] 
					@sorted_data_logs[log_data] = @sorted_data_logs[log_data] + 1
				else
					@sorted_data_logs[log_data] = 1
				end
			end
		end
	end

	def set_event_period
		period_length = params[:period].to_i
		period_format = params[:period_format]
		sort_by = params[:sort_by]

		period = convert_period_to_timestamp(period_format, period_length)

		redirect_to show_event_path(sort_by: sort_by, period: period)
	end

	private
	def convert_period_to_timestamp(period_format, period_length)
		case period_format
			when "Hours"
				period = period_length * 60 * 60
			when "Days"
				period = period_length * 24 * 60 * 60
			when "Weeks"
				period = period_length * 7 * 24 * 60 * 60
			when "Months"
				period = period_length * 4 * 7 * 24 * 60 * 60
			when "Years"
				period = period_length * 365 * 24 * 60 * 60
			else
				period = period_length * 7 * 24 * 60 * 60
		end

		return period
	end
end