# Global config
# Accessible from any file
# Can be used to set global variables in main/entrypoint file

module Config
  def default_from_email = 'test@example.com'
  def fake_email_sendout = true
end
