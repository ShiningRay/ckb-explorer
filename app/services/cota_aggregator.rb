class CotaAggregator
  class Error < StandardError
    attr_reader :code, :message, :data

    def initialize(code, message, data)
      @code = code
      @message = message
      @data = data
    end
  end
  include Singleton
  attr_accessor :url

  def initialize(url = ENV["COTA_AGGREGATOR_URL"])
    @url = url
    @req_id = 0
  end

  def get_history_transactions(cota_id:, token_index:, page: nil, page_size: nil)
    send_request "get_history_transactions", {
      cota_id: cota_id,
      token_index: "0x" + token_index.to_s(16),
      page: page || '1',
      page_size: page_size || '20'
    }
  end

  def get_issuer_info(lock_script)
    send_request "get_issuer_info", {
      lock_script: lock_script
    }
  end

  def get_define_info(cota_id)
    send_request "get_define_info", {
      cota_id: cota_id
    }
  end

  def get_hold_cota_nft(lock_script:, cota_id:, page: nil, page_size: nil)
    send_request "get_hold_cota_nft", {
      lock_script: lock_script,
      cota_id: cota_id,
      page: page || '1',
      page_size: page_size || '20'
    }
  end

  def is_claimed(lock_script:, cota_id:, token_index:)
    send_request "is_claimed", {
      cota_id: cota_id,
      lock_script: lock_script,
      token_index: "0x" + token_index.to_s(16)
    }
  end

  def get_mint_cota_nft(lock_script:, page: nil, page_size: nil)
    send_request "is_claimed", {
      lock_script: lock_script,
      page: page || '1',
      page_size: page_size || '20'
    }
  end

  def get_cota_nft_sender(lock_script:, cota_id:, token_index:)
    send_request "get_cota_nft_sender", {
      cota_id: cota_id,
      lock_script: lock_script,
      token_index: "0x" + token_index.to_s(16)
    }
  end

  def send_request(method, params)
    @req_id += 1
    payload = {
      jsonrpc: "2.0",
      id: @req_id,
      method: method,
      params: params
    }
    res = HTTP.post(url, json: payload)
    data = JSON.parse res.to_s
    if err = data["error"]
      raise Error.new(err["code"], err["message"], err["data"])
    else
      return data["result"]
    end
  end
end
