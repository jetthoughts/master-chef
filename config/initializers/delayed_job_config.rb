Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay         = 60
Delayed::Worker.max_run_time        = 5.minutes
Delayed::Worker.read_ahead          = 10
Delayed::Worker.delay_jobs          = !Rails.env.test?

# In production have default number of attempts ( which I think is 30 )
if !Rails.env.production?
  Delayed::Worker.max_attempts        = 3
end
