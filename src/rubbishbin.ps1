function isEmpty($str){
  if($str.length -le 0){ return $true } else { return $false }
}

function exist($dist){
  if(Test-Path -path ([System.io.Path]::GetFullPath("${dist}"))){ return $true } else { return $false }
}

$dist=Read-Host "TARGET PATH"
$constString="FuckOFFThisFile."

if(exist $dist){
  $dist = [System.io.Path]::GetFullPath("${dist}")
}
else {
  echo "${dist} IS NOT EXIST."
  echo "BYE."
  exit
}

$times=Read-Host "Replacing times: (Default: 25)"
if(isEmpty $times){
  $times = 25
}

echo "Do ${times} times."
echo "replace..."


while($times -gt 0){
  $v = Get-Random
  $v = [convert]::ToString($v, 2)
  Get-ChildItem -Recurse $dist | foreach($_){
    $_.FullName
    if(Test-Path -PathType Leaf $_.FullName){
      Set-Content -Force -Encoding Unknown -Path $_.FullName -Value $v | Out-Null
    }
  }
  $times -= 1
}

Remove-Item -Recurse -Force -Path $dist
exit 0
