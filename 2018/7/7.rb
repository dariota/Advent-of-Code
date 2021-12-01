class Worker
  attr_reader :available, :time_left, :task

  def initialize
    @available = true
    @time_left = nil
    @task = nil
  end

  def step_time(time)
    if time_left
      @time_left -= time
      if time_left <= 0
        @time_left = nil
        @available = true
        done_task = task
        @task = nil
      end
      done_task
    else
      nil
    end
  end

  def start_task(task, time)
    @task = task
    @time_left = time
    @available = false
  end
end

def parse(str)
  str.sub("S", "").gsub(/[a-z.]/, "").split(" ")
end

def construct_dependencies(input)
  dependencies = {}
  input.each do |dependency, dependent|
    dependencies[dependency] ||= []
    dependencies[dependent] ||= []
    dependencies[dependent].push(dependency)
  end
  dependencies
end

def solution_1(input)
  work(input, 1) { |_| 0 }.first
end

def solution_2(input)
  work(input, 5) { |char| char.ord - 'A'.ord + 61 }.last
end

def work(input, worker_count, &task_timer)
  workers = (1..worker_count).map { |_| Worker.new }
  order = ""
  time_taken = 0
  # lazy deep dup
  dependencies = Marshal.load(Marshal.dump(input))
  until dependencies.empty? && workers.all?(&:available)
    busy_workers = workers.reject(&:available)
    if busy_workers.any?
      step = busy_workers.min_by(&:time_left).time_left
      time_taken += step
      workers.each do |worker|
        finished_task = worker.step_time(step)
        if finished_task
          order += finished_task
          dependencies.each { |k, v| v.delete(finished_task) }
        end
      end
    end

    workers_available = workers.select(&:available)
    tasks_available = dependencies.select { |k, v| v.empty? }
    next_tasks = tasks_available.sort_by(&:first).map(&:first).first(workers_available.length)
    next_tasks.each do |task|
      worker = workers_available.shift
      worker.start_task(task, yield(task))
      dependencies.delete(task)
    end
  end
  [order, time_taken]
end

input = construct_dependencies(File.new("input").read.chomp.split("\n").map { |str| parse(str) })
puts solution_1(input)
puts solution_2(input)
