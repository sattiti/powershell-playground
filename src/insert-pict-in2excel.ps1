function isEmpty($str){
  if($str.length -le 0){
    return $true
  }
  else {
    return $false
  }
}

function exist($dest){
  if(Test-Path -path ([System.io.Path]::GetFullPath("${dest}"))){
    return $true
  }
  else{
    return $false
  }
}

function worksheetExists($name, $b){
  $hasWorkSheet = $false
  foreach($s in $b.WorkSheets){
    if($s.Name -eq $name){
      $hasWorkSheet = $true
      break
    }
  }
  return $hasWorkSheet
}

function versionSheet($b){
  $hasWorkSheet = worksheetExists "Version" $b
  if($hasWorkSheet -eq $false){
    $sheet = $b.WorkSheets.Add()
    $sheet.Name = "Version"
    $sheet.Cells.Item(1, 1) = "Version"
    $sheet.Cells.Item(1, 2) = "ChangedLog"
    $sheet.Cells.Item(1, 3) = "UpdatedAt"
    $sheet.cells.item(2, 1) = "v1.0.0"
    $sheet.cells.item(2, 2) = "Initial edition."
    $sheet.cells.item(2, 3) = Get-Date

    $sheet.Range("A1", $sheet.cells.item(1, 999)).Interior.ColorIndex = 15
    $sheet.Range("A1", $sheet.cells.item(1, 999)).Font.Bold           = $true
    $sheet.Range("A:C").Borders.LineStyle                             = 1
    return $sheet
  }
}


function px2cm($px, $margin = 10){
  $inch = 2.54
  $dpi  = 220.0
  return (($px / $dpi * $inch) * 10) + $margin
}

function relationSheet($b){
  $sName        = "List"
  $hasWorkSheet = worksheetExists $sName $b

  if($hasWorkSheet -eq $false){
    $sheet      = $b.WorkSheets.Add()
    $sheet.Name = $sName
    $head       = @("ID", "PageName", "URL", "Details", "Status", "Comments", "title", "keywords", "description", "alternate", "canonical", "redirect")

    for($i = 0; $i -lt $head.length; $i++){
      $h                                               = $head[$i]
      $sheet.cells.item(1, $i + 1)                     = $h
      $sheet.cells.item(1, $i + 1).Interior.ColorIndex = 1
      $sheet.cells.item(1, $i + 1).font.bold           = $true
      $sheet.cells.item(1, $i + 1).font.ColorIndex     = 2
      $sheet.cells.item(1, $i + 1).Borders.LineStyle   = 1
    }

    return $sheet
  }
}

function sitemapSheet($b){
  $sName        = "Sitemap"
  $hasWorkSheet = worksheetExists $sName $b

  if($hasWorkSheet -eq $false){
    $sheet      = $b.WorkSheets.Add()
    $sheet.Name = $sName
    $head       = @("1", "2", "3", "4", "5", "id", "url", "contents", "title", "keywords", "description", "canonical", "alternate", "h1", "h2", "h3", "h4", "h5", "h6", "redirect", "comments")

    for($i = 0; $i -lt $head.length; $i++){
      $h                                               = $head[$i]
      $sheet.cells.item(1, $i + 1)                     = $h
      $sheet.cells.item(1, $i + 1).Interior.ColorIndex = 1
      $sheet.cells.item(1, $i + 1).font.bold           = $true
      $sheet.cells.item(1, $i + 1).font.ColorIndex     = 2
      $sheet.cells.item(1, $i + 1).Borders.LineStyle   = 1
    }

    return $sheet
  }
}

function getImageInfo($imgPath){
  add-type -AssemblyName System.Drawing
  return New-Object System.Drawing.Bitmap $imgPath
}

$imageDist=Read-Host "Image folder path"

# imageDist is great then 0 or not.
if(isEmpty $imageDist){
  echo "EMPTY STRING."
  echo "BYE."
  exit
}

# path exist or not.
if(exist $imageDist){
  $imageDist = [System.io.Path]::GetFullPath("${imageDist}")
}
else {
  echo "${imageDist} IS NOT EXIST."
  echo "BYE."
  exit
}

# book
$bookDist=Read-Host "if you got a Workbook, please entry the path"
if(isEmpty $bookDist){
  $bookDist = "${HOME}/Desktop/PicBook.xlsx"
}
elseif(exist $bookDist) {
  $bookDist = [System.io.Path]::GetFullPath("${bookDist}")
}
else {
  $bookDist = "${HOME}/Desktop/PicBook.xlsx"
}


echo $bookDist

# new Excel Object
$excel         = New-Object -ComObject Excel.Application
$excel.Visible = $false

# open book or new book.
if(exist $bookDist) {
  $book      = $excel.Workbooks.Open($bookDist)
  $saveDisc  = "${HOME}/Desktop/" + $book.Name
}
else {
  $book      = $excel.Workbooks.Add()
  $saveDisc  = $bookDist
}

$excel.Application.ScreenUpdating = $false
$excel.Application.Calculation    = -4135

$sheetNum = $book.WorkSheets.Count
$lastRow  = 6
$lastCol  = 16

try{
  # -File
  Get-ChildItem -Recurse $imageDist | Sort-Object -Descending | foreach($_){
    $imgPath = ($_).FullName
    if([System.io.Path]::GetExtension($imgPath) -match "gif|jpg|jpeg|png"){
      $sheet = $book.WorkSheets.Add()
      $sheet.Move([System.Reflection.Missing]::Value, $book.WorkSheets.Item($book.WorkSheets.Count))

      $image = getImageInfo $imgPath
      # px2cm
      $sheet.Cells.Item(1, 1).ColumnWidth = px2cm $image.Width

      # white bg
      $sheet.Range("A:A").Interior.ColorIndex = 2

      # fixed B1
      $sheet.Range("B1").Select() | Out-Null
      $excel.ActiveWindow.FreezePanes = $true

      # add pict
      $shape = $sheet.Shapes.AddPicture($imgPath, $false, $true, 0, 0, 0, 0)
      $shape.ScaleWidth(1.0, $true)
      $shape.ScaleHeight(1.0, $true)
      $shape.Placement = 3
    }
  }

  $vs = versionSheet $book
  $rs = relationSheet $book
  $ss = sitemapSheet $book

  if(worksheetExists $rs.Name $book -eq $false){
    $rs.Move($book.WorkSheets.Item(1))
  }
  if(worksheetExists $ss.Name $book -eq $false){
    $ss.Move($book.WorkSheets.Item(1))
  }
  if(worksheetExists $vs.Name $book -eq $false){
    $vs.Move($book.WorkSheets.Item(1))
  }
}
catch [Exception]{
  echo $error
}
finally{
  # activate screen update
  $excel.Application.ScreenUpdating = $true
  $excel.Application.Calculation    = -4105

  $excel.Application.DisplayAlerts = $false
  $book.SaveAs($saveDisc)
  $excel.Application.DisplayAlerts = $true
  $excel.Quit()
}

exit 0
