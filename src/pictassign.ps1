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
$src  = Read-Host "Entry the pict Folder Path"
$dist = Read-Host "Entry the output path"
$num  = 0
$pats = @("jpg", "jpeg", "png", "gif", "mov", "mp4", "avi", "aae", "heic", "heif", "tiff", "tif", "bmp", "jp2", "jpc", "pic", "pict", "pdf", "psd", "psb", "tga", "svg", "webp", "tpic", "eps", "epsi", "epsf", "ai")

# Dist is great then 0 or not.
if(isEmpty $src){
  echo "EMPTY STRING."
  echo "BYE."
  exit
}

# Output path will be $HOME/yyyyMMddHHmmss if got no entry.
if(isEmpty $dist){
  $dist = [System.io.Path]::GetFullPath("${HOME}") + '/Desktop/' + $now
}
else{
  $dist = [System.io.Path]::GetFullPath("${dist}")
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

Get-ChildItem -Recurse $src | foreach($_){
  $lastWriteDate = $_.LastWriteTime.Date.toString("yyyyMMdd")
  $dest          = $dist + '/' + $lastWriteDate
  $output        = $dest + '/' + $_.Name
  $ext           = [System.IO.Path]::GetExtension($output)

  # mkdir output if not exist.
  if(!(Test-Path -path $dest)){ New-Item $dest -Type Directory | Out-Null }

  if($_.FullName.ToLower() | Select-String -Pattern $pats){
    echo $_.FullName

    # mv items to output.
    # Move-Item -Path
    Move-Item -Force -Path $_.FullName -Destination $output

    # cp items to output
    # cp -Force -Recurse -Path $_.FullName -Destination $output

    # count file.
    if(Test-Path -PathType leaf -Path $output){
      $num = $num + 1
    }
  }
}

# print mv count.
echo "${num} Moved."
exit
