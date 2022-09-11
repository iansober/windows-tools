$UserPasswordExpirationList = Get-ADUser -searchbase 'OU=Users,DC=mydomain,DC=local' -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "UserPrincipalName", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "UserPrincipalName",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

$Date = Get-Date

$ExpirationList = @()

foreach ($User in $UserPasswordExpirationList) {
	if ((($User.ExpiryDate - $Date).Days -le 8) -and (($User.ExpiryDate - $Date).Days -gt 0)) {
		$ExpirationList += $User
	}
}

$ExpirationList = $ExpirationList | Out-String

if ($ExpirationList) {
	Send-MailMessage -From 'Password Reminder <passwordreminder@mydomain.com>' -To 'Admin <admin@mydomain.com>' -Subject 'Password expiration reminder' -Body $ExpirationList -Priority High -DeliveryNotificationOption OnSuccess, OnFailure -SmtpServer 'smtp.server.com'
}
