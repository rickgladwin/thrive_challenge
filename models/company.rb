# frozen_string_literal: true
require 'json'
require_relative 'user'

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

    all_companies           = []
    companies_data_filepath = '../data/companies.json'
    companies_file          = File.read(File.expand_path(companies_data_filepath, File.dirname(__FILE__)))
    begin
      companies_data = JSON.parse(companies_file)
    rescue JSON::ParserError => e
      raise "Error while parsing #{companies_data_filepath}. Check the file for valid json format. Error: #{e}"
    end

    companies_data.each do |company_data|
      raise "Invalid company data: #{company_data}" unless validate_company_data(company_data)
      new_company = Company.new(
        id:           company_data['id'],
        name:         company_data['name'],
        top_up:       company_data['top_up'],
        email_status: company_data['email_status'],
      )
      all_companies << new_company
    end
    # order companies by id
    all_companies.sort_by! { |company| company.id }
    all_companies
  end

  def users
    # retrieve all users with this company_id
    all_users           = []
    users_data_filepath = '../data/users.json'
    users_file          = File.read(File.expand_path(users_data_filepath, File.dirname(__FILE__)))
    begin
      users_data = JSON.parse(users_file)
    rescue JSON::ParserError => e
      raise "Error while parsing #{users_data_filepath}. Check the file for valid json format. Error: #{e}"
    end
    # users_data = JSON.parse(users_file)
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
    active_users        = []
    users_data_filepath = '../data/users.json'
    users_file          = File.read(File.expand_path(users_data_filepath, File.dirname(__FILE__)))
    begin
      users_data = JSON.parse(users_file)
    rescue JSON::ParserError => e
      raise "Error while parsing #{users_data_filepath}. Check the file for valid json format. Error: #{e}"
    end

    users_data.each do |user_data|
      raise "Invalid user data: #{user_data}" unless validate_user_data(user_data)
      next if user_data['company_id'] != @id or user_data['active_status'] != true
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

  def self.validate_company_data(company_data)
    # expect a hash with all values required and correctly typed
    return false unless company_data.is_a?(Hash)
    expected_keys_and_types = {
      "id":            Integer,
      "name":    String,
      "top_up":     Integer,
      "email_status":         'bool',
    }
    return false unless company_data.length == expected_keys_and_types.length
    expected_keys_and_types.each do |expected_key, expected_value|
      # puts("key: #{company_data.keys}")
      # puts("key: #{expected_key}")
      return false unless company_data.key?(expected_key.to_s)
      if expected_keys_and_types[expected_key] == 'bool'
        return false unless [true, false].include? company_data[expected_key.to_s]
      else
        # puts "company_data class: #{company_data[expected_key.to_s].class}"
        # puts "expected_value: #{expected_value}"
        return false unless company_data[expected_key.to_s].class == expected_value
      end
    end
    true
  end

  def validate_user_data(user_data)
    # expect a hash with all values required and correctly typed
    return false unless user_data.is_a?(Hash)
    expected_keys_and_types = {
      "id":            Integer,
      "first_name":    String,
      "last_name":     String,
      "email":         String,
      "company_id":    Integer,
      "email_status":  'bool',
      "active_status": 'bool',
      "tokens":        Integer,
    }
    return false unless user_data.length == expected_keys_and_types.length
    expected_keys_and_types.each do |expected_key, expected_value|
      # puts("key: #{user_data.keys}")
      # puts("key: #{expected_key}")
      return false unless user_data.key?(expected_key.to_s)
      if expected_keys_and_types[expected_key] == 'bool'
        return false unless [true, false].include? user_data[expected_key.to_s]
      else
        # puts "user_data class: #{user_data[expected_key.to_s].class}"
        # puts "expected_value: #{expected_value}"
        return false unless user_data[expected_key.to_s].class == expected_value
      end
    end
    true
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

  # validates valid user data hash
  test_user_data =
    {
      "id"            => 1,
      "first_name"    => "Tanya",
      "last_name"     => "Nichols",
      "email"         => "tanya.nichols@test.com",
      "company_id"    => 1,
      "email_status"  => true,
      "active_status" => false,
      "tokens"        => 23,
    }
  raise "failed to validate valid user data" unless test_company.validate_user_data(test_user_data)

end