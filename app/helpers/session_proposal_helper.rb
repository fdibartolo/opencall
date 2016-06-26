module SessionProposalHelper
  def comment_placeholder current_user_id, author_id
    current_user_is_author?(current_user_id, author_id) ? t('sessions.placeholders.author_comment') : t('sessions.placeholders.public_comment')
  end
  
  private
  def current_user_is_author? current_user_id, author_id
    current_user_id == author_id
  end
end
