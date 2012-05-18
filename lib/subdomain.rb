class Subdomain
  def self.matches?(request)
    case request.host.split(/\./).first
    when 'www', '', nil, 'syafik-aink', 'swigbig', 'swigbig.com', 'angga-dra', 'http://www'
      false
    else
      true
    end
  end
end