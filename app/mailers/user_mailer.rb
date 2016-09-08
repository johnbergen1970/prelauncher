class UserMailer < ActionMailer::Base
  include SendGrid

  default from: "\"Train Together\" <charles@traintogether.co>"
  layout 'mailer'

  def sign_up_email(user)
    send_grid_email(
      subject: "Thanks for signing up!",
      content: "Test",
      user: user,
      template_id: 'ce8b1118-d3a8-4a67-9acb-655633194d8a'
    )
  end

  def referral_email(user)
    send_grid_email(
      subject: "You've got some referral!",
      content: "Test",
      user: user,
      template_id: 'c05ba3f3-94f1-410f-8495-98fd9562970e'
    )
  end

  private

  def send_grid_email(subject:, content:, user:, template_id:)
    mail = Mail.new
    mail.from = Email.new(email: '\"Train Together\" <charles@traintogether.co>')
    mail.subject = subject
    personalization = Personalization.new
    personalization.to = Email.new(email: user.email)
    personalization.substitutions = Substitution.new(key: '-user-home-url-', value: user.user_url(root_url))
    personalization.substitutions = Substitution.new(key: '-root-url-', value: root_url)
    mail.personalizations = personalization
    mail.contents = Content.new(type: 'text/html', value: 'test')
    mail.template_id = template_id

    sg = SendGrid::API.new(api_key: Rails.application.secrets.sendgrid_api_key)
    response = sg.client.mail._("send").post(request_body: mail.to_json)
  end
end
