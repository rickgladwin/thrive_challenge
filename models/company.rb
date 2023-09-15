# frozen_string_literal: true
require_relative 'user'
require 'json'

class Company
  attr_reader :id
  attr_reader :name
  attr_reader :top_up
  attr_reader :email_status

  def initialize(id:, name:, top_up:, email_status:)
    @id           = id
    @name         = name
    @top_up       = top_up
    @email_status = email_status
  end

  def self.all
    all_companies  = []
    companies_file = File.read(File.expand_path('../data/companies.json', File.dirname(__FILE__)))
    companies_data = JSON.parse(companies_file)
    companies_data.each do |company_data|
      new_company = Company.new(
        id:           company_data['id'],
        name:         company_data['name'],
        top_up:       company_data['top_up'],
        email_status: company_data['email_status'],
      )
      all_companies << new_company
    end
    # puts "all_companies: #{all_companies}"
    # order companies by id
    # TODO: handle empty array case
    all_companies.sort_by! { |company| company.id }
    all_companies
  end

  def users
    # retrieve all users with this company_id
    all_users  = []
    users_file = File.read(File.expand_path('../data/users.json', File.dirname(__FILE__)))
    users_data = JSON.parse(users_file)
    users_data.each do |user_data|
      next if user_data['company_id'] != @id
      new_user = User.new(
        id:            user_data['id'],
        first_name:    user_data['first_name'],
        last_name:     user_data['last_name'],
        email:         user_data['email'],
        company_id:    user_data['company_id'],
        email_status:  user_data['email_status'],
        active_status: user_data['active_status'],
        tokens:        user_data['tokens']
      )
      all_users << new_user
    end
    # order users by last name
    all_users.sort! { |a, b| a.last_name <=> b.last_name }
    all_users
  end

  def active_users
    # retrieve all active users with this company_id
    active_users = []
    users_file   = File.read(File.expand_path('../data/users.json', File.dirname(__FILE__)))
    users_data   = JSON.parse(users_file)
    users_data.each do |user_data|
      next if user_data['company_id'] != @id or user_data['active_status'] == false
      new_user = User.new(
        id:            user_data['id'],
        first_name:    user_data['first_name'],
        last_name:     user_data['last_name'],
        email:         user_data['email'],
        company_id:    user_data['company_id'],
        email_status:  user_data['email_status'],
        active_status: user_data['active_status'],
        tokens:        user_data['tokens']
      )
      active_users << new_user
    end
    # order users by last name
    active_users.sort! { |a, b| a.last_name <=> b.last_name }
    active_users
  end
end

if __FILE__ == $0
  test_company              = Company.new(id: 1, name: "Test Corp", top_up: 12, email_status: true)
  test_company_active_users = test_company.active_users
  test_company_users        = test_company.users
  puts "test_company_active_users: #{test_company_active_users}"
  puts "size: #{test_company_active_users.size}"
  puts "test_company_users: #{test_company_users}"
  puts "size: #{test_company_users.size}"

  all_companies = Company.all
  puts "all companies: #{all_companies}"
end