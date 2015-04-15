class CurrencyWorker
  include Sneakers::Worker

  from_queue "currencies.queue_#{ENV['QUEUE_ID']}"

  def work(message)
    message = JSON.parse(message)
    currency = Currency.new(uuid: message['uuid'], rates: message['rates'])

    if currency.save
      ack!
    else
      requeue_or_reject
    end
  end

  private

  def requeue_or_reject
    if !@countdown
      @countdown = 5
      requeue!
    elsif @countdown > 0
      @countdown -= 1
      requeue!
    else
      reject!
    end
  end
end
