every every :day, :at => '11:59pm' do
  Rails.application.config.request_queue.reset
end
