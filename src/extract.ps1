function isEmpty($str){
  if($str.length -le 0){ return $true } else { return $false }
}

function exist($dist){
  if(Test-Path -path ([System.io.Path]::GetFullPath("${dist}"))){ return $true } else { return $false }
}

function getTicks($v){
  if(-not(isEmpty $v)){
    return ([System.DateTime]($v)).Ticks
  }
  else{
    return (Get-Date).Ticks
  }
}

$dist=Read-Host "Folder Path"
$from=Read-Host "[allow empty]FROM example: 2016/1/1 00:00:01"
$to=Read-Host "[allow empty]TO   example: 2016.1.3 23.59.59"

# Dist is great then 0 or not.
if(isEmpty $dist){
  echo "EMPTY STRING."
  echo "BYE."
  exit
}

# path exist or not.
if(exist $dist){
  $dist = [System.io.Path]::GetFullPath("${dist}")
}
else {
  echo "${dist} IS NOT EXIST."
  echo "BYE."
  exit
}

$fromTicks  = getTicks $from
$toTicks    = getTicks $to
$folderName = ([System.DateTime]::Now).toString("yyyyMMddHHmmss")
$destFolder = "${HOME}\Desktop\${folderName}"

Get-ChildItem -Recurse $dist | foreach($_){
  $fileTicks = $_.LastWriteTime.Ticks

  if(($fileTicks -ge $fromTicks) -and ($fileTicks -le $toTicks)){
    if(-not($_.Attributes.toString() -match "directory")){

      # mkdir if not exist
      $file = $_.FullName.Replace($dist, "")
      $dest = "${destFolder}${file}"

      $nDir = [System.IO.Path]::GetDirectoryName($dest)
      # mkdir if not exist
      if(!(Test-Path -path $nDir)){ New-Item $nDir -Type Directory | Out-Null }

      # output log
      #$_.FullName >> "${destFolder}\${folderName}.log"
      $_.FullName | Out-File -Append -Encoding UTF8 -filepath "${destFolder}\${folderName}.log"

      # cp
      cp -Force -Recurse -Path $_.FullName -Destination $dest
    }
  }
}

exit
