class CurrencyWorker
  include Sneakers::Worker

  id = ENV['QUEUE_ID']
  from_queue "currencies.queue_#{id}"

  def work(message)
    message = JSON.parse(message)
    currency = Currency.new(uuid: message['uuid'], rates: message['rates'])

    if currency.save
      Publisher.publish(id: id, uuid: message['uuid'])
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
