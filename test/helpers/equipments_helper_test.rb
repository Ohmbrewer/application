require 'test_helper'

class EquipmentsHelperTest < ActionView::TestCase
  def setup; end

  test 'produces equipment path' do
    equipment = equipments(:single_pump)
    assert_equal "/pumps/#{equipment.id}".encode('US-ASCII'),
                 sti_equipment_type_path(equipment.type, equipment)
  end

  test 'shows title add message' do
    rhizome = rhizomes(:zeus)
    assert_equal 'to Zeus', rhizome_title_reference(rhizome, :add)
  end

  test 'shows title edit message' do
    rhizome = rhizomes(:zeus)
    assert_equal 'on Zeus', rhizome_title_reference(rhizome, :edit)
  end

  test 'shows empty equipment pin list' do
    equipment = equipments(:no_pins_pump)
    assert_equal '<ul><li>Not Set</li></ul>', pins_list(equipment)
  end
end
