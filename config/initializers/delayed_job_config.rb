Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay         = 60
Delayed::Worker.max_run_time        = 2.hours
Delayed::Worker.read_ahead          = 10
Delayed::Worker.delay_jobs          = !Rails.env.test?
Delayed::Worker.max_attempts        = 1
