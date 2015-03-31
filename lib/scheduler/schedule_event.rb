
# reference - reference of a tag, can be modified. exm.A+30
# subject - the device/equipment being acted apon
# duration - length of time that the event occurs, could be amount of liquid for a pump
# tag - linking element to signify that somethign may happen out of order
# do something - is the event type, (heat/pump/etc) (exm. heat to 145 deg)

# expression: "reference" subject --do something-- for *duration*. $tag$

class ScheduleEvent
  #also acts as a node in a linked list

  attr_accessor :subject, :reference, :duration, :tag, :action, :specification, :next_event

  def initialize (opts = {})
    #tags are omitted for now
    @subject=opts[subject]
    @action=opts[action]
    @specification=opts[specification]
    @duration=opts[duration]
  end




end