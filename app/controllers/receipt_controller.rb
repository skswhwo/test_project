class ReceiptController < ApplicationController

  def index

    render json: "test"
  end

  def show
    head :ok
  end

  def create
    data = params[:receipt]
    password = ENV['IAP_PPASSWORD']
    params_json = "{ \"receipt-data\": \"#{data}\",\"password\":\"#{password}\"  }"
    uri = URI("https://sandbox.itunes.apple.com") # Use "https://buy.itunes.apple.com" for production
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      response = http.post('/verifyReceipt', params_json)
      # Puts the result! (see an example below - result.json)
      render json: response.body, status: :ok
    end

#    if data != nil
#      receipt = Venice::Receipt.verify(data)
#      render text: receipt, status: :ok
#    else
#      render text: "no", status: :ok
#    end
  end

  def delete

    head :ok
  end
end
