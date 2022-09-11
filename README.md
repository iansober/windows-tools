# windows-server-tools

Some simple tools for windows server automatization or simplification of routine tasks. It is simple to do it yourself or you can just download, make some edits and use for your own goodness.

## expired-in-7-days-ADUC.ps1

Password expiration reminder sends email notification with a list of users which password will expire in 7 days. Useful if there is some service accounts without any email address and where is not able to enable bult-in windows notifications.

Please edit before use:

1. Line 1: -searchbase **'OU=Users,DC=mydomain,DC=local'**
2. If you need another amount of days then 7, you should edit line 8: $User.ExpiryDate - $Date).Days -le **8**
3. Line 16: -From 'Password Reminder <passwordreminder@mydomain.com>'
4. Line 16: -To 'Admin <admin@mydomain.com>'
5. Line 16: -SmtpServer 'smtp.server.com'
