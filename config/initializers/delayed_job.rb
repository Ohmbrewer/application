# Options
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_run_time = 5.hour # We'll want to bump this up when we're ready to run longer processes (e.g. fermentation)
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))