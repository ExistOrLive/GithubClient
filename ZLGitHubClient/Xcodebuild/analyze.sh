#!/bin/bash
# 静态分析 脚本

xcodebuild clean 

rm -rf Xcodebuild/analyze

analyzeDirPath="Xcodebuild/analyze/`date +"%Y-%m-%d"`" 
mkdir -p $analyzeDirPath

# xcodebuild analyze 分析工程代码 输出compile_commands.json
xcodebuild analyze -workspace ZLGitHubClient.xcworkspace -scheme ZLGitHubClient | tee  $analyzeDirPath"/analyze.log" | xcpretty --report json-compilation-database -o $analyzeDirPath'/compile_commands.json'

# oclint-json-compilation-database 分析 compile_commands.json 输出报告
oclint-json-compilation-database  -p $analyzeDirPath -- -report-type pmd -o $analyzeDirPath'/report.html'

# 删除中间文件
#rm $analyzeDirPath'/compile_commands.json'