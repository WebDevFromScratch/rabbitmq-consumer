class Publisher
  def self.publish
    x = channel.direct("currencies.direct", routing_key: "acknowledgements")
    x.publish(message)
  end

  private

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new.tap do |c|
      c.start
    end
  end

  def self.message
    fetcher_output = Fetcher.fetch_currencies
    { uuid: fetcher_output.uuid, rates: fetcher_output.rates['rates'] }.to_json
  end
end
