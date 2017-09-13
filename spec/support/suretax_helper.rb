module SuretaxSpecHelper
  def suretax_key
    ENV["SURETAX_VALIDATION_KEY"]
  end

  def suretax_url
    Suretax.configuration.base_url
  end

  def suretax_client_number
    ENV["SURETAX_CLIENT_NUMBER"]
  end

  def suretax_post_path
    Suretax.configuration.request_path
  end

  def suretax_cancel_path
    Suretax.configuration.cancel_path
  end

  def suretax_wrap_response(json_string)
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<string xmlns=\"http://tempuri.org/\">" + json_string + "</string>"
  end
end
