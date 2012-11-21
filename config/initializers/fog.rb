CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => '',
    :aws_access_key_id      => '',
    :aws_secret_access_key  => '',
  }
  config.fog_directory  = 'swigbig'
  config.fog_public     = false
end 
