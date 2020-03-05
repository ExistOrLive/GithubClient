#!/bin/bash
# oclint 静态分析 脚本

# clean build cache
#xcodebuild clean -workspace ZLGitHubClient.xcworkspace -scheme ZLGitHubClient 

#rm -rf Xcodebuild/analyze

#analyzeDirPath="Xcodebuild/analyze/`date +"%Y-%m-%d"`" 
#mkdir -p $analyzeDirPath

# xcodebuild analyze 分析工程代码 输出compile_commands.json
#xcodebuild analyze -workspace ZLGitHubClient.xcworkspace -scheme ZLGitHubClient | tee  $analyzeDirPath"/analyze.log" | xcpretty --report json-compilation-database -o $analyzeDirPath'/compile_commands.json'

# oclint-json-compilation-database 分析 compile_commands.json 输出报告
#oclint-json-compilation-database -p $analyzeDirPath -e Pods -v --  -report-type=html -o=$analyzeDirPath'/report.html' 

# 删除中间文件
#rm $analyzeDirPath'/compile_commands.json'

## one issue can not be fixed 

# oclint: Not enough positional command line arguments specified!
#Must specify at least 1 positional argument: See: /usr/local/bin/oclint -help


## infer 静态分析脚本

