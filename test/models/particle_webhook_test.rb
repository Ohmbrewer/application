require 'test_helper'

class ParticleWebhookTest < ActiveSupport::TestCase
  def setup
    @rhizome = rhizomes(:northern_brewer)
  end

  test 'should be valid' do
    particle_webhook = ParticleWebhook.new rhizome: @rhizome,
                                           endpoint: 'https://test.com',
                                           event_type: :temp,
                                           event_id: '1'
    assert particle_webhook.valid?
  end

  test 'should generate task hash' do
    particle_webhook = ParticleWebhook.new rhizome: @rhizome,
                                           endpoint: 'https://test.com',
                                           event_type: :temp,
                                           event_id: '1'
    expected_hash = {
      mydevices: true,
      deviceid: @rhizome.particle_device.device_id,
      event: 'temp/1',
      url: 'https://test.com/hooks/v1/temp',
      json: ParticleWebhook::temperature_sensor_task_json
    }
    assert particle_webhook.to_task_hash, expected_hash
  end

  test 'should throw ArgumentError if bad type' do
    bad_type = :fart
    assert_raise ArgumentError,
                 "Supplied Event Type (#{bad_type}) is not a known type." <<
                 "Available options: #{ParticleWebhook::EVENT_TYPES}" do
      particle_webhook = ParticleWebhook.new rhizome: rhizomes(:northern_brewer).id,
                                             endpoint: 'https://test.com',
                                             event_type: bad_type,
                                             event_id: '1'
      assert_not particle_webhook.valid?
    end
  end
end
