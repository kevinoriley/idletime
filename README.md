Intended for Datto RMM

Run task.ps1 daily as a script:
- Automation -> Components -> Create Component
- Name: Whatever you'd like
- Category: Scripts
- Script: Powershell
- Paste task.ps1 into the body
- Select sites
- Attach idlecheck.ps1 and psrun.vbs to the script
- Automation -> Jobs
- Create Job
- Add the IdleTime task script
- Choose your targets
- Choose your schedule (daily works well)
- Always set an expiration (1 hour works well)
- Run as system account

Run monitor.ps1 as a monitor at an interval of your choosing:
- Automation -> Components -> Create Component
- Name: Whatever you'd like
- Category: Monitors
- Script: Powershell
- Paste monitor.ps1 into the body
- Select sites
- Add a variable named UDFNumber with type STRING. Set the value to whatever UDF you'd like to populate
  - Setup -> Global Settings to see all UDFs
- Policies -> Monitoring
- Create Policy
- Name: Whatever you'd like
- Set your scope
- Add the IdleTime component monitor and configure it to run at whatever interval you'd like
  - 5 minutes seems fine, although it only updates every 10-15 minutes, realistically
  - "Raise an alert" doesn't matter since the monitor always returns 0 (success)
- Choose your targets
- Save and Deploy

task.ps1 - creates (and/or deletes/recreates) a scheduled task that runs every 5 minutes. Task runs in the logged on user's context and runs idlecheck.ps1 to check idle status. Outputs timespan to output.txt. psrun.vbs is needed to keep the Powershell window completely invisible to the user.

monitor.ps1 - updates the IdleTime UDF with 1 of 3 values:
  1. Logged Off - if explorer.exe is not running
  2. Active - if output.txt contains a timespan less than 5 minutes
  3. Idle - if output.txt contains a timespan greater than 5 minutes

If you're having trouble saving the script, monitor, or monitoring policy, try removing all comment lines (#) from the components. For some reason Datto doesn't interpret them very well...

![plot](https://github.com/kevinoriley/idletime/blob/main/idletime.png)
