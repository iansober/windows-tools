# windows-tools

Some simple tools for windows server automatization or simplification of routine tasks. It is simple to do it yourself or you can just download, make some edits and use for your own goodness.

Mostly for the servers but some scripts useful for workstations.

## expired-in-7-days-ADUC.ps1

Password expiration reminder sends email notification with a list of users which password will expire in 7 days. Useful if there is some service accounts without any email address and where is not able to enable bult-in windows notifications.

Please edit before use:

1. Line 1: -searchbase **'OU=Users,DC=mydomain,DC=local'**
2. If you need another amount of days then 7, you should edit line 8: $User.ExpiryDate - $Date).Days -le **8**
3. Line 16: -From **'Password Reminder <passwordreminder@mydomain.com>'**
4. Line 16: -To **'Admin <admin@mydomain.com>'**
5. Line 16: -SmtpServer **'smtp.server.com'**

## performance-statistics.ps1

Checks CPU, RAM, Ethernet and Wi-Fi statistics every 30 seconds.

## ost-to-another-disk.ps1

Tool for moving users .ost files to another disk to free-up space on system drive. The script creates link to the moved .ost file so Outlook keeps working as usual.

The script makes folders named as users with existing .ost files in choosen directory. Then it moves .ost and created link in %localappdata%\microsoft\outlook directory. 

Edit line 10 for setting your path: $Destination = **'D:\'** + ($UserFolder | Select-Object -ExpandProperty Name) + '\'

The script should be run with administrator permissions so it will be able to move all the users' .ost.

**I highly recommend to set the destination path to the NTFS drive so the users' permissions to the .ost files will be saved.**
