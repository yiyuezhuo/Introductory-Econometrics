# -*- coding: utf-8 -*-
"""
Created on Tue Jan 19 08:51:20 2016

@author: yiyuezhuo
"""

import pandas as pd
import statsmodels.api as sm
import os
import re
import numpy as np

from patsy import dmatrices

#data=pd.read_excel("data set\\gpa2.xls")
def parse_des(s):
    sl=s.split("\n")
    status='filename'
    result={'name':None,'header':[],'Obj number':None,'des':[]}
    header=[]
    for ss in sl:
        if status=='filename':
            if ss.strip()!='':
                result['name']=ss
            else:
                status='header'
        elif status=='header':
            if ss.strip()!='':
                header.extend([w for w in ss.split(' ') if w!=''])
            else:
                result['header']=header
                status='Obs number'
        elif status=='Obs number':
            if ss.strip()!='':
                result['Obj number']=ss.strip()
            else:
                status='des'
        elif status=='des':
            if ss.strip()!='':
                result['des'].append(ss)
                #result['des'].append(ss.strip())
            else:
                return result
    return result
def enhence_des(result):
    obj={}
    obj['name']=result['name']
    obj['header']=result['header']
    obj['des']={}
    r=re.search(r'\d+',result['Obj number'])
    obj['Obj number']=int(r.group())
    des_pattern2=r'(\s|\d)(\s|\d)(\d)\. (\w+)( )(.+)'
    for des in result['des']:
        rm=re.match(des_pattern2,des)
        if rm!=None:
            rr=rm.groups()
            iid=int(rr[0]+rr[1]+rr[2])
            name=rr[3]
            d=rr[5]
            obj['des'][name]={'id':iid,'name':name,'des':d}
    return obj
def load_data(file_name):
    DES_name=file_name.upper()+'.DES'
    xls_name=file_name.lower()+'.xls'
    des_f=open('data set\\'+DES_name)
    des_s=des_f.read()
    des_f.close()
    des=enhence_des(parse_des(des_s))
    table=pd.read_excel('data set\\'+xls_name,header=None)
    table.columns=des['header']
    return table
    
def regress(formula,file_name,summary=True):
    table=load_data(file_name)
    table=table.applymap(lambda x:x if x!='.' else np.NaN)
    y, X = dmatrices(formula, data=table, return_type='dataframe')
    mod=sm.OLS(y,X)
    res=mod.fit()
    if summary:
        print res.summary()
    return res
    
def get_data(y_head,X_head,file_name,transform={}):
    table=load_data(file_name)
    table_sub=table[[y_head]+X_head]
    table_sub=table_sub.applymap(lambda x:x if x!='.' else np.NaN).dropna()
    new_cols=[transform[i].__name__+' '+i if transform.has_key(i) else i for i in table_sub.columns]
    for old_name,t_func in transform.items():
        table_sub[old_name]=t_func(table_sub[old_name])
    table_sub.columns=new_cols
    return table_sub
        

    
def regress_h(y_head,X_head,file_name,summary=True):
    table=load_data(file_name)
    table_sub=table[[y_head]+X_head]
    table_sub=table_sub.applymap(lambda x:x if x!='.' else np.NaN).dropna()
    y,X=table_sub[y_head],table_sub[X_head]
    X=sm.add_constant(X)
    mod=sm.OLS(y,X)
    res=mod.fit()
    if summary:
        print res.summary()
    return res

    
            
'''
words='sat    tothrs    colgpa    athlete   verbmath  hsize     hsrank    hsperc    female    white    black    hsizesq'
word=[w.strip() for w in words.split() if w!='']
word_map={word[i]:i for i in range(len(word))}
head_w=['hsperc','sat']
head=[word_map[h] for h in head_w]

#data=pd.read_excel("data set\\gpa2.xls",header=word)
data=pd.read_excel("data set\\gpa2.xls",header=None)
data.columns=word

y, X = dmatrices('colgpa ~ hsperc + sat', data=data, return_type='dataframe')

mod=sm.OLS(y,X)
res=mod.fit()
print res.summary()
'''