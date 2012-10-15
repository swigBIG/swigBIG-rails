#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.gmail.com",
#  :port                 => 587,
#  :domain               => "swigbig.com",
#  :user_name            => "dummy@41studio.com",
#  :password             => "ssstsecret",
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: "587",
  domain: "swigbig.com",
  user_name: "test-do-not-reply@41studio.com",
  password: 'Fd5(q"T,Q-Ov4[C',
  authentication: :plain,
  enable_starttls_auto: true
}


ActionMailer::Base.default_url_options[:host] = "swigbig.com"