class Interactor
  attr_reader :controller
  private :controller

  def initialize(controller)
    @controller = controller
    if helpers_block
      @controller.instance_exec(&helpers_block)
    end
  end

  def perform
    if perform_block.present?
      @result = on_controller(:perform) if on_controller(:condition)
    else
      if respond_to?(:steps) and on_controller(:condition)
        steps_queue = steps.dup
        begin
          step_object = steps_queue.shift.new(controller)
          @result = step_object.perform
        end while steps_queue.present? and !step_object.break_chain?
      end
    end
    @result
  end

  def on_controller(method)
    proc = public_send("#{method}_block")
    if proc
      controller.instance_exec(&proc)
    elsif method == :condition
      true
    elsif respond_to?(:steps)
      perform
    else
      raise "Please provide block for: #{method.to_s} in #{self.class.name}"
    end
  end

  def break_chain?
    !!self.class.breaking
  end

  def condition_block
    self.class.condition_block
  end

  def perform_block
    self.class.perform_block
  end

  def helpers_block
    self.class.helpers_block
  end

  class << self
    attr_accessor :breaking, :perform_block, :condition_block, :helpers_block

    def breaking!
      self.breaking = true
    end

    def helpers(&block)
      self.helpers_block = block
    end

    def perform(&block)
      self.perform_block = block
    end

    def condition(&block)
      self.condition_block = block
    end
  end
end
