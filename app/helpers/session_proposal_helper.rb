module SessionProposalHelper
	def comment_placeholder current_user_id, author_id
		current_user_is_author?(current_user_id, author_id) ? t('sessions.placeholders.comment_by_author') : t('sessions.placeholders.comment')
	end

	private 
	def current_user_is_author? current_user_id, author_id
		current_user_id == author_id
	end
end