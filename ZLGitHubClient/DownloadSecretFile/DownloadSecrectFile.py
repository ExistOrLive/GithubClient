#!/usr/bin/python
# -*- coding: UTF-8 -*-
import requests
import sys

def main():

   token = sys.argv[1]

   result = requests.get("https://api.github.com/repos/ExistOrLive/SecretFile/contents/GithubClient/ZLGithubAppKey.h",
                          headers={"Authorization":"token "+token,"Accept":"application/vnd.github.v3.raw+json"})
   if result.status_code == 200 :
       open("ZLGithubAppKey.h",'wb').write(result.content)
       print("ZLGithubAppKey.h download success")
   else :
       print(result)

   result = requests.get("https://api.github.com/repos/ExistOrLive/SecretFile/contents/GithubClient/GoogleService-Info.plist",
                      headers={"Authorization":"token "+token,"Accept":"application/vnd.github.v3.raw+json"})
   if result.status_code == 200 :
       open("GoogleService-Info.plist",'wb').write(result.content)
       print("GoogleService-Info.plist download success")
   else :
       print(result)

if __name__ == '__main__':
    main()

