ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: "587",
  domain: "swigbig.com",
  user_name: "Swigbiginfo@gmail.com",
  password: '',
  authentication: :plain,
  enable_starttls_auto: true
}

ActionMailer::Base.default_url_options[:host] = "swigbig.com"