# function {{{
# exit program
function goExit($msg){
  echo $msg
  echo "BYE."
  exit 0
}

# Return true if is blank string
function isEmpty($str){
  if($str.length -le 0){
    return $true
  }
  else {
    return $false
  }
}

# exist
function exist($dest){
  if(Test-Path -path ([System.io.Path]::GetFullPath("${dest}"))){
    return $true
  }
  else{
    return $false
  }
}
#}}}
# run{{{
# Get res path.
$resDist=Read-Host "file path"

# resDist is great then 0 or not.
if(isEmpty $resDist){
  goExit "EMPTY STRING."
}

# path exist or not.
if(exist $resDist){
  $resDist = [System.io.Path]::GetFullPath("${resDist}")
}
else {
  goExit "${resDist} IS NOT EXIST."
}

$outputFile = (Split-Path $script:myInvocation.MyCommand.path -parent) + "\result.txt"
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
$file              = Get-Content $resDist | Sort-Object -CaseSensitive
[System.IO.File]::WriteAllLines($outputFile, $file, $Utf8NoBomEncoding)

echo "[DONE] ${outputFile}"

exit 0
#}}}
