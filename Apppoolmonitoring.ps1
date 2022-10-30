##############################################################################
#                IIS MONITORING
#                Description: SCript to Monitor IIS Pools
#                Written for Hawkeye Housecalls applications
##############################################################################

$smtpServer = "smtpserver"
$fromadd = "sriramanujan.r@optum.com"
$email1 = "HC_L3_SLO@ds.uhc.com"


Import-Module WebAdministration


Function Monitorsitepool ($IISSite) 

{

$Apppool = Get-Item "IIS:\Sites\$IISSite" | Select-Object applicationPool

$ApppoolState = Get-WebAppPoolState $Apppool.applicationPool
$apppoolname = $Apppool.applicationPool
$hostn = hostname


if($ApppoolState.Value -ne "Started")
  
  {
  Write-host ""$Apppool.applicationPool" for Site $IISSite is not running on server $hostn" -foregroundColor Red
  $subj = "Event Notification : OPEN CRITICAL : $apppoolname pool for Site $IISSite is not running on server $hostn"
  $msg = new-object Net.Mail.MailMessage
  $smtp = new-object Net.Mail.SmtpClient($smtpServer)
  #Mail sender
  $msg.From = $fromadd
  #mail recipient
  $msg.To.Add($email1)
  $msg.Subject = $subj
  $msg.Body = $subj
  $smtp.Send($msg)
  }
Else
  {
  Write-host ""$Apppool.applicationPool" for Site $IISSite is running" -foregroundColor Green
  <#$subj = "Event Notification : OPEN CRITICAL : $apppoolname pool for Site $IISSite is running on server $hostn"
  $msg = new-object Net.Mail.MailMessage
  $smtp = new-object Net.Mail.SmtpClient($smtpServer)
  #Mail sender
  $msg.From = $fromadd
  #mail recipient
  $msg.To.Add($email1)
  $msg.Subject = $subj
  $msg.Body = $subj
  $smtp.Send($msg)#>
  }

}



Monitorsitepool "Sharepoint - 80"
Monitorsitepool "MySites - 80"
Monitorsitepool "Teams - 80"
Monitorsitepool "SharePoint Central Administration v4"


##################################################################################################
