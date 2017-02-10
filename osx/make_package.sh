#!/bin/sh

set -e

function help {
    cat <<EOF
    概要           : unitypackageの作成をし、作成したunitypackage + READMEファイルのZIPパッケージングを行うスクリプト

    使用方法       : sh make_package.sh PackageName Version UnityAppPath ProjectPath

    引数:
      PackageName  : パッケージ化時のファイル名(例: GamePlugin)
      Version      : パッケージバージョン(例: v1.0.0)
      UnityAppPath : Unity.appのパス(例: /Applications/Unity/Unity.app)
      ProjectPath  : プロジェクトまでのパス(例: ~/UnityProjects/Project)
EOF
    exit 1
}

CURRENT_DIR=`dirname $0`

if [ $# != 4 ]; then
  help;
  exit
fi

PACKAGE_NAME=$1
VERSION=$2
UNITY_PATH=$3
PROJECT_PATH=$4
PACKAGE_PATH=${CURRENT_DIR}/../package

# 既存のパッケージディレクトリを削除して新たに作成
if [ -d "${PACKAGE_PATH}" ]; then
  rm -rf ${PACKAGE_PATH}
fi
mkdir -p ${PACKAGE_PATH}/${PACKAGE_NAME}_${VERSION}

# Assets/Plugins以下のファイルを対象にUnityパッケージの作成を行う
${UNITY_PATH}/Contents/MacOS/Unity\
  -batchmode\
  -projectPath ${PROJECT_PATH}\
  -exportPackage Assets/Plugins ${PACKAGE_NAME}.unitypackage\
  -quit\
  ;

# 生成したパッケージをpackage化対象ディレクリに移動させる
mv ${PROJECT_PATH}/${PACKAGE_NAME}.unitypackage ${PACKAGE_PATH}/${PACKAGE_NAME}_${VERSION}

# SAMPLE_READMEファイルをpackage化対象ディレクトリに移動させる
cp ${CURRENT_DIR}/../SAMPLE_README.md ${PACKAGE_PATH}/${PACKAGE_NAME}_${VERSION}

cd ${PACKAGE_PATH}/${PACKAGE_NAME}_${VERSION}

# 不要なファイルを削除
find ./ -name ".DS_Store" -print -exec rm {} ";"

# ZIP化
zip -r ../${PACKAGE_NAME}_${VERSION}.zip SAMPLE_README.md ${PACKAGE_NAME}.unitypackage
cd ../

# 作業スペースは不要なので削除
rm -rf ${PACKAGE_NAME}_${VERSION}

echo "${PACKAGE_NAME}のパッケージ化が完了しました。"
