worker_processes (ENV['N'] || 1).to_i
listen 3000, tcp_nopush: false
