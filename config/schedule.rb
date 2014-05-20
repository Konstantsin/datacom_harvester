every 30.minutes do
  rake "sugar_crm:update", output: { error: 'log/sugar_crm_update_error.log', standard: 'log/sugar_crm_update_cron.log' }
end
