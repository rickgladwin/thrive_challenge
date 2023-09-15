# frozen_string_literal: true
require_relative 'config'
require_relative 'models/User'

module Email
  def self.compose_token_update_email(target_user, old_token_count, new_token_count)
    email_content = {
      to:   target_user.email,
      from: Config.default_from_email,
      body:
            "Hello #{target_user.first_name},

Your company token count has been increased!

Old token count: #{old_token_count}
New token count: #{new_token_count}

Congratulations!"
    }
    email_content
  end

  def self.send(email_content)
    if Config.fake_email_sendout
      puts "faked email sendout to #{email_content[:to]}"
    else
      puts "WARNING: tried to send an email but email sendout is not set up"
    end
  end
end

if __FILE__ == $0
  test_user = User.new(id: 1, first_name: 'Test', last_name: 'Testerton', email: 'test@testurl.com', company_id: 2, email_status: true, active_status: true, tokens: 67)
  puts test_user.email
  test_email_content = Email.compose_token_update_email(test_user, test_user.tokens, test_user.tokens + 10)
  puts test_email_content
  Email.send(test_email_content)
end
