# frozen_string_literal: true

# Main file for running data processing, emailing, and reporting

require_relative 'models/company'
require_relative 'email'
require_relative 'reports'

# Procedure
# create company objects
all_companies = Company.all
puts("all_companies: #{all_companies}")

# create batch report
token_update_report_batch = Reports::BatchCompanyUsersTokenUpdate.new

# for each company
all_companies.each do |company|
  #   create company report element
  company_report = Reports::CompanyUsersTokenUpdate.new(company)
  #   get company active users
  company_active_users = company.active_users
  #   for each active user
  company_active_users.each do |user|
    #     update user token balance
    previous_token_balance = user.tokens
    new_token_balance      = previous_token_balance + company.top_up
    #     optionally email user
    user_emailed = false
    if company.email_status and user.email_status
      email_content = Email.compose_token_update_email(user, previous_token_balance, new_token_balance)
      Email.send(email_content)
      user_emailed = true
    end
    #     update company report element
    company_report.add_user(user: user, user_emailed: user_emailed, old_token_balance: previous_token_balance, new_token_balance: new_token_balance)
  end

  #   add company report element to batch report
  token_update_report_batch.add(company_report)
end

puts("batch_report: #{token_update_report_batch.company_updates}")

# present batch report (as output.txt)

# if __FILE__ == $0
#   puts('--  Company Users Token Updater   --')
#   puts('   (press any key to begin batch)')
#   gets
#
#   puts('done.')
#   puts('Output file is available at: output/output.txt')
# end
