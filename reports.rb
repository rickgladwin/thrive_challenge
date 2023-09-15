# frozen_string_literal: true

require 'stringio'

# Handles generation and output of reports
module Reports

  class CompanyUsersTokenUpdate
    attr_reader :company_id
    attr_reader :company_name
    attr_accessor :users_emailed
    attr_accessor :users_not_emailed
    attr_accessor :total_topups

    def initialize(company)
      @company_id        = company.id
      @company_name      = company.name
      @users_emailed     = []
      @users_not_emailed = []
      @total_topups      = 0
    end

    def add_user(user:, user_emailed:, old_token_balance:, new_token_balance:)
      user_entry = {
        user_info:              "#{user.last_name}, #{user.first_name}, #{user.email}",
        previous_token_balance: old_token_balance,
        new_token_balance:      new_token_balance,
      }
      if user_emailed
        @users_emailed << user_entry
      else
        @users_not_emailed << user_entry
      end

      @total_topups += (new_token_balance - old_token_balance)
    end

    def to_text
      text = StringIO.new
      text << "\tCompany Id: #{@company_id}\n"
      text << "\tCompany Name: #{@company_name}\n"
      text << "\tUsers Emailed:\n"
      @users_emailed.each do |user|
        text << "\t\t#{user[:user_info]}\n"
        text << "\t\t  Previous Token Balance, #{user[:previous_token_balance]}\n"
        text << "\t\t  New Token Balance #{user[:new_token_balance]}\n"
      end
      text << "\tUsers Not Emailed:\n"
      @users_not_emailed.each do |user|
        text << "\t\t#{user[:user_info]}\n"
        text << "\t\t  Previous Token Balance, #{user[:previous_token_balance]}\n"
        text << "\t\t  New Token Balance #{user[:new_token_balance]}\n"
      end
      text << "\t\tTotal amount of top ups for #{@company_name}: #{@total_topups}\n"
      text << "\n"
    end
  end

  class BatchCompanyUsersTokenUpdate
    attr_accessor :company_updates

    def initialize
      @company_updates = []
    end

    def add(company_report)
      @company_updates << company_report
    end

    def to_text
      text = StringIO.new
      text << "\n"
      @company_updates.each do |company_update|
        text << company_update.to_text.string
      end
      text
    end

    def generate_output_file(filename:)
      filename    = 'output.txt' unless filename.class == String and filename.length > 0
      text        = self.to_text
      output_file = File.open(File.expand_path("output/#{filename}", File.dirname(__FILE__)), 'w')
      output_file.write(text.string)
      output_file.close
    end
  end
end

if __FILE__ == $0
  require_relative 'config'
  exit unless Config.run_file_level_unit_tests

  # basic unit tests
  require_relative 'models/company'
  test_company = Company.new(id: 1, name: 'Test Inc.', top_up: 12, email_status: true)
  test_user_1  = User.new(id: 1, first_name: 'Testy', last_name: 'Testerton', email: 'test@example.com', company_id: 1, email_status: true, active_status: true, tokens: 45)
  test_user_2  = User.new(id: 2, first_name: 'Testo', last_name: 'McTest', email: 'test2@example.com', company_id: 1, email_status: false, active_status: true, tokens: 34)

  # creates a company users token update report element
  test_company_update = Reports::CompanyUsersTokenUpdate.new(test_company)
  raise "failed to initialize" unless test_company_update.class == Reports::CompanyUsersTokenUpdate

  # adds emailed user
  test_company_update.add_user(user: test_user_1, user_emailed: true, old_token_balance: test_user_1.tokens, new_token_balance: test_user_1.tokens + test_company.top_up)
  raise "failed to add emailed user" unless test_company_update.users_emailed.length == 1 and test_company_update.users_emailed[0][:user_info].include? test_user_1.email

  # adds not emailed user
  test_company_update.add_user(user: test_user_2, user_emailed: false, old_token_balance: test_user_2.tokens, new_token_balance: test_user_2.tokens + test_company.top_up)
  # puts("test_company_update.users_not_emailed: #{test_company_update.users_not_emailed}")
  raise "failed to add not emailed user" unless test_company_update.users_not_emailed.length == 1 and test_company_update.users_not_emailed[0][:user_info].include? test_user_2.email

  # builds batch report
  test_report_batch = Reports::BatchCompanyUsersTokenUpdate.new
  raise "failed to initialize batch report" unless test_report_batch.class == Reports::BatchCompanyUsersTokenUpdate

  # adds company report to batch
  test_report_batch.add(test_company_update)
  raise "failed to add company report to batch" unless test_report_batch.company_updates.length == 1 and test_report_batch.company_updates[0].company_id == test_company.id

  # generates batch report text
  known_good_batch_report_text = "
\tCompany Id: 1
\tCompany Name: Test Inc.
\tUsers Emailed:
\t	Testerton, Testy, test@example.com
\t	  Previous Token Balance, 45
\t	  New Token Balance 57
\tUsers Not Emailed:
\t	McTest, Testo, test2@example.com
\t	  Previous Token Balance, 34
\t	  New Token Balance 46
\t	Total amount of top ups for Test Inc.: 24

"
  batch_text = test_report_batch.to_text
  # print("batch_text: \n#{batch_text.string}")
  # print("known_good_batch_report_text: \n#{known_good_batch_report_text}")
  raise "failed to generate batch report text" unless batch_text.string == known_good_batch_report_text

  # generates output file
  test_report_batch.generate_output_file(filename: 'output_test.txt')
  raise "failed to create output file" unless File.exist? 'output/output_test.txt'
  # cleanup
  File.delete('output/output_test.txt')

  puts "unit tests passed."
end
