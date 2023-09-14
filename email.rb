# frozen_string_literal: true
require_relative 'config'
require_relative 'models/User'

module Email
  include Config
  def compose_token_update_email(target_user, old_token_count, new_token_count)
    email_content = {
      to: target_user.email,
      from: default_from_email,
      body:
        "Hello #{target_user.first_name},

Your company token count has been increased!

Old token count: #{old_token_count}
New token count: #{new_token_count}

Congratulations!"
    }
  end

  def send(email_content)
    if fake_email_sendout
      puts "faked email sendout to #{email_content[:to]}"
    else
      puts "WARNING: tried to send an email but email sendout is not set up"
    end
  end
end


if __FILE__ == $0
  extend Email
  test_user = User.new(1, 'Test', 'Testerton', 'test@testurl.com', 2, true, true, 67)
  puts test_user.email
  test_email_content = compose_token_update_email(test_user, test_user.tokens, test_user.tokens + 10)
  puts test_email_content
  send(test_email_content)
end
