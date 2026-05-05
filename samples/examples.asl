# This file contains example ASL statements for testing and demonstration purposes.
For All "cpus" (
    "core_count" >= 72 And "status" = "healthy"
)

---
For All "gpus" (
    "status" = "active" And "temperature" < 85
)

---
For All "gpus" (
    "memory_gb" >= 180
)

---
For All "nvlinks" (
    "status" = "up" And "bandwidth_gbps" >= 900
)

---
For All "power_supplies" (
    "status" = "online"
)

---
For All "fans" (
    "rpm" > 1000 And "status" = "ok"
)

---
For All "nvme_drives" (
    "capacity_tb" >= 3.5 And "status" = "healthy"
)

---
For All "network_cards" (
    "link_speed_gbps" >= 400 And "status" = "up"
)

---
For All "firmware_modules" (
    "version" >= 1
)

---
For All The "firmware_modules" Of "NICs" (
    "version" >= 1
)

---
"severity" = "critical"

---
"Temperature" Is 70
---
"Status" Is "Active"
---
"Users"[1..10] Where "Status" Is "Active" Has Size Of 5
---
"Temperature" Of "Sensor" Of "Node" Is Greater Than 70
---
"Name" Is "Server-01"
---
"Message" Contains "Error"
---
"IB Speed" Is 400
---
"Load" Is At Least 90
---
"Temperature" Is Greater Than 72.5
---
"Status" Is Null
---
"Owner" Is None
---
"IP" Is Empty
---
"Temp" Of "GPU"[0] Is Less Than 80
---
"Firmware" In "OUTPUT" Matches "Major Version 535"
---
"Voltage" Of "Sensors"[1] Of "GPU" Is Less Than 3.2
---
"Interfaces"[0:4] Is "Up"
---
"GPU"[0] Is Compatible With "Driver"
---
"GPU"[0,2,5] Has Size Of 3
---
"Fans" Where "Status" Is "Failed" Has Size Of 0
---
"Processes" Where "Name" Contains "nv" Has Items [123, 456]
---
"Fans" Where "Status" Of "Sensor" Is "Failed" Has Size Of 0
---
"GPU"[0] Of "Cluster" Where "Status" Is "Active" Is Compatible With "Driver"
---
"Interfaces"[1:3] Where "State" Is "Down" Has Items [1, 2]
---
"Architecture" Is "Hopper"
---
"Architecture" = "Hopper"
---
"Link State" Is Not Equal To "Degraded"
---
"Link State" != "Degraded"
---
"Power Draw" Is Less Than 700
---
"VRAM" Is At Least 80000
---
"Temperature" >= 85
---
"Power Draw" < 700
---
"Inlet Temp" Is Between [18, 27]
---
"Latency" Is Between [1-3]
---
"Latency" Is Between [1..3]
---
"Latency" Is Between [1:3]
---
"Latency" Is Between [1.2, 3.5]
---
"Status" Is "Active" And "Speed" Is 400
---
"Status" Is "Active" && "Speed" Is 400
---
"Status" Is "Active" Also "Speed" Is 400
---
"Mode" Is "Auto" Or "Mode" Is "Maximum"
---
"Mode" Is "Auto" || "Mode" Is "Maximum"
---
("Status" Is "Active" Or "Status" Is "Idle") And "Speed" >= 400
---
"A" Is 1 && "B" Is 2 || "C" Is 3
---
"Throttle Reason" Is "None" Unless "Temp" Is Greater Than 85
---
"Link State" Is "Active" Unless "Errors" > 0
---
"Throttle" Is "None" Unless "Temp" > 85 Or "Fan" Is "Failed"
---
"Service" Is "Running" Unless ("CPU" > 90 And "Mode" Is "Auto")
---
"Link" Is "Up" Unless "Errors" > 0 Or "Latency" Is Greater Than 100
---
"Mode" Is "Auto" Unless ("Load" > 80 And "Fan" Is "Failed")
---
"Driver" Is "NVIDIA"
---
"Driver" Includes "NVIDIA"
---
"Driver" Matches Pattern "NVIDIA.*"
---
"Message" Includes "loading Kernel Module"
---
"Log Line" Contains "ERROR"
---
"PCIe Address" Matches Pattern "^0000:\\d{2}:00\\.0$"
---
"State" Does Not Match "FAILED"
---
"Message" Does Not Match ".*FAILED.*"
---
"Driver Version" Is Compatible With "CUDA 12.2"
---
"Library" Is Not Compatible With "CUDA 11.8"
---
"MOFED" Is Newer Than "5.4-1.0"
---
"Kernel" Is Older Than "6.5.0"
---
For All "Gpus" (
    "Status" Is "Healthy"
    "Temp" < 80
)
---
For All "GPUs" (
    "Temp" < 85 And
    "Status" Is "Healthy"
)
---
For Any "GPUs" (
    "Power State" Is "P0"
    "Power State" Is "P1"
)
---
No "Nodes" (
    "Status" Is "Down"
    "Errors" > 0
)
---
At Least One "Interfaces" (
    "State" Is "Up"
)
---
"Loaded Modules" Has Size Of 8
---
"Modules" Contains All ["nvidia", "nvidia_uvm"]
---
"Current Runlevel" Is One Of [3, 5]
---
"Devices" Is Among ["GPU0", "GPU1"]
---
"Drivers" Contains All ["nvidia", "uvm"]
---
For All "Clusters" (
    Any "Nodes" (
        "Status" Is "Ready"
        "Load" < 80
    )
)
---
For All "Core[0-4]" In "Sensors" (
    "Temperature" Is Less Than 80
)
---
"Core" Has Size Of 4
---
For Each "Adaptor" In ["coretemp-isa-0000", "pch_cannonlake-virtual-0"] (
    "Temp1" Is Less Than 80
)
---
"Voltage" Of "in0" Of "BAT0-acpi-0" Is Less Than 12.0
---
Exactly One "GPU"[0:7] (
    "Status" Is "Active"
    "Temp" < 80
)
For All "Nodes" In "Availability Zones" (
    "Status" Is "Active" And
    "CPU Usage" Is Less Than 90 Unless "Maintenance Mode" Is "Enabled"
)
---
The "MTU" Of "Interfaces" [0..10] Where "Type" Is "Ethernet" Is At Least 1500
---
"Permitted Groups" Of "SSH Config" Does Not Contain "Guest" Also
"Auth Methods" Of "Security Policy" Contains None Of ["Telnet", "RSH"]
---
"Latency" Of "Disk" ["sda", "sdb", "sdc"] Is Less Than "10ms"
"Firmware Version" Of "Storage Controller" Is Compatible With "v2.1.0"
---
For Any "Logs" In "/var/log/syslog" (
    "Severity" Is "Critical" And
    "Message" Matches Pattern ".*(Kernel Panic|Segmentation Fault).*"
)
---
Exactly One "Admin User" In "Current Session" (
    "Role" Is Among ["Superuser", "Root"] And
    "MFA Status" Is "Verified"
)
---
"Memory Limit" Of "Pod" [0-5] Is Between [512..2048]
"Mount Points" Of "Filesystem" Has Size Of 4
---
"Lag Time" Of "Replica" In "Database Cluster" ["Production"] Is Less Than "100ms" Unless "Sync Status" Is "Paused"
---
"Kernel Version" Is Not "5.4.0-generic" Also
"Build Date" Of "Current Image" Is Newer Than "2023-01-01" Also
"Environment" Is Not Equal To "Staging"
---
For No "Cluster" In "Global Fleet" (
    For Any "App Group" In "Namespaces" (
        "Replicas" Is Less Than 1
        "Image Tag" Is "Latest"
    )
)