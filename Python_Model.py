# -*- coding: utf-8 -*-
"""
Created on Sun Jul 12 23:50:17 2015

@author: Pavitrakumar
"""

import os
os.chdir("E:\Anlytics Vidya - Hackathon")
import pandas as pd
import numpy as np
from sklearn import linear_model, decomposition
from sklearn.pipeline import Pipeline
from sklearn.grid_search import GridSearchCV

train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv') 
col = list(train.columns.values)
col = [x.strip(' ') for x in col]
train.columns = col
col = list(test.columns.values)
col = [x.strip(' ') for x in col]
test.columns = col
idx = test.id.values.astype(int)
train = train.drop('id', axis=1)
test = test.drop('id', axis=1) 

#converting catagorical to numerical

b, c = np.unique(train.Day_of_publishing, return_inverse=True)
train.Day_of_publishing = c+1

b, c = np.unique(test.Day_of_publishing, return_inverse=True)
test.Day_of_publishing = c+1

b, c = np.unique(train.Category_article, return_inverse=True)
train.Category_article = c+1

b, c = np.unique(test.Category_article, return_inverse=True)
test.Category_article = c+1

y = train.shares.values
train = train.drop(['shares'], axis=1) 

regr = linear_model.Ridge (alpha = .5)
pca = decomposition.PCA()
pipe = Pipeline(steps=[('pca', pca), ('linear', regr)])
pca.fit(train)
n_components = [20, 10,15,20,25,35,40,30, 44]
estimator = GridSearchCV(pipe,
                         dict(pca__n_components=n_components))
estimator.fit(train,y)
pred = estimator.predict(test)
submission = pd.DataFrame({"id": idx, "predictions": pred})
submission.to_csv("pythLM.csv", index=False)
