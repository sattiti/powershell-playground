$o          = New-Object -ComObject "Outlook.Application"
$mSubject   = "hello"
$ns         = $o.GetNamespace("MAPI")
$rootFolder = $o.SessionFolders(1)
$scope      = "'" + $rootFolder.FolderPath + "'" + "'" + $ns.GetDefaultFolder(6) + "'"
$p          = "urn:schemas:mailheader:subject LIKE '%" + $mSubject + "%'"
$s          = $o.AdvancedSearch($scope, $p, $true, "Subject")

foreach($m in $s.Results){
  echo $m.Subject
}
echo $s.Results.Count
