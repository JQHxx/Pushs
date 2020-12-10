#!/usr/bin/python
#coding:utf-8
import hashlib
import json
import time

def md5(s):
    m = hashlib.md5(s)
    return m.hexdigest()

device_token = '' # 'device_tokens': device_token,
appkey = '5f98d74333bd1851f689337d'
app_master_secret = 'gdrpscfknbygbgnsx0abs6baeisd4lig'
timestamp = int(time.time()*1000)
method = 'POST'
url = 'http://msg.umeng.com/api/send'
params = {"production_mode":"false","payload":{"display_type":"notification","aps":{"alert":{"title":"标题"}},"body":{"title":"你好","after_open":"go_app","ticker":"Hello World","text":"来自友盟推送"}},"timestamp":timestamp,"appkey":appkey,"device_tokens":"","type":"broadcast"}
post_body = json.dumps(params)
print post_body
sign = md5('%s%s%s%s' % (method,url,post_body,app_master_secret))
print sign
