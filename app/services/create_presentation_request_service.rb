require 'uri'
require 'net/http'

# Create PresentationAPI Request to Microsoft Entra
# return Base64 of QR code
class CreatePresentationRequestService < BaseService
  def initialize
    @access_token = Oauth2Service.call

    super()
  end

  def call
    uri = URI.parse('https://verifiedid.did.msidentity.com/v1.0/verifiableCredentials/createPresentationRequest')
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    req['Authorization'] = "bearer #{@access_token}"
    req['Content-Type'] = 'application/json'

    data = {
      "includeQRCode": true,
      "callback": {
        "url": 'https://entra-vid-verifier.onrender.com/callback',
        "state": 'Create',
        "headers": {
          "api-key": 'hoge'
        }
      },
      "authority": 'did:web:entra-vid-issuer.onrender.com',
      "registration": {
        "clientName": 'entra_vid_verifier'
      },
      "requestedCredentials": [
        {
          "acceptedIssuers": [
            'did:web:entra-vid-issuer.onrender.com'
          ],
          "purpose": 'fuga',
          "type": 'VerifiedCredentialSampleFeb2023'
        }
      ]
    }.to_json

    req.body = data
    res = http.request(req)

    JSON.parse(res.body)['qrCode']
  end
end
