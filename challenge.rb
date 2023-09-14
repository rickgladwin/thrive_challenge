# frozen_string_literal: true

# Main file for running data processing, emailing, and reporting

# Procedure
# create company objects
# TODO: create company objects
# create batch report
# for each company
#   create company report element
#   get company active users
#   for each active user
#     update user token balance
#     optionally email user
#     update company report element
#   add company report element to batch report
# present batch report (as output.txt)


if __FILE__ == $0
  puts('--  Company Users Token Updater   --')
  puts('   (press any key to begin batch)')
  gets
  puts('done.')
  puts('Output file is available at: output/output.txt')
end
