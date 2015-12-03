class Sprout < ActiveRecord::Base

  belongs_to :sproutable, polymorphic: true, dependent: :destroy
  belongs_to :equipment_profile

  def sproutable_type=(klass)
    super(klass.to_s.classify.constantize.base_class.to_s)
  end

end