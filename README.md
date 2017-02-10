## UnityPackager

#### 概要

.unitypackageの自動生成＋READMEやその他ファイル等のパッケージ化を行うスクリプト。  
パッケージ化はZIPを使用します。  
OSX/Windows両方で動作します。  
Windows環境の場合は同梱のZIP.exeが使用されるので、追加インストールは不要です。  

unitypackageに追加で必要なツールやREADME等のファイルを入れたいような場合に使えます。  

#### 使用方法

```
# sh make_package.sh PackageName Version UnityAppPath ProjectPath
$ sh make_package.sh GamePlugin v1.0 /Applications/Unity/Unity.app ~/UnityProjects/AppProject

# ./make_package.bat PackageName Version UnityAppPath ProjectPath
$ ./make_package.bat GamePlugin v1.0 "C:\Program Files\Unity\Editor\Unity.exe" "C:\UnityProjects\Project"
```

現状だと、指定したProjectPathのAssets/Plugins以下＋SAMPLE_READMEをパッケージ化します。  
なので、ご自分の環境に合わせて必要なファイルのパスの追加や.unitypackage化対象のパスの変更をお願いします。  

#### 出力結果

UnityPackager/package以下にProjectName_Version.zipというファイルが出力されます。  
