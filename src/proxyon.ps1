$PS_PATH       = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
$PS_KEY        = "ProxyEnable"
$CURT_PS_VALUE = (Get-ItemProperty -Path $PS_PATH -Name $PS_KEY).$PS_KEY

echo "${PS_KEY}: ${CURT_PS_VALUE}"

if(-not $CURT_PS_VALUE -eq 1){
  $CHG = $true
  
  if($CHG){
    Set-ItemProperty -Path $PS_PATH -Name $PS_KEY -Value 1
    echo "DONE."
    
    $CURT_PS_VALUE = (Get-ItemProperty -Path $PS_PATH -Name $PS_KEY).$PS_KEY
    echo "${PS_KEY}: ${CURT_PS_VALUE}"
  }
}
else{
  echo "BYE."
}

exit 0
