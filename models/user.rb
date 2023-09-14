# frozen_string_literal: true

class User
  def initialize(id, first_name, last_name, email, company_id, email_status, active_status, tokens)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @email = email
    @company_id = company_id
    @email_status = email_status
    @active_status = active_status
    @tokens = tokens
  end

end
