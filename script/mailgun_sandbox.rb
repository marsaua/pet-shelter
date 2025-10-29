require "rest-client"
require "base64"

API_KEY   = ENV.fetch("MAILGUN_API_KEY")
DOMAIN    = ENV.fetch("MAILGUN_SANDBOX_DOMAIN")
TO_EMAIL  = ENV.fetch("TO_EMAIL")

def send_mail_to_sandbox(message)
  RestClient.post(
    "https://api.mailgun.net/v3/#{DOMAIN}/messages",
    {
      from: "Mailgun Sandbox <postmaster@#{DOMAIN}>",
      to:   TO_EMAIL,
      subject: "Hello from Mailgun Sandbox",
      text: "#{message}"
    },
    { Authorization: "Basic #{Base64.strict_encode64("api:#{API_KEY}")}" }
  )
end
