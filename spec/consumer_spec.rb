require 'pact/message/consumer/rspec'
require 'support/pact_spec_helper.rb'

require_relative '../app/consumers/test_message_consumer.rb'

describe TestMessageConsumer do
  let(:expected_payload_1) {
    {
      "first_name": "John",
      "last_name": "Doe"
    }
  }
  let(:expected_payload_2) {
    {
      "hello": "world"
    }
  }
  let(:consumer) { described_class.new }

  describe "Test Message Consumer", pact: :message do
    it "generates contract" do
      test_message_producer
        .given("Class1")
        .is_expected_to_send("created")
        .with_content(expected_payload_1)
      test_message_producer.send_message_string do |content_string|
        expect(consumer.consume_message(content_string)).to eq(expected_payload_1.to_json)
      end

      test_message_producer
        .given("Class2")
        .is_expected_to_send("updated")
        .with_content(expected_payload_2)
      test_message_producer.send_message_string do |content_string|
        expect(consumer.consume_message(content_string)).to eq(expected_payload_2.to_json)
      end
    end
  end
end
