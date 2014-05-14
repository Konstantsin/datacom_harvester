every 30.minutes do
  rake "sugar_crm:update", output: { error: 'sugar_crm_update_error.log', standard: 'sugar_crm_update_cron.log' }
end
