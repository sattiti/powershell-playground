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
    if($NUM -lt 5){
      # enableproxy | Out-Null
      New-Item -Force -Path $Desktop -ItemType File -Name "a${NUM}.txt" | Out-Null
      if($NUM -gt 0){
        $NNUM=$NUM - 1
        Remove-Item -Force ${Desktop}\a"${NNUM}".txt
      }
      Start-Sleep -s 5
      $NUM=$NUM + 1
    }
    else{
      break;
    }
  }
}

# Remove Job
while(1){
  $STATE=$(JOB).state
  if($STATE -eq "Completed" -or $STATE -eq "Stopped"){
    Stop-Job -Id $(JOB).id
    Remove-Job -Id $(JOB).Id
    break;
  }
  else{
    Start-Sleep -s 5
    # echo $JOB
  }
}

exit 0
