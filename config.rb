# Global config
# Accessible from any file
# Can be used to set global variables in main/entrypoint file

module Config
  def self.default_from_email = 'test@example.com'

  def self.fake_email_sendout = true
end
