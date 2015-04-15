require 'rails_helper'

MESSAGE = {
  uuid: "some-randomly-generated-uuid",
  rates: {
    "AUD": 1.22,
    "PLN": 0.33
  }
}.to_json

describe Publisher do
  describe '.publish' do
    before do
      allow(Publisher).to receive(:message) { MESSAGE }
      Publisher.publish
    end

    it 'returns an object of a Bunny class' do
      expect(Publisher.publish).to be_instance_of(Bunny::Exchange)
    end
  end
end
