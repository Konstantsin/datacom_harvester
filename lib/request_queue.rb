require 'observer'

class RequestQueue
  include Observable
  ITEMS_DAY_LIMIT = 600
  ITEMS_MINUTE_LIMIT = 3

  # one request by API take 4 request to Data.com therefore
  # request period 1.5 minute
  API_REQUEST_PERIOD = 60
  DATACOM_REQUESTS_PER_API_REQUEST = 4

  attr_reader :items_list
  attr_accessor :items_per_today, :items_per_minut, :added_at

  delegate :shift, to: :items_list

  def initialize
    @items_list = []
    @added_at = Time.now
    reset
  end

  def reset
    @items_per_today, @items_per_minut = 0, 0
  end

  def add(item)
    if in_limits_borders?
      items_list << item
      increment_couners
      true
    else
      false
    end
  end

  alias :<< :add

  private

  def in_limits_borders?
    return false if items_per_today >= ITEMS_DAY_LIMIT
    wait_to_second_minute
    true
  end

  def wait_to_second_minute
    num = wait_seconds

    if items_per_minut < ITEMS_MINUTE_LIMIT
      @added_at = Time.now if items_per_minut.zero?
    else
      sleep(num.seconds)
      items_per_minut = 0
    end
  end

  def increment_couners
    @items_per_today += DATACOM_REQUESTS_PER_API_REQUEST
    @items_per_minut += DATACOM_REQUESTS_PER_API_REQUEST
  end

  def wait_seconds
    seconds = (Time.now - @added_at).to_i + 1

    if seconds > API_REQUEST_PERIOD
      @items_per_minut = 0
      seconds % API_REQUEST_PERIOD
    else
      seconds
    end
  end

end
