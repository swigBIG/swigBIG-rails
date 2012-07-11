CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJA24JJUKFLQDIC5Q',
    :aws_secret_access_key  => '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',
  }
  config.fog_directory  = 'swigbig'
  config.fog_public     = false
end 
