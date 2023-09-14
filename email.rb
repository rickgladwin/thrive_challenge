# frozen_string_literal: true
require 'config'

module Email
  def compose_token_update_email(first_name, email, new_token_count)
    email_content = {
      to: default_from_email
    }

  end

  def send()

  end
end
