# frozen_string_literal: true

class Company
  def initialize(id, name, top_up, email_status)
    @id = id
    @name = name
    @top_up = top_up
    @email_status = email_status
  end
end
