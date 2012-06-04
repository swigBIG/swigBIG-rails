# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Swprototype::Application.initialize!

Geokit::Geocoders::request_timeout = 10
