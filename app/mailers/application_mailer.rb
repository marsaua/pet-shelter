class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILGUN_FROM", ENV.fetch("MAILGUN_FROM_DEV", "no-reply@example.com"))
  layout "mailer"
end
