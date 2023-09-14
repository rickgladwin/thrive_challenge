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
    end
  end

  class BatchCompanyUsersTokenUpdate
    attr_accessor :company_updates

    def initialize
      @company_updates = []
    end
  end

  def generate_user_token_update_report

  end
end
