# frozen_string_literal: true

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
  end

  class BatchCompanyUsersTokenUpdate
    attr_accessor :company_updates

    def initialize
      @company_updates = []
    end

    def add(company_report)
      @company_updates << company_report
    end
  end

  def generate_user_token_update_report
    # TODO: build output file from batch report object
  end
end
