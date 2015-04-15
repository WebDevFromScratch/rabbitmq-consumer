require 'rails_helper'

RATES = '{
  "EUR": 1.22,
  "PLN": 0.33
}'

describe CurrencyWorker do
  describe '#work' do
    let(:currency_worker) { CurrencyWorker.new }

    context 'when incoming message is valid' do
      let(:message) { { uuid: '123-456', rates: RATES }.to_json }

      it 'returns :ack' do
        currency_worker.work(message)

        expect(currency_worker.work(message)).to eq(:ack)
      end
    end

    context 'when incoming message is invalid' do
      let(:message) { { wrong_arg: 'something' }.to_json }

      context 'and there were no more than 5 requeues' do
        it 'returns :requeue' do
          5.times { currency_worker.work(message) }

          expect(currency_worker.work(message)).to eq(:requeue)
        end
      end

      context 'and there were more than 5 requeues' do
        it 'returns :reject' do
          6.times { currency_worker.work(message) }

          expect(currency_worker.work(message)).to eq(:reject)
        end
      end
    end
  end
end
