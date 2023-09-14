# frozen_string_literal: true

# Main file for running data processing, emailing, and reporting

# Procedure
# create company objects
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
