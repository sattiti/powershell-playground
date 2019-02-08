$patterns = @(".*?script", "armsvc")

foreach($pat in $patterns){
  if((Get-Process).ProcessName | Select-String -Pattern $pat){
    $logPath = "${HOME}\.log\fuckpsoff.log"
    $dirPath = Split-Path -parent $logPath
    $nl      = [System.Environment]::NewLine
    $enc     = New-Object "System.Text.UTF8Encoding" -ArgumentList @($false)

    if(-not(Test-Path $dirPath)){
      md $dirPath
    }

    $p     = Get-Process -Name ((Get-Process).ProcessName | Select-String -Pattern $pat)
    $pName = $p.ProcessName
    $id    = $p.Id
    $date  = Get-Date

    Stop-Process $id -Force
    [System.IO.File]::AppendAllText($logPath, "${date} ${id} ${pName}${nl}", $enc)
  }
}

exit 0
