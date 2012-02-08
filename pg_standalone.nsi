!define CO_DIR "Zekiah Technologies"
!define NAME "Standalone PostgreSQL/PostGIS Install for Windows"
!define SHORTNAME "PGStandalone"
!define UNINSTALLER "uninstall.exe"

OutFile "setup_${SHORTNAME}.exe"
Name "${NAME}"
Caption "${NAME} Setup"
InstallDir "$PROGRAMFILES\${SHORTNAME}"
CompletedText "Success."
XPStyle "On"
InstallColors /windows

Page directory
Page instfiles
ShowInstDetails show 

Section "Install"
    SetOutPath $INSTDIR

    ; Create uninstaller first, so user can clean up if we barf.
    WriteUninstaller "$INSTDIR\${UNINSTALLER}" ;this actually does nothing right now

    ; Extract all the files.
    DetailPrint "Extracting files..."
	File pg.zip
	ZipDLL::extractall "$INSTDIR\pg.zip" "$INSTDIR"
	
	;Write batch file using INSTDIR to set correct paths
    Call WriteBatchFile
    DetailPrint "OK: Batch file written"

    Call OutputToTemp
    GetFullPathName /short $0 $INSTDIR
	Delete "$INSTDIR\pg.zip"

    ; Add start menu shortcuts.
    DetailPrint "Adding shortcuts..."
    SetShellVarContext all
    CreateDirectory "$SMPROGRAMS\${NAME}"
    SetOutPath "$SMPROGRAMS\${NAME}"
    CreateShortCut "Uninstall.lnk" "$INSTDIR\${UNINSTALLER}"
	CreateShortCut "$DESKTOP\Start PostGIS PIM.lnk" "$INSTDIR\pg_standalone.bat" ""
	CreateShortCut "$DESKTOP\Manage PostGIS PIM.lnk" "$INSTDIR\bin\pgAdmin3.exe" ""
   
    ; Success.
    DetailPrint "All Done!"
SectionEnd

Function OutputToTemp
    ExpandEnvStrings $5 "%TEMP%"
    SetOutPath $5
FunctionEnd

Function un.OutputToTemp
    ExpandEnvStrings $5 "%TEMP%"
    SetOutPath $5
FunctionEnd

Function WriteBatchFile
    ; execute utility to create batch file to execute PostgreSQL

    Call OutputToTemp
    File "utils\make_pg_env.bat"
    ExecWait '"$5\make_pg_env.bat" "$INSTDIR"'
FunctionEnd


UninstPage uninstConfirm
UninstPage instfiles
ShowUninstDetails hide 

Section "Uninstall"
    ; Remove all start menu shortcuts.
    DetailPrint "Removing shortcuts..."
    SetShellVarContext all
    Delete "$SMPROGRAMS\${NAME}\*"
    RmDir "$SMPROGRAMS\${NAME}"

    DetailPrint "Removing files..."

    Delete "$INSTDIR\${UNINSTALLER}"
    RmDir "$INSTDIR"
SectionEnd
