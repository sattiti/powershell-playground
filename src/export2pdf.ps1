# script var {{{
$script:count = 0
$script:total = 0
#}}}
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

# ppt2pdf
function ppt2pdf($app, $f, $out){
  try{
    $book = $app.Presentations.Open($f, $true, 0, 0)
    $book.SaveAs($out, 32)
    $script:count ++
    echo "[SAVED ${script:count}] ${out}"
  }
  catch{
    echo "[ERROR ${script:count}] ${f}"
    echo "[ERROR ${script:count}] ${f}" >> $script:log
  }
  finally{
    if($book){ $book.Close() }
  }
}

#doc2pdf
function doc2pdf($app, $f, $out){
  $WdExportFormat = "Microsoft.Office.Interop.Word.WdExportFormat" -as [type]
  try{
    $book = $app.documents.Open($f)
    $book.ExportAsFixedFormat($out, $WdExportFormat::wdExportFormatPDF)
    $script:count ++
    echo "[SAVED ${script:count}] ${out}"
  }
  catch{
    echo "[ERROR ${script:count}] ${f}"
    echo "[ERROR ${script:count}] ${f}" >> $script:log
  }
  finally{
    if($book) { $book.Close() }
  }
}

function xls2pdf($app, $f, $out){
  $xlFixedFormat = "Microsoft.Office.Interop.Excel.xlFixedFormatType" -as [type]
  try{
    $book = $app.Workbooks.Open($f, 3)
    $app.Application.DisplayAlerts = $false
    $book.ExportAsFixedFormat($xlFixedFormat::xlTypePDF, $out)
    $script:count ++
    echo "[SAVED ${script:count}] ${out}"
  }
  catch{
    echo "[ERROR ${script:count}] ${f}"
    echo "[ERROR ${script:count}] ${f}" >> $script:log
  }
  finally{
    $app.Workbooks.Close()
    $app.Application.DisplayAlerts = $true
  }
}
#}}}
# run{{{
# Get res path.
$resDist=Read-Host "Resources folder path"

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

# var
# app init
$excel         = New-Object -ComObject Excel.Application
$ppt           = New-Object -ComObject PowerPoint.Application
$word          = New-Object -ComObject Word.Application
$excel.Visible = $false
$ppt.Visible   = [Microsoft.Office.Core.MsoTriState]::MsoTrue
$word.Visible  = $false

# extension pattern
$extPat = "ppt|pptx|doc|docx|xls|xlsx"
$pptExt = "ppt|pptx"
$docExt = "doc|docx"
$xlsExt = "xls|xlsx"
$pdfExt = ".pdf"

# output folder
$saveDiscRoot = (Split-Path $script:myInvocation.MyCommand.path -parent) + "\output"
$script:log   = "${saveDiscRoot}\result.log"

Get-ChildItem -Recurse $resDist | foreach($_){
  $resFile = ($_).FullName
  $ext     = [System.io.Path]::GetExtension($resFile)

  if($ext -match $extPat){
    $script:total++
    $dirname  = ([System.io.Path]::GetDirectoryName($resFile)).SubString($resDist.Length)
    $basename = [System.io.Path]::GetFileName($resFile)
    $saveDisc = $saveDiscRoot + $dirname
    $outname  = [System.io.Path]::GetFileNameWithoutExtension($basename) + "${pdfExt}"

    # mkdir if not exist.
    if (-not(Test-Path -Path $saveDisc)){
      New-Item -Force -ItemType Directory -Path $saveDisc | Out-Null
    }

    # convert2pdf
    switch -regex ($ext){
      $xlsExt { xls2pdf $excel $resFile "${saveDisc}\$outname" }
      $pptExt { ppt2pdf $ppt $resFile "${saveDisc}\$outname" }
      $docExt { doc2pdf $word $resFile "${saveDisc}\$outname" }
    }
  }
}

$excel.Quit()
$ppt.Quit()
$word.Quit()

echo "[DONE] ${script:count}/${script:total}"

exit 0
#}}}
