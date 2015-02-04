# Set the working application directory
#working_directory "/home/kaede/service/happy-birtyday-waifu/"

# Unicorn PID file location
pid "/home/kaede/service/happy-birthday-waifu/pids/unicorn.pid"

# Path to logs
stderr_path "/home/kaede/service/happy-birthday-waifu/log/unicorn.log"
stdout_path "/home/kaede/service/happy-birthday-waifu/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.myapp.sock"

# Number of processes
worker_processes 4

# Time-out
timeout 30

listen 4000
