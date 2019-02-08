# ################
# Registry Setting
# ################
# PropertyType
# Binary       REG_BINARY
# DWord        REG_DWROD
# ExpandString REG_EXPAND_SZ
# MultiString  REG_MULTI_SZ
# String       REG_SZ
# QWord        REG_QWORD

$regs = @(
  @{
    dist="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
    prefs= @(
      @{ name="AlwaysShowMenus";                       type= "DWord"; value = 1; },
      @{ name="AutoCheckSelect";                       type= "DWord"; value = 0; },
      @{ name="AlwaysShowMenus";                       type= "DWord"; value=1; },
      @{ name="AutoCheckSelect";                       type= "DWord"; value=0; },
      @{ name="DisablePreviewDesktop";                 type= "DWord"; value=0; },
      @{ name="DontPrettyPath";                        type= "DWord"; value=0; },
      @{ name="Filter";                                type= "DWord"; value=0; },
      @{ name="Hidden";                                type= "DWord"; value=1; },
      @{ name="HideFileExt";                           type= "DWord"; value=0; },
      @{ name="HideIcons";                             type= "DWord"; value=0; },
      @{ name="IconsOnly";                             type= "DWord"; value=0; },
      @{ name="ListviewAlphaSelect";                   type= "DWord"; value=0; },
      @{ name="ListviewShadow";                        type= "DWord"; value=0; },
      @{ name="MapNetDrvBtn";                          type= "DWord"; value=0; },
      @{ name="NavPaneExpandToCurrentFolder";          type= "DWord"; value=0; },
      @{ name="NavPaneShowAllFolders";                 type= "DWord"; value=0; },
      @{ name="SeparateProcess";                       type= "DWord"; value=0; },
      @{ name="ServerAdminUI";                         type= "DWord"; value=0; },
      @{ name="ShowCompColor";                         type= "DWord"; value=1; },
      @{ name="ShowInfoTip";                           type= "DWord"; value=1; },
      @{ name="ShowTypeOverlay";                       type= "DWord"; value=1; },
      @{ name="StartMenuAdminTools";                   type= "DWord"; value=0; },
      @{ name="StartMenuInit";                         type= "DWord"; value=4; },
      @{ name="Start_AdminToolsRoot";                  type= "DWord"; value=0; },
      @{ name="Start_AutoCascade";                     type= "DWord"; value=0; },
      @{ name="Start_EnableDragDrop";                  type= "DWord"; value=0; },
      @{ name="Start_JumpListItems";                   type= "DWord"; value=0x0a; },
      @{ name="Start_LargeMFUIcons";                   type= "DWord"; value=0; },
      @{ name="Start_MinMFU";                          type= "DWord"; value=0x0a; },
      @{ name="Start_NotifyNewApps";                   type= "DWord"; value=0; },
      @{ name="Start_PowerButtonAction";               type= "DWord"; value=2; },
      @{ name="Start_SearchFiles";                     type= "DWord"; value=1; },
      @{ name="Start_SearchPrograms";                  type= "DWord"; value=0; },
      @{ name="Start_ShowControlPanel";                type= "DWord"; value=1; },
      @{ name="Start_ShowHelp";                        type= "DWord"; value=0; },
      @{ name="Start_ShowHomegroup";                   type= "DWord"; value=0; },
      @{ name="Start_ShowMyComputer";                  type= "DWord"; value=0; },
      @{ name="Start_ShowMyDocs";                      type= "DWord"; value=0; },
      @{ name="Start_ShowMyGames";                     type= "DWord"; value=0; },
      @{ name="Start_ShowMyMusic";                     type= "DWord"; value=0; },
      @{ name="Start_ShowMyPics";                      type= "DWord"; value=0; },
      @{ name="Start_ShowNetConn";                     type= "DWord"; value=0; },
      @{ name="Start_ShowPrinters";                    type= "DWord"; value=0; },
      @{ name="Start_ShowSetProgramAccessAndDefaults"; type= "DWord"; value=0; },
      @{ name="Start_ShowUser";                        type= "DWord"; value=0; },
      @{ name="Start_SortByName";                      type= "DWord"; value=0; },
      @{ name="Start_TrackDocs";                       type= "DWord"; value=0; },
      @{ name="Start_TrackProgs";                      type= "DWord"; value=0; },
      @{ name="SuperHidden";                           type= "DWord"; value=0; },
      @{ name="TaskbarAnimations";                     type= "DWord"; value=0; },
      @{ name="TaskbarGlomLevel";                      type= "DWord"; value=1; },
      @{ name="TaskbarSizeMove";                       type= "DWord"; value=1; },
      @{ name="TaskbarSmallIcons";                     type= "DWord"; value=1; },
      @{ name="WebView";                               type= "DWord"; value=1; }
    )
  },
  @{
    dist="HKCU:\Software\Microsoft\Windows\DWM";
    prefs=@(
      @{ name="AlwaysHibernateThumbnails";            type= "DWord"; value=0 },
      @{ name="ColorizationAfterglow";                type= "DWord"; value=0xc7545454 },
      @{ name="ColorizationAfterglowBalance";         type= "DWord"; value=0x0a },
      @{ name="ColorizationBlurBalance";              type= "DWord"; value=0 },
      @{ name="ColorizationColor";                    type= "DWord"; value=0xc7545454 },
      @{ name="ColorizationColorBalance";             type= "DWord"; value=0x5a },
      @{ name="ColorizationGlassReflectionIntensity"; type= "DWord"; value=0x00000032 },
      @{ name="ColorizationOpaqueBlend";              type= "DWord"; value=1 },
      @{ name="Composition";                          type= "DWord"; value=1 },
      @{ name="CompositionPolicy";                    type= "DWord"; value=2 },
      @{ name="EnableAeroPeek";                       type= "DWord"; value=1 },
      @{ name="LastDisqualifiedCompositionSignature"; type= "DWord"; value=0x00140000 }
    )
  },
  @{
    dist="HKCU:\Control Panel\Desktop";
    prefs=@(
      @{ name="UserPreferencesMask"; type="Binary"; value=([byte[]](0x90, 0x32, 0x07, 0x80, 0x10, 0x00, 0x00, 0x00)) },
      @{ name="FontSmoothing";       type="String"; value=2 },
      @{ name="DragFullWindows";     type="String"; value=1 }
    )
  },
  @{
    dist="HKCU:\Software\Microsoft\Windows\CurrentVersion\ThemeManager";
    prefs=@(
      @{ name="ThemeActive"; type="String"; value=1 }
    )
  },
  @{
    dist="HKCU:\Control Panel\Desktop\WindowMetrics";
    prefs=@(
      @{ name="MinAnimate"; type="String"; value=0 }
    )
  }
)

foreach($reg in $regs){
  $dist = $reg["dist"]
  foreach($pref in $reg["prefs"]){
    $prop = (Get-ItemProperty -Path $dist -Name $pref["name"] -ErrorAction SilentlyContinue)

    if($prop -eq $null){
      New-ItemProperty -Path $dist -Name $pref["name"] -PropertyType $pref["type"] -Value $pref["value"]
    }
    else{
      Set-ItemProperty -Path $dist -Name $pref["name"] -Value $pref["value"]
    }
  }
}

# ###########
# Env setting
# ###########
# Set-Item env:LANG -Value C
# Set-Item env:LC_ALL -Value C
# Set-Item env:RUBYPORT -Value "-Eutf-8"
# Set-Item env:VIM -Value "/PATH/TO/VIM"
# Set-Item env:HTTP_PROXY -Value ""

# print env
Get-Item env:

exit 0
