class Publisher
  def self.publish(message)
    x = channel.direct("currencies.direct", routing_key: "acknowledgements")
    x.publish(message.to_json)
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
end
