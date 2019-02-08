$JOB=Start-Job {
  function curtime(){
    $H = [Double](Get-Date -format "%h")
    $M = [Double](Get-Date -format "%m")
    $S = [Double](Get-Date -format "%s")
    return [Double](($H * $ONE_MIN * $ONE_MIN) + ($M * $ONE_MIN) + $S)
  }

  function enableproxy(){
    $PS_PATH       = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
    $PS_KEY        = "ProxyEnable"
    $CURT_PS_VALUE = (Get-ItemProperty -Path $PS_PATH -Name $PS_KEY).$PS_KEY
    $CHG           = $true

    if(-not $CURT_PS_VALUE -eq 1){
      if($CHG){
        Set-ItemProperty -Path $PS_PATH -Name $PS_KEY -Value 1
      }
    }
    return (Get-ItemProperty -Path $PS_PATH -Name $PS_KEY).$PS_KEY
  }

  $ONE_MIN = 60
  $NUM     = 0

  $START_TIME = [Double]((8 * $ONE_MIN * $ONE_MIN) + (1 * $ONE_MIN))
  $END_TIME   = [Double]((23 * $ONE_MIN * $ONE_MIN) + (1 * $ONE_MIN))

  while(1){
    $NOW_TIME = curtime
    if($NOW_TIME -gt $START_TIME -or $NOW_TIME -le $END_TIME){
      enableproxy | Out-Null
      Start-Sleep -s 500
    }
    else{
      break;
    }
  }
}

# Remove Job
while(1){
  $STATE = $(JOB).state

  if($STATE -eq "Completed" -or $STATE -eq "Stopped"){
    Stop-Job -Id $(JOB).id
    Remove-Job -Id $(JOB).Id
    break;
  }
  else{
    Start-Sleep -s 500
  }
}

exit 0
