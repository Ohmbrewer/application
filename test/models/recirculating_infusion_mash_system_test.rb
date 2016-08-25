require 'test_helper'

class RecirculatingInfusionMashSystemTest < ActiveSupport::TestCase
  def setup
    @good_rims = recirculating_infusion_mash_systems(:good_rims)
  end

  test 'should recognize no rhizome attached' do
    assert @good_rims.rhizome.nil?
  end
end
