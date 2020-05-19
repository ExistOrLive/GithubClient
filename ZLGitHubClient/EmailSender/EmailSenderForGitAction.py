#!/usr/bin/python
# -*- coding: UTF-8 -*-

import smtplib
import sys
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header

sender = 'noreply@existorlive.cn'
senderPwd = sys.argv[1]
receivers = sys.argv[2].split(";")
action_result = sys.argv[3]

if "false" == action_result:

   msgRoot = MIMEMultipart('related')
   msgRoot['From'] = Header("ExistOrLive", 'utf-8')
   msgRoot['To'] = Header("Dev", 'utf-8')
   subject = 'ZLGithubClient build action failed'
   msgRoot['Subject'] = Header(subject, 'utf-8')

   msgAlternative = MIMEMultipart('alternative')
   msgRoot.attach(msgAlternative)

   mail_msg = """
   <p>Github Action: ZLGithubClient Auto Buidl failed</p>
   <p><a href="https://github.com/MengAndJie/GithubClient/actions">build log</a></p>
   """
   msgAlternative.attach(MIMEText(mail_msg, 'html', 'utf-8'))
else:
    msgRoot = MIMEMultipart('related')
    msgRoot['From'] = Header("ExistOrLive", 'utf-8')
    msgRoot['To'] = Header("Dev", 'utf-8')
    subject = 'ZLGithubClient build action Success'
    msgRoot['Subject'] = Header(subject, 'utf-8')

    msgAlternative = MIMEMultipart('alternative')
    msgRoot.attach(msgAlternative)

    mail_msg = """
    <p>Github Action: ZLGithubClient Auto Build Success, Please download newest beta version</p>
    <p><a href="itms-services://?action=download-manifest&url=https://existorlive.github.io/public/GithubClient/CodingArtifacts/manifest.plist">Beta Version</a></p>
    <p><img src="cid:image1"/></p>
    """
    msgAlternative.attach(MIMEText(mail_msg, 'html', 'utf-8'))

    # 指定图片为当前目录
    fp = open('coding.png', 'rb')
    msgImage = MIMEImage(fp.read())
    fp.close()

    # 定义图片 ID，在 HTML 文本中引用
    msgImage.add_header('Content-ID', '<image1>')
    msgRoot.attach(msgImage)


try:
    smtpObj = smtplib.SMTP('smtp.exmail.qq.com')
    smtpObj.login(sender,senderPwd)
    smtpObj.sendmail(sender, receivers, msgRoot.as_string())
    print("邮件发送成功")
except smtplib.SMTPException as e:
    print(str(e))
    print("Error: 无法发送邮件")
