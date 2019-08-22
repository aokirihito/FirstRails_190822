# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

work_list = CSV.read('./db/work_list.csv').map { |row| {code: row[0]} }
work_list.each { |work| Work.create(name: work) }

questions = CSV.read('./db/quiz.csv').map { |row| {work: row[0], \
															quiz: row[1], \
															opt_1: row[2], \
															opt_2: row[3], \
															opt_3: row[4], \
															opt_4: row[5], \
															correct: row[6], \
															description: row[7]
														} }
questions.each do |quiz| 
	question = Question.create(work: quiz[:work], quiz: quiz[:quiz], correct: quiz[:correct], description: quiz[:description])
	question.options.create(value: quiz[:opt_1])
	question.options.create(value: quiz[:opt_2])
	question.options.create(value: quiz[:opt_3])
	question.options.create(value: quiz[:opt_4])
end
