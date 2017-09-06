module CancellationSpecHelper
  def cancel_response_body
    {
      "Successful" => "Y",
      "ResponseCode" => "9999",
      "HeaderMessage" => "Success",
      "ClientTracking" => "test",
      "TransId" => 0
    }
  end

  def cancel_request_body
    {
      "ClientNumber" => suretax_client_number,
      "ClientTracking" => "test",
      "TransId" => "999",
      "ValidationKey" => suretax_key
    }
  end

  def cancel_failed_response_body
    {
      "Successful" => "N",
      "ResponseCode" => nil,
      "HeaderMessage" => nil,
      "ClientTracking" => nil,
      "TransId" => 0
    }
  end
end
