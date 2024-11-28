# System Monitoring Commands Reference

## Process and System Monitoring Tools

### htop
A real-time process monitoring tool that provides an enhanced and interactive version of top.
```bash
htop                           # Launch interactive process viewer
```
- Shows CPU, memory, and swap usage with visual bars
- Interactive process management (kill, nice, etc.)
- Supports process tree view and filtering
- Customizable columns and colors
- Common keys: F5 (tree view), F6 (sort), F9 (kill), F10 (quit)

### iotop
Monitors I/O usage by processes in real-time.
```bash
iotop                         # Show I/O usage by all processes
iotop -o                      # Show only processes with I/O activity
iotop -b                      # Non-interactive mode (good for logging)
```
- Displays read/write bandwidth per process
- Shows I/O wait percentage
- Helpful for identifying disk I/O bottlenecks
- Requires root privileges

### vmstat (Virtual Memory Statistics)
Reports virtual memory statistics, process stats, and system activity.
```bash
vmstat [interval] [count]      # Example: vmstat 1 5
vmstat -s                      # Memory stats summary
vmstat -d                      # Disk statistics
```
Sample output fields:
- r: Number of processes waiting for CPU
- free: Free memory in KB
- si/so: Swap in/out
- bi/bo: Blocks in/out (disk I/O)
- us/sy: User/system CPU time

### iostat (Input/Output Statistics)
Reports CPU and I/O statistics for devices and partitions.
```bash
iostat -x 1                    # Extended stats every second
iostat -d                      # Only disk statistics
iostat -p ALL                  # Statistics for all partitions
```
Key metrics:
- %util: Device utilization
- r/w per second
- Average queue length
- Average service time

### dstat
Versatile replacement for vmstat, iostat, netstat, and ifstat.
```bash
dstat                         # Show all stats
dstat -taf                    # Time, CPU, disk, sys, net, mem
dstat --top-cpu              # Show top CPU processes
```
Features:
- Combines multiple system statistics
- Colorized output
- Real-time counters
- Plugins support for extra metrics

### pidstat
Reports statistics for Linux processes.
```bash
pidstat 1                     # Process stats every second
pidstat -d                    # I/O statistics
pidstat -r                    # Memory statistics
pidstat -u                    # CPU statistics
```
Useful for:
- Per-process CPU utilization
- Per-process memory usage
- Per-process I/O activity
- Thread activity monitoring

### netstat
Network connection and routing table monitor.
```bash
netstat -tulpn               # TCP/UDP listening ports
netstat -anp                 # All connections with PIDs
netstat -r                   # Routing table
netstat -i                   # Network interface statistics
```
Common options:
- -t: TCP connections
- -u: UDP connections
- -l: Listening sockets
- -p: Show process name/PID
- -n: Show numerical addresses

### Additional Network Monitoring Tools

#### ss (Socket Statistics)
Modern replacement for netstat.
```bash
ss -tunlp                    # TCP/UDP listening ports
ss -i                        # Show internal TCP information
```
Benefits:
- Faster than netstat
- More detailed socket information
- Better performance with many connections

#### iftop
Displays bandwidth usage per connection.
```bash
iftop -n                     # Don't resolve hostnames
iftop -P                     # Show ports
```
Features:
- Real-time bandwidth monitoring
- Per-host connection stats
- Cumulative bandwidth usage

### System Resource Monitoring Tips

1. Regular Monitoring:
```bash
# Basic system health check
watch -n 1 'ps aux | sort -rk 3,3 | head -n 5'  # Top 5 CPU consuming processes
watch -n 1 'free -m'                            # Memory usage update every second
```

2. Combined Monitoring:
```bash
# Monitor multiple aspects simultaneously
tmux new-session \
    'htop' \; split-window -h \
    'iotop' \; split-window -v \
    'watch -n 1 netstat -tulpn'
```

3. Logging System Statistics:
```bash
# Log system statistics to file
sar 1 3600 > system_stats.log     # Collect system activity for 1 hour
iostat -tdx 1 > io_stats.log      # Log detailed I/O statistics
```

These tools together provide a comprehensive view of system performance and can help identify:
- Performance bottlenecks
- Resource constraints
- Process misbehavior
- Network issues
- I/O problems
- Memory leaks

Remember to:
- Use appropriate privileges (many tools require root access)
- Consider the overhead of monitoring tools themselves
- Combine multiple tools for complete system analysis
- Save outputs for trend analysis when needed
