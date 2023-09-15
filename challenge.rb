# frozen_string_literal: true

# Main file for running data processing, emailing, and reporting

require_relative 'models/company'
require_relative 'email'
require_relative 'reports'

# Procedure
all_companies = Company.all
puts("all_companies: #{all_companies}")

# create batch report
token_update_report_batch = Reports::BatchCompanyUsersTokenUpdate.new

all_companies.each do |company|
  company_report = Reports::CompanyUsersTokenUpdate.new(company)
  company_active_users = company.active_users
  company_active_users.each do |user|
    previous_token_balance = user.tokens
    new_token_balance      = previous_token_balance + company.top_up
    #     optionally email user
    user_emailed = false
    if company.email_status and user.email_status
      email_content = Email.compose_token_update_email(user, previous_token_balance, new_token_balance)
      Email.send(email_content)
      user_emailed = true
    end
    company_report.add_user(user: user, user_emailed: user_emailed, old_token_balance: previous_token_balance, new_token_balance: new_token_balance)
  end

  #   add company report element to batch report
  if company_report.total_topups > 0
    token_update_report_batch.add(company_report)
  end
end

puts("batch_report: #{token_update_report_batch.company_updates}")

token_update_report_batch.generate_output_file(filename: 'output.txt')

# present batch report (as output.txt)
# TODO: generate text from batch report
# TODO: create report output file
# TODO: add error handling
# TODO: final spec details from challenge.txt
