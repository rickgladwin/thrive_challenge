# frozen_string_literal: true
require_relative 'User'
require 'json'

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
    users_file = File.read(File.expand_path('../data/users.json', File.dirname(__FILE__)))
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
    # order users by last name
    all_users.sort! { |a, b| a.last_name <=> b.last_name }
    all_users
  end

  def active_users
    # retrieve all active users with this company_id
    active_users = []
    users_file   = File.read(File.expand_path('../data/users.json', File.dirname(__FILE__)))
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
    # order users by last name
    active_users.sort! { |a, b| a.last_name <=> b.last_name }
    active_users
  end
end

if __FILE__ == $0
  test_company              = Company.new(1, "Test Corp", 12, true)
  test_company_active_users = test_company.active_users
  test_company_users        = test_company.users
  puts "test_company_active_users: #{test_company_active_users}"
  puts "size: #{test_company_active_users.size}"
  puts "test_company_users: #{test_company_users}"
  puts "size: #{test_company_users.size}"
end