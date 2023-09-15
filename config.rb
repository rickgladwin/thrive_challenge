# Global config
# Accessible from any file
# Can be used to set global variables in main/entrypoint file

module Config
  def self.default_from_email = 'test@example.com'

  def self.fake_email_sendout = true

  def self.run_file_level_unit_tests = true
end
