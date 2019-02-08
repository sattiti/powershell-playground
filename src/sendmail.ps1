# powershell -windowstyle hidden -ExecutionPolicy RemoteSigned -File /PATH/TO/FILE

$FROM=""
#$TO=$FROM
#$TO=""
$CC=""
$BCC=""
# $USER=""
# $PASSWD=""
$USERCREDENTIALS=Get-Credential

$SUBJECT="test test"
$BODY=@"
test test

test test
"@

function sendmail ($M_FROM, $M_TO, $M_CC, $M_BCC, $M_SUBJECT, $M_BODY){
  $SMTP_SERVER="smtp"
  $SMTP_PORT=587
  # $SMTP_METHOD="TLS"

  try{
    $CLIENT=New-Object System.Net.Mail.SmtpClient($SMTP_SERVER, $SMTP_PORT)
    $CLIENT.EnableSsl=$true
    $CLIENT.Credentials=New-Object System.Net.NetworkCredential($USERCREDENTIALS.UserName, $USERCREDENTIALS.Password)

    $MAIL=New-Object Net.Mail.MailMessage($M_FROM, $M_TO, $M_SUBJECT, $M_BODY)
    if($M_CC.length -gt 0){
      $MAIL.Cc.Add($M_CC)
    }

    if($M_BCC.length -gt 0){
      $MAIL.Bcc.Add($M_BCC)
    }

    $CLIENT.Send($MAIL)
    return $true
  }
  catch{
    return $false
  }
}

# sendmail $FROM $TO $CC $BCC $SUBJECT $BODY | echo


$JOB=Start-Job {
  function curtime(){
    $H=[Double](Get-Date -format "%h")
    $M=[Double](Get-Date -format "%m")
    $S=[Double](Get-Date -format "%s")
    return [Double](($H * $ONE_MIN * $ONE_MIN) + ($M * $ONE_MIN) + $S)
  }

  $ONE_MIN=60
  $NUM=0

  $START_TIME=[Double]((8 * $ONE_MIN * $ONE_MIN) + (1 * $ONE_MIN))
  $END_TIME=[Double]((19 * $ONE_MIN * $ONE_MIN) + (1 * $ONE_MIN))
  $Desktop=[Environment]::GetFolderPath('Desktop')

  while(1){
    $NOW_TIME=curtime
    # > 0801 and < 1901
    # if($NOW_TIME -gt $START_TIME -or $NOW_TIME -le $END_TIME){
    if($NUM -lt 3){
      sendmail $FROM $TO $CC $BCC $SUBJECT $BODY

      Start-Sleep -s 5
      $NUM=$NUM + 1
    }
    else{
      break;
    }
  }
}

# Remove Job
# while(1){
#   $STATE=$(JOB).state
#   if($STATE -eq "Completed" -or $STATE -eq "Stopped"){
#     Stop-Job -Id $(JOB).id
#     Remove-Job -Id $(JOB).Id
#     break;
#   }
#   else{
#     Start-Sleep -s 5
#   }
# }

exit 0
