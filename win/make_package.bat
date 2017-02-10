@ECHO OFF

SET CURRENT_DIR=%~dp0

SET argCount=0
FOR %%x IN (%*) DO SET /A argCount+=1

IF "%argCount%" =="4" (
  SET PACKAGE_NAME=%1
  SET VERSION=%2
  SET UNITY_PATH=%3
  SET PROJECT_PATH=%4

  %UNITY_PATH% -batchmode -quit -projectPath %PROJECT_PATH% -exportPackage Assets\Plugins %PACKAGE_NAME%.unitypackage

  CALL :WAIT_UNITY_PACKAGE_CREATED
  EXIT /B
) ELSE (
  ECHO  概要           : unitypackageの作成をし、作成したunitypackage + READMEファイルのZIPパッケージングを行うスクリプト

  ECHO  使用方法       : sh make_package.sh PackageName Version UnityAppPath ProjectPath

  ECHO  引数:
  ECHO    PackageName  : パッケージ化時のファイル名(例: GamePlugin)
  ECHO    Version      : パッケージバージョン(例: v1.0.0)
  ECHO    UnityAppPath : Unity.appのパス(例: "C:\Program Files\Unity\Editor\Unity.exe")
  ECHO    ProjectPath  : プロジェクトまでのパス(例: "C:\UnityProjects\Project")

  EXIT /B
)

: WAIT_UNITY_PACKAGE_CREATED

IF EXIST "%PROJECT_PATH%\%PACKAGE_NAME%.unitypackage" (
  GOTO :PACKAGE_FUNC
)

GOTO :WAIT_UNITY_PACKAGE_CREATED

: PACKAGE_FUNC

SET PACKAGE_DIR=%CURRENT_DIR%..\package

IF EXIST "%PACKAGE_DIR%" (
  RD /S /Q %PACKAGE_DIR%
)

MD %PACKAGE_DIR%\%PACKAGE_NAME%_%VERSION%

MOVE %PROJECT_PATH%\%PACKAGE_NAME%.unitypackage %PACKAGE_DIR%\%PACKAGE_NAME%_%VERSION%\

XCOPY %CURRENT_DIR%..\SAMPLE_README.md %PACKAGE_DIR%\%PACKAGE_NAME%_%VERSION%

CD %PACKAGE_DIR%\%PACKAGE_NAME%_%VERSION%
..\..\win32\zip\zip.exe -r ..\%PACKAGE_NAME%_%VERSION%.zip SAMPLE_README.md %PACKAGE_NAME%.unitypackage
CD ..\
RD /S /Q %PACKAGE_NAME%_%VERSION%

ECHO "%PACKAGE_NAME%のパッケージ化が完了しました。"

EXIT /B
