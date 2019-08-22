class Question < ApplicationRecord
	has_many :options, dependent: :delete_all

	def level_text
		case level.to_i
		when 2
			return '中級'
		when 3
			return '上級'
		when 4
			return '最上級'
		else
			return '初級'
		end
	end
end
