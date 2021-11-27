#!/usr/bin/python
# -*- coding: UTF-8 -*-

import smtplib
import sys
import os
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header

sender = 'noreply@existorlive.cn'
senderPwd = sys.argv[1]
receivers = sys.argv[2].split(";")
action_result = sys.argv[3]

env_dist = os.environ
workFlow = env_dist.get('GITHUB_WORKFLOW','')
workFlow_run_id = env_dist.get('GITHUB_RUN_ID','')
ref = env_dist.get('GITHUB_REF_NAME','')
trigger_event = env_dist.get('GITHUB_EVENT_NAME','')
sha = env_dist.get('GITHUB_SHA','')
repo_fullname = env_dist.get('GITHUB_REPOSITORY','')

msgRoot = MIMEMultipart('related')
msgRoot['From'] = Header("ExistOrLive", 'utf-8')
msgRoot['To'] = Header("Dev", 'utf-8')

if "false" == action_result:
    subject = 'the workflow' + workFlow + ' of ' + repo_fullname + 'run failed'
else:
    subject = 'the workflow' + workFlow + ' of ' + repo_fullname + 'run successfully'

msgRoot['Subject'] = Header(subject, 'utf-8')
msgAlternative = MIMEMultipart('alternative')
msgRoot.attach(msgAlternative)

repo_url = "https://github.com/" + repo_fullname
commit_url = repo_url + "/" + sha
workflow_run_url = repo_url + "/actions/runs/" + workFlow_run_id

mail_msg = """
   <p>WorkFlow Run Detail</p>
   <p><a href="{commit_url}">{Event}</a> on {ref} triggered workflow {workflow} in <a href="{repo_url}">{repo_Name}</a></p>
   <p>you can view log in <a href="{workflow_run_url}">build log</a></p>
   """.format(subject=subject,event=trigger_event,ref=ref,workFlow=workFlow,repo_url=repo_url,repo_fullname=repo_fullname,workflow_run_url=workflow_run_url,commit_url=commit_url)
msgAlternative.attach(MIMEText(mail_msg, 'html', 'utf-8'))

try:
    smtpObj = smtplib.SMTP('smtp.exmail.qq.com')
    smtpObj.login(sender,senderPwd)
    smtpObj.sendmail(sender, receivers, msgRoot.as_string())
    print("邮件发送成功")
except smtplib.SMTPException as e:
    print(str(e))
    print("Error: 无法发送邮件")
