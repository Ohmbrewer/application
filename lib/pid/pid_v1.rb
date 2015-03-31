#initial PID algorithm
# original code taken from http://brettbeauregard.com/blog/2011/04/improving-the-beginners-pid-direction/

#converted to ruby from ~c

class PidV1
  # /*working variables*/
  # unsigned long lastTime
  # double Input, Output, Setpoint
  # double ITerm, lastInput
  # double kp, ki, kd
  # int SampleTime = 1000 #//1 sec
  # double outMin, outMax
  # bool inAuto = false

  attr_accessor :controllerDirection, :lastTime, :Input, :Output, :Setpoint, :lastInput, :Iterm, :kp, :ki, :kd, :SampleTime, :outMin, :outMax, :inAuto

  define MANUAL = 0
  define AUTOMATIC = 1

  define DIRECT = 0
  define REVERSE = 1
  def initialize
    @controllerDirection = DIRECT
    @lastTime, @Input, @Output, @Setpoint, @lastInput, @ITerm, @kp, @ki, @kd, @outMax, @outMin = 0
    @inAuto = false
    @SampleTime = 1000 #1 second

  end


      def Compute

          if(!@inAuto)
            return
          end
              now = millis()
              timeChange = (now - @lastTime)
          if(timeChange>=@SampleTime)
              # /*Compute all the working error variables*/
              error = @Setpoint - @Input
              @ITerm += (@ki * error)
          end
          if(@ITerm > @outMax)
              @ITerm = @outMax

          else if(@ITerm < @outMin)
              @ITerm = @outMin

              dInput = (@Input - @lastInput)
          end
          # /*Compute PID Output*/
          @Output = @kp * error + @ITerm- kd * dInput
          if(@Output > @outMax)
              @Output = @outMax
          else if(@Output < @outMin)
              @Output = @outMin
              # /*Remember some variables for next time*/
              @lastInput = @Input
              @lastTime = now
          end
      end

      def SetTunings( k_p,  k_i,  k_d)

          if k_p<0 || k_i<0|| k_d<0
            return
          end

              sampleTimeInSec = (@SampleTime)/1000
              @kp = k_p
              @ki = k_i * sampleTimeInSec
              @kd = k_d / sampleTimeInSec
          end
          if @controllerDirection ==REVERSE
              @kp = (0 - @kp)
              @ki = (0 - @ki)
              @kd = (0 - @kd)
          end
      end

      def SetSampleTime( newSampleTime)

          if (newSampleTime > 0)
             ratio = newSampleTime / @SampleTime
              @ki *= ratio
              @kd /= ratio
              @SampleTime = newSampleTime
          end
      end

      def SetOutputLimits( min, max)

          if(min > max)
            return
          end
              @outMin = min
              @outMax = max
          end

          if(@Output > @outMax)
              @Output = @outMax

          else if(@Output < @outMin)
                 @Output = @outMin

          end

          if(@ITerm > @outMax)
              @ITerm= @outMax

          else if(@ITerm < @outMin)
              @ITerm= @outMin


          end

      def SetMode(mode)

          newAuto = (mode == AUTOMATIC);
          if(newAuto == !inAuto)
              # /*we just went from manual to auto*/
              self.InitializeAuto
          end
              @inAuto = newAuto
      end

      def InitializeAuto

          @lastInput = @Input
          @ITerm = @Output

          if(@ITerm > @outMax)
              @ITerm= @outMax

          else if(@ITerm < @outMin)
              @ITerm= @outMin

          end
      end

      def SetControllerDirection( direction)

          @controllerDirection = direction
      end
end