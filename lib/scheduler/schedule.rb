
#impliment a structure for holding a brew day schedule,

# expression: "reference" subject --do something-- for *duration*. $tag$

#Schedule is the actual structured list of events.

class Schedule

  attr_accessor :schedule, :length, :front, :back

  def initialize (opts = {})
    @front=null
    @back=null
    @length=0
  end

  def addEvent(subject, action, spec, duration)
    e = new ScheduleEvent( subject: subject, action: action, specification: spec,
        duration: duration)
    self.enqueue(e)
  end

  def enqueue(event)
    if (@front==null)
      @front=event
      @back=event
    else
      @back.next=event
      @back=event
    end
    @length=@length+1
  end

  def dequeue()
    if (length==0)
      e = null
    else
      e=@front
      @front=e.next
    end
    @length=@length-1
    return e
  end

end