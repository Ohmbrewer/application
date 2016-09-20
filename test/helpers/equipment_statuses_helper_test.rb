require 'test_helper'

class EquipmentStatusesHelperTest < ActionView::TestCase
  def setup; end

  test 'shows on label text' do
    status = equipment_statuses(:no_rims_therm_sensor_on)
    assert_equal 'ON', status_indicator_label_text(status)
  end

  test 'shows off label text' do
    status = equipment_statuses(:no_rims_therm_sensor_off)
    assert_equal 'OFF', status_indicator_label_text(status)
  end

  test 'shows default label text when nil' do
    assert_equal 'NO DATA', status_indicator_label_text(nil)
  end

  test 'shows default label text when unknown' do
    status = equipment_statuses(:no_rims_therm_sensor_off)
    status.state = :unknown
    assert_equal 'NO DATA', status_indicator_label_text(status)
  end

  test 'shows on label CSS class' do
    status = equipment_statuses(:no_rims_therm_sensor_on)
    assert_equal 'success', status_indicator_label_type(status)
  end

  test 'shows off label CSS class' do
    status = equipment_statuses(:no_rims_therm_sensor_off)
    assert_equal 'danger', status_indicator_label_type(status)
  end

  test 'shows default label CSS class when nil' do
    assert_equal 'default', status_indicator_label_type(nil)
  end

  test 'shows default label CSS class when unknown' do
    status = equipment_statuses(:no_rims_therm_sensor_off)
    status.state = :unknown
    assert_equal 'default', status_indicator_label_type(status)
  end
end
