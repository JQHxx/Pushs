#!/usr/bin/python
#coding:utf-8
import  time,random,hashlib,json,urllib2,urllib,sys,os
sys.path.insert(0,os.path.dirname(sys.path[0]))
reload(sys)
sys.setdefaultencoding('utf8')

import requests


def https_request(body, url, content_type=None,version=None, params=None):
    https = requests.Session()
    headers = {}
    headers['user-agent'] = 'umpush-api-python-client'
    headers['connection'] = 'keep-alive'
    headers['content-type'] = 'application/json;charset:utf-8'
    #print url,body
    response = https.request('POST', url, data=body, params=params, headers=headers)
    #合并返回
    return dict(json.loads(response.content) , **{'status_code':response.status_code})

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

requestURL = url + '?sign=' + sign
print https_request(post_body, requestURL)
