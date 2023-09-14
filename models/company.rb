# frozen_string_literal: true

class Company
  def initialize(id, name, top_up, email_status)
    @id           = id
    @name         = name
    @top_up       = top_up
    @email_status = email_status
  end

  def users
    # retrieve all users with this company_id
    all_users  = []
    users_file = File.read('../data/users.json')
    users_data = JSON.parse(users_file)
    users_data.each { |user_data|
      next if user_data['company_id'] != @id
      new_user = User.new(
        user_data['id'],
        user_data['first_name'],
        user_data['last_name'],
        user_data['email'],
        user_data['company_id'],
        user_data['email_status'],
        user_data['active_status'],
        user_data['tokens']
      )
      all_users << new_user
    }
    all_users
  end

  def active_users
    # retrieve all active users with this company_id
    active_users = []
    users_file   = File.read('../data/users.json')
    users_data   = JSON.parse(users_file)
    users_data.each { |user_data|
      next if user_data['company_id'] != @id or user_data['active_status'] == false
      new_user = User.new(
        user_data['id'],
        user_data['first_name'],
        user_data['last_name'],
        user_data['email'],
        user_data['company_id'],
        user_data['email_status'],
        user_data['active_status'],
        user_data['tokens']
      )
      active_users << new_user
    }
    active_users
  end
end
