class WelcomeController < ApplicationController
	before_action :check_mobile
	require 'csv'
	def top
		@topics = Topic.all
	end
	def topic
	  require 'rss'
	  require 'open-uri'
	  Topic.destroy_all
	  rss_results = []
	  rss = RSS::Parser.parse(open('https://eiken-anime.jp/?feed=rss2&cat=72').read, false).items[0..5]
	  rss.each do |result|
	    Topic.create(title: result.title, date: result.pubDate, link: result.link, description: result.description)
	  end

	  @topics = Topic.all
	end

	def quiz
		Rails.logger.info request.url.split('/').last
		level = 1
		case request.url.split('/').last
		when 'medium'
			level = 2
		when 'hard'
			level = 3
		when 'veryhard'
			level = 4
		end

		flag = false
		if session[:current_cnt].nil?
			flag = true
		else
			current_id = session[:quiz_ids][session[:current_cnt]]
			quiz = Question.find(current_id)
			flag = true if quiz.level != level

			session[:current_cnt] += 1 if params[:option_id].present?
		end

		if flag
			session[:quiz_ids] = Question.where(level: level).order("RANDOM()").limit(10).collect(&:id)
			Rails.logger.info "#{session[:quiz_ids]}"
			session[:current_cnt] = 0
			session[:mark] = 0
		end
		Rails.logger.info "#{session[:current_cnt]}=========="

		if session[:current_cnt] == 10
			@mark = session[:mark]
			reset_session
		else
			prev_id = session[:quiz_ids][session[:current_cnt] - 1]
			current_id = session[:quiz_ids][session[:current_cnt]]
			Rails.logger.info "#{session[:current_cnt]}________#{prev_id}______#{current_id}______"
			@quiz = Question.find(current_id)
			if params[:option_id].present?
				@option_id = true
				@prev_quiz = Question.find(prev_id)
				correct_option = @prev_quiz.options[@prev_quiz.correct.to_i - 1]
				@answer = correct_option.value
				@correct = false
				if correct_option.id == params[:option_id].to_i
					session[:mark] += 10 
					@correct = true
				end
			else
				Rails.logger.info "#{prev_id}______#{current_id}______"
			end
		end
	end

	def import_csv
		
		Rails.logger.info params[:level]
		level = params[:level].to_i
		Question.where(level: level).delete_all
			
		
		file = File.open(params[:file].path, 'r')
		content = file.read.force_encoding('UTF-8')
		content.gsub!("\xEF\xBB\xBF".force_encoding('UTF-8'), '')
		csv = CSV.parse(content, headers: false)
		csv.each do |quiz|
			question = Question.create(work: quiz[0], quiz: quiz[1], correct: quiz[6], description: quiz[7], level: params[:level].to_i)
			question.options.create(value: quiz[2])
			question.options.create(value: quiz[3])
			question.options.create(value: quiz[4])
			question.options.create(value: quiz[5])
		end
	end

	def check_mobile
		Rails.logger.info request.smart_phone?
		Rails.logger.info request.mobile?
		Rails.logger.info request.tablet?
		if request.smart_phone? || request.mobile? || request.tablet?
			@is_mobile = true
		else
			@is_mobile = false
		end
		Rails.logger.info @is_mobile
	end
end
