$PS_PATH="HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
$PS_KEY="Scancode Map"

# keyScanCode {{{
# 2900 hanzen
# 3a00 CapsLock
# 1d00 L-Ctrl
# 5be0 L-win
# 3800 L-Alt
# 7b00 muhenkan
# 3900 space
# 7900 henkan
# 7000 kanahira
# 38e0 R-Alt
# 5ce0 R-Win
# 1de0 R-ctrl
# }}}

$PS_VALUE=([byte[]](    # AfterKeyCode -> BeforeKeyCode
0x00, 0x00, 0x00, 0x00, # header (ver.)
0x00, 0x00, 0x00, 0x00, # header (flag)
0x07, 0x00, 0x00, 0x00, # number of entry (within NULL (the last line))
0x1d, 0x00, 0x3a, 0x00, # L-Ctrl   > L-CapsLock
0x5b, 0xe0, 0x1d, 0x00, # L-Ctrl   > L-Win
0x38, 0x00, 0x5b, 0xe0, # L-Alt    > L-Win
0x1d, 0x00, 0x38, 0x00, # L-Ctrl   > L-Alt
0x3a, 0x00, 0x79, 0x00, # CapsLock > henkan
0x1d, 0xe0, 0x70, 0x00, # kanahira > R-Ctrl
0x00, 0x00, 0x00, 0x00  # null terminator
))

$HAS_PROPEERTY=(Get-ItemProperty -Path $PS_PATH -Name $PS_KEY -ErrorAction SilentlyContinue) -eq $null

if($HAS_PROPEERTY -eq $false){
  Set-ItemProperty -Path $PS_PATH -Name $PS_KEY -Value $PS_VALUE
}
else{
  New-ItemProperty -Path $PS_PATH -Name $PS_KEY -PropertyType Binary -Value $PS_VALUE
}

exit 0
