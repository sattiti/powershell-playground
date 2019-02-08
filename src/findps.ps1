function isEmpty($str){
  if($str.length -le 0){ return $true } else{ return $false }
}

function exist($dist){
  if(Test-Path -path ([System.io.Path]::GetFullPath("${dist}"))){ return $true } else{ return $false }
}

function getTicks($v){
  if(-not(isEmpty $v)){
    return ([System.DateTime]($v)).Ticks
  }
  else{
    return (Get-Date).Ticks
  }
}

$now  = ([System.DateTime]::Now).toString("yyyyMMdd-HHmmss")
$src  = (Read-Host "Target folder path").Replace('"', '')
$pat  = Read-Host "Search string"
$exts = @("*.psd")
$log  = [System.io.Path]::GetFullPath("${HOME}") + '/Desktop/' + $now + ".log"
$num  = 0
$total = 0

# Dist is great then 0 or not.
if(isEmpty $src){
  echo "EMPTY STRING."
  echo "BYE."
  exit
}

# path check.
if(exist $src){
  $src = [System.io.Path]::GetFullPath("${src}")
}
else {
  echo "No such file or directory."
  echo "BYE."
  exit
}

Get-ChildItem -Recurse -Include $exts -Path $src | foreach($_){
  $total = $total + 1
  if((Get-Content -Encoding UTF8 -Path $_.FullName | Select-String -Encoding UTF8 -Pattern "<photoshop:LayerName|LayerText>" | Select-String -Encoding UTF8 -Pattern "${pat}")){
    $num = $num + 1
    $_.FullName | Out-File -Append -Encoding UTF8 -filepath "${log}"
    echo "[${num}] $_"
  }
}

# print mv count.
echo "[${num}/${total}] Found."
exit
