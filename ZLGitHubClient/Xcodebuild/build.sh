#!/bin/bash

timer_start=`date "+%Y-%m-%d %H:%M:%S"`
echo "start at "$timer_start" ............................................."

# 清空创建必要的构建目录
echo "clean and create nessary dir ............................................."

archiveDirPath="Xcodebuild/archive/`date +"%Y-%m-%d"`"
exportDirPath="Xcodebuild/ipa/`date +"%Y-%m-%d"`"
mkdir -p $archiveDirPath
mkdir -p $exportDirPath

# 开始打包
echo "start archive ....................."
archivePath=$archiveDirPath"/ZLGithubClient`date +"%Y-%m-%d-%H:%M:%S"`.xcarchive"
xcodebuild archive -workspace ZLGitHubClient.xcworkspace -scheme ZLGitHubClient -archivePath $archivePath | xcpretty -r html 
echo "end archive ....................."

# 签名
echo "start sign ....................."
if [ $1 = adhoc ]
then
    echo "adhoc build" 
    xcodebuild -exportArchive -allowProvisioningUpdates true -archivePath $archivePath -exportPath $exportDirPath -exportOptionsPlist "Xcodebuild/adhoc.plist" | xcpretty -r html 
elif [ $1 = debug ]
then 
    echo "testflight build"
    xcodebuild -exportArchive -allowProvisioningUpdates true -archivePath $archivePath -exportPath $exportDirPath -exportOptionsPlist "Xcodebuild/debug.plist" | xcpretty -r html 
elif [ $1 = release ]
then 
    echo "release build"
    xcodebuild -exportArchive -allowProvisioningUpdates true -archivePath $archivePath -exportPath $exportDirPath -exportOptionsPlist "Xcodebuild/debug.plist" | xcpretty -r html 
fi
echo "end sign and export ....................."

timer_end=`date "+%Y-%m-%d %H:%M:%S"`
start_seconds=$(date -date="$timer_start" +%s);
end_seconds=$(date -date="$timer_end" +%s);
duration=$((end_seconds-start_seconds))

echo "end at "$timer_end" elapsetime "$duration"s..............................."

