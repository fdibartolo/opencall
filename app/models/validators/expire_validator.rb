class ExpireValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, "has expired (>5 mins from its creation date)" if expired?(value)
  end

  def expired? id
    session = SessionProposal.find(id)
    not (session.created_at.between? Time.now - 5.minutes, Time.now)
  end
end
