class WorkQueue

  def self.worker(num, &block)
    work_queue = self.new
    block.call(work_queue)
    work_queue.work(num)
  end

  def initialize
    @queue = Queue.new
  end

  def create(&block)
    @queue << block
  end

  def work(num)
    threads = (1..num).map do
      Thread.new do
        while !@queue.empty?
          begin
            @queue.pop(true).call()
          rescue ThreadError
          end
        end
      end
    end
    threads.each { |thread| thread.join }
  end

end
