require "twilio-ruby"

module Api
  module V1  
    class BasicCallController < ApplicationController
      # respond_to :json
      respond_to :xml
      
      def index
        numberToCall = params[:PhoneNumber]
        
        cert = File.read(File.join(Rails.root, 'config', 'ck.pem'))
        ctx = OpenSSL::SSL::SSLContext.new
        ctx.key = OpenSSL::PKey::RSA.new(cert, 'WhoaPhone') #set passphrase here, if any
        ctx.cert = OpenSSL::X509::Certificate.new(cert)
 
        sock = TCPSocket.new('gateway.sandbox.push.apple.com', 2195) #development gateway
        ssl = OpenSSL::SSL::SSLSocket.new(sock, ctx)
        ssl.connect
  
        payload = {"aps" => {"alert" => "Oh hai!", "badge" => 1, "sound" => 'default'}}
        json = payload.to_json()
        device = Device.find_by_ph_num(numberToCall)
        token = device.token
        token =  [token.delete(' ')].pack('H*') #something like 2c0cad 01d1465 346786a9 3a07613f2 b03f0b94b6 8dde3993 d9017224 ad068d36
        apnsMessage = "\0\0 #{token}\0#{json.length.chr}#{json}"
        ssl.write(apnsMessage)
  
        ssl.close
        sock.close
        
        @response = Twilio::TwiML::Response.new do |r|
          r.Dial :callerId => '16318136374' do |d|
            d.Client numberToCall
          end
        end
        # response.accept = 'application/xml'
        respond_with (@response.text) do |format|
          format.xml {render :xml => @response.text}
        end
      end
    end
  end
end