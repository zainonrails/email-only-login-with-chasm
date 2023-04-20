require 'uri'
require 'net/http'
class MagicLinkCreator
  def call(email)
    url = URI("http://api.lvh.me:3001/v1/links")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = false

    request = Net::HTTP::Post.new(url)
    form_data = [['to', email],['api_key', ENV['CHASM_API_KEY']]]
    request.set_form form_data, 'multipart/form-data'
    response = https.request(request)
    response.read_body
  end
end
