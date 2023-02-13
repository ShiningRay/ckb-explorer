class UpdateTxBytesWorker
  include Sidekiq::Worker
  sidekiq_options queue: "low"

  def perform(tx_id, force=false)
    tx = CkbTransaction.find tx_id
    return if tx.bytes? && !force
    res = CkbSync::Api.instance.directly_single_call_rpc(method: :get_transaction, params: [tx.tx_hash, "0x0"])
    tx.bytes = (res["result"]["transaction"].size - 2) / 2 + 4
    tx.save
  end
end
