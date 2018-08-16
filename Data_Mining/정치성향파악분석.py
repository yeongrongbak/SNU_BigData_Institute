
# coding: utf-8

# # ▣ 비즈니스 데이터마이닝 Final Exam
# 
# ### 문제 3.
# 
# ### 정치 성향 분류 문제
# 
# ## 1. 서론
# 
# ### 1) 분석 목표
# 
# 사람들의 인구통계학적 정보와 설문 조사 정보를 활용하여 정치 성향을 파악하고 정확히 분류하는 것
# 
# ### 2) 분석에 사용한 데이터
# 
# 설문에 참여한 사람들의 데이터 1054개를 활용하였다. 성별, 나이 지역, 최종학력, 소득 등의 인구통계학적 정보와
# 
# 진보적 성향 또는 보수적 성향을 파악할 수 있는 설문 10개에 대한 정보가 들어 있으며,
# 
# 자신이 어느정도 진보적인지 보수적인지 응답한 변수인 ideo_self가 주어진 899개의 데이터를 활용하여
# 
# ideo_self 값이 주어지지 않은 155명의 ideo_self를 예측하는 것이 최종적인 목표이다.
# 
# (※ 모든 값이 NA값을 가지는 관측치 1개는 제거한 후 분석을 시작하였다.)
# 
# ### 2. 본론
# 
# ### 1) 분석 방법 소개
# 
# 정확한 분류를 위해 사용한 분석 방법은 아래와 같다.
# 
# #### ① Logistic regression
# #### ② Random forest
# #### ③ SVM
# #### ④ SoftMax

# ### 2) 데이터 전처리 과정

# In[1]:

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


# In[2]:

data = pd.read_excel('data1.xlsx', header = 1)


# In[3]:

data.head()


# In[4]:

# data = data.set_index("id").sort_index()
data = data.set_index("id")


# In[5]:

data.head(10)


# 데이터 내에 모든 column 값이 NA인 값을 걸러준다. 

# In[6]:

data = data.dropna(how="all")


# In[7]:

data.shape


# In[8]:

pd.set_option('display.width', 100)  # 결과물을 잘 보여주기 위한 옵션, column 숫자를 표현한 것 같다. 10 단위로
pd.set_option('precision', 3)        # 결과물을 잘 보여주기 위한 옵션, 숫자 소수점 표현하는 것 
data.head()


# In[9]:

data.describe()


# In[10]:

data.dtypes


# In[11]:

data.info()


# In[12]:

data.isnull()


# NA 값들을 추측하기 위한 데이터를 잡아준다. 

# In[13]:

# k 질문들만 잡고 NA 값 추측
# x_impute = data.values[:,7:-1]

# 전체 데이터 잡고 NA값 추측 
x_impute = data.values[:,:-1]

pd.DataFrame(x_impute).isnull().any()


# In[14]:

x_impute.shape


# * 결측치를 채워주기 위해 KNN, SoftImpute, SimpleFill, MICE 4개의 imputer를 활용했다.

# In[15]:

from fancyimpute import (
    KNN,
    SoftImpute,
    MICE
)


# 최종적으로 MICE imputer로 missing Value를 처리했다. 

# In[16]:

x_impute_filled = MICE().complete(x_impute)


# In[17]:

x_impute_filled.shape


# In[18]:

pd.DataFrame(x_impute_filled).isnull().any()


# In[19]:

array = data.values

# 전체 데이터를 잡고 NA값 찾는 방법
array[:,:-1].shape


# In[20]:

array[:, :-1] = x_impute_filled


# In[21]:

pd.DataFrame(array).isnull().any()


# In[22]:

data.head(10)


#  Impute 된 값이 확률로 나왔기 때문에 0.5 이상의 값은 1로 대체하고 0.5 이하의 값은 0으로 대체해준다. 

# In[23]:

for i in range(0, 1054):
    for j in range(0, 10):
        if np.any(array[:, 7:-1][i][j] >= 0.5):
            array[:, 7:-1][i][j] = 1
        else:
            array[:, 7:-1][i][j] = 0


# In[24]:

data.isnull().any()


# 확률로 된 Impute 값이 아닌 0 과 1 로 구성된 값을 볼 수 있다. 

# In[25]:

data.head()


# class 별 Ideo_self의 분포를 확인해보았다.

# In[26]:

ideo_self_counts = data.groupby('ideo_self').size()
ideo_self_counts


# In[328]:

data.head()


# * 범주형 변수 인코딩

# In[32]:

Sex_dummies = pd.get_dummies(data.sex, prefix = 'sex')
Sex_dummies.sample(n = 10)


# In[33]:

Age_dummies = pd.get_dummies(data.age, prefix = 'age')
Age_dummies.sample(n = 10)


# In[34]:

Area_dummies = pd.get_dummies(data.area, prefix = 'area')
Area_dummies.sample(n = 10)


# In[35]:

Edu_dummies = pd.get_dummies(data.edu, prefix = 'education')
Edu_dummies.sample(n = 10)


# In[36]:

Income_dummies = pd.get_dummies(data.income, prefix = 'income')
Income_dummies.sample(n = 10)


# In[37]:

k2_dummies = pd.get_dummies(data.k2, prefix = 'k2')
k2_dummies.sample(n = 10)


# In[38]:

k3_dummies = pd.get_dummies(data.k3, prefix = 'k3')
k3_dummies.sample(n = 10)


# In[39]:

k4_dummies = pd.get_dummies(data.k4, prefix = 'k4')
k4_dummies.sample(n = 10)


# In[40]:

k6_dummies = pd.get_dummies(data.k6, prefix = 'k6')
k6_dummies.sample(n = 10)


# In[41]:

k7_dummies = pd.get_dummies(data.k7, prefix = 'k7')
k7_dummies.sample(n = 10)


# In[42]:

k8_dummies = pd.get_dummies(data.k8, prefix = 'k8')
k8_dummies.sample(n = 10)


# In[43]:

k10_dummies = pd.get_dummies(data.k10, prefix = 'k10')
k10_dummies.sample(n = 10)


# In[44]:

k12_dummies = pd.get_dummies(data.k12, prefix = 'k12')
k12_dummies.sample(n = 10)


# In[45]:

k13_dummies = pd.get_dummies(data.k13, prefix = 'k13')
k13_dummies.sample(n = 10)


# In[46]:

k14_dummies = pd.get_dummies(data.k14, prefix = 'k14')
k14_dummies.sample(n = 10)


# Dummy Variable로 변경된 variables를 Data set에 추가해주고 그 파일 이름을 new_data라고 칭한다. 

# In[47]:

new_data = pd.concat([data,  Sex_dummies, Age_dummies, Area_dummies, Edu_dummies, Income_dummies, k2_dummies, k3_dummies, k4_dummies, k6_dummies, k7_dummies, k8_dummies, k10_dummies, k12_dummies, k13_dummies, k14_dummies], axis = 1)
new_data.head(10)


# Dummy variable로 이미 변경된 variables들은 더 이상 필요하지 않기 때문에 new_data set에서 제거해준다. 

# In[48]:

new_data = new_data.drop(['age', 'birth', 'area', 'sex', 'age1','edu', 'income','k2','k3','k4','k6','k7','k8','k10','k12','k13','k14'], axis = 1)
new_data.head(10)


# New_data에서 Ideo_self의 값이 NA인 row가 ID Number 24 부터이기 때문에 NA 값인 rows들을 따로 분류해준다. 

# In[49]:

new_data[24:]


# New_data의 ID Number 24 부터는 모두 NA 값이 포함되어 있는 것을 볼 수 있다. 

# In[50]:

new_data[24:].ideo_self.isnull()


# Ideo_self의 NA 값을 기준으로 Train data와 Test data를 나눠준다. 

# In[51]:

train_data = new_data[:199]
test_data = new_data[24:]


# In[52]:

train_data.head()


# In[53]:

test_data.head()


# Train Data를 X와 Y를 나눠주기 위해 Train data의 columns 이름과 갯수를 확인한다. 

# In[54]:

# 변수명 가져오기
col_names = train_data.columns.values


# In[55]:

# Ideo_self column은 첫 번째 column이다. 
col_names[:1]


# In[56]:

# Ideo_self를 기준으로 X와 Y를 나눠준다. 
train_X = train_data[col_names[1:]]
train_Y = train_data[col_names[:1]]


# In[57]:

train_X.head(5)


# In[58]:

train_Y.head()


# Test data의 columns 이름과 갯수를 확인

# In[59]:

# 변수명 가져오기
col_names = test_data.columns.values


# In[60]:

# Ideo_self column은 첫 번째 column이다. 
col_names[:1]


# In[61]:

# Ideo_self를 기준으로 X와 Y를 나눠준다. 
test_X = test_data[col_names[1:]]
test_Y = test_data[col_names[:1]]


# In[62]:

test_X.head(5)


# In[63]:

test_Y.head(5)


# * 데이터 분할 (Training 70 % + Validation 30%)

# Train set의 X와 Y 값을 array 값으로 변환

# In[64]:

train_X = train_X.values
train_Y = train_Y.values


# In[65]:

# Y 값을 numpy.ravel 함수를 써서 reshape 시켜준다. Return a contiguous flattened array.

train_Y = np.ravel(train_Y)


# In[66]:

train_X


# In[67]:

train_Y


# In[68]:

test_X = test_X.values
test_Y = test_Y.values


# In[69]:

# Y 값을 numpy.ravel 함수를 써서 reshape 시켜준다. Return a contiguous flattened array.

test_Y = np.ravel(test_Y)


# In[70]:

test_X


# In[71]:

test_Y


# Skitlearn library를 통해 Train set을 Train 과 Validataion 으로 나눠준다. 

# In[72]:

from sklearn.model_selection import train_test_split


# In[77]:

train_X_train, train_X_val, train_Y_train, train_Y_val = train_test_split(train_X, train_Y, 
                                                        test_size=0.3, 
                                                        random_state=123)


# In[78]:

# Train, Validation Set의 shape을 확인해준다.

print(train_X_train.shape)
print(train_X_val.shape)
print(train_Y_train.shape)
print(train_Y_val.shape)


# ### 3) 모형 적합
# 
# #### ① Logistic regression
# #### ② Random forest
# #### ③ SVM
# #### ④ SoftMax

# In[79]:

from pprint import pprint
from sklearn import metrics
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.metrics import roc_curve, auc


# ## ① Logistic regression
# 
# parameter penalty, C에 대해 validation data에 대한 Score값과 AUC값을 이용해 최적 모형 parameter를 찾는다. 

# In[80]:

# C가 클수록 weak regularization
penalty_set = ['l1', 'l2']
C_set = [0.1, 1, 10, 1e2, 1e3, 1e4, 1e5, 1e6]


# In[81]:

result1 = []
for penalty in penalty_set:
    for C in C_set:
        logreg_model = LogisticRegression(penalty=penalty, C=C, class_weight='balanced', multi_class="multinomial", solver='saga', max_iter=10000)
        logreg_model = logreg_model.fit(train_X_train, train_Y_train)
#         Y_val_score = model.decision_function(train_X_val)
        Y_val_score = logreg_model.predict_proba(train_X_val)[:, 1]
        val_proba = "{:.4f}".format(logreg_model.score(train_X_val, train_Y_val))
        fpr, tpr, _ = roc_curve(train_Y_val, Y_val_score, pos_label=True)
        result1.append((logreg_model, penalty, C, val_proba, auc(fpr, tpr)))


# In[82]:

result1


# In[83]:

logreg_result = sorted(result1, key=lambda x: x[3], reverse=True)


# In[84]:

logreg_result


# Best Result에 대해 보여준다. 

# In[85]:

best_logreg_result = logreg_result[0]
print(best_logreg_result)


# * Best Model의 MAE 

# In[86]:

best_logreg_model = best_logreg_result[0]
best_logreg_model = best_logreg_model.fit(train_X_train, train_Y_train)
print(metrics.mean_absolute_error(best_logreg_model.predict(train_X_val), train_Y_val))


# In[87]:

# predict_proba 결과 중 앞부분 6개에 대해서만 확인한다.
print("예측 확률:\n{}".format(best_logreg_model.predict_proba(train_X_val)[:6]))

# 행 방향으로 확률을 더하면 모두 1이 된다.
print("합: {}".format(best_logreg_model.predict_proba(train_X_val)[:6].sum(axis=1)))


# * predict_proba의 결과에 argmax 함수를 적용해서 예측 재연

# In[88]:

print("가장 큰 예측 확률의 인덱스:\n{}".format(np.argmax(best_logreg_model.predict_proba(train_X_val), axis=1)))
print("예측:\n{}".format(best_logreg_model.predict(train_X_val)))


# In[146]:

print("훈련 데이터에 있는 클래스 종류: {}".format(best_logreg_model.classes_))
argmax_dec_func = np.argmax(best_logreg_model.decision_function(train_X_train), axis=1)
print("가장 큰 결정 함수의 인덱스: {}".format(argmax_dec_func[:10]))
print("인덱스를 classses_에 연결: {}".format(best_logreg_model.classes_[argmax_dec_func][:10]))
print("Validation set의 예측: {}".format(best_knn_model.predict(train_X_val)[:10]))
print("실제 Validation set: {}".format(train_Y_val[:10]))
print("Validation Set의 정확도: {:.2f}".format(best_logreg_model.score(train_X_val, train_Y_val)))
print("Test set의 예측: {}".format(best_logreg_model.predict(test_X)[:10]))


# ## ② Random forest
# 
# parameter n_estimators 와 max_features 에 대해 validation data에 대한 Score값과 AUC값을 이용해 최적 모형 parameter를 찾는다. 
# 

# In[132]:

n_estimators_set = [40, 60, 90, 100, 1000, 2000, 5000]
max_depth_set = [3, 4, 5, 6, 7]
max_features_set = ['auto', 'sqrt', 'log2']


# In[133]:

result5 = []
for n_estimators in n_estimators_set:
    for max_features in max_features_set:
        for max_depth in max_depth_set:
            rf_model = RandomForestClassifier(n_estimators=n_estimators, max_depth=max_depth, max_features=max_features, random_state=0)
            rf_model = rf_model.fit(train_X_train, train_Y_train)
            Y_val_score = rf_model.predict_proba(train_X_val)[:, 1]
            val_proba = "{:.4f}".format(rf_model.score(train_X_val, train_Y_val))
            fpr, tpr, _ = roc_curve(train_Y_val, Y_val_score, pos_label=True)
            result5.append((rf_model, n_estimators, max_features, max_depth, val_proba, auc(fpr, tpr)))


# In[151]:

rf_result = sorted(result5, key=lambda x: x[4], reverse=True)


# In[152]:

rf_result


# * Best Result

# In[153]:

best_rf_result = rf_result[0]
print(best_rf_result)


# * Best Model의 MAE 

# In[154]:

best_rf_model = best_rf_result[0]
best_rf_model = best_rf_model.fit(train_X_train, train_Y_train)
print(metrics.mean_absolute_error(best_rf_model.predict(train_X_val), train_Y_val))


# In[155]:

# predict_proba 결과 중 앞부분 6개에 대해서만 확인한다.
print("예측 확률:\n{}".format(best_rf_model.predict_proba(train_X_val)[:6]))

# 행 방향으로 확률을 더하면 모두 1이 된다.
print("합: {}".format(best_rf_model.predict_proba(train_X_val)[:6].sum(axis=1)))


# * predict_proba의 결과에 argmax 함수를 적용해서 예측 재연 

# In[156]:

print("가장 큰 예측 확률의 인덱스:\n{}".format(np.argmax(best_rf_model.predict_proba(train_X_val), axis=1)))
print("예측:\n{}".format(best_rf_model.predict(train_X_val)))


# In[159]:

print("훈련 데이터에 있는 클래스 종류: {}".format(best_rf_model.classes_))
print("Validation set의 예측: {}".format(best_rf_model.predict(train_X_val)[:10]))
print("실제 Validation set: {}".format(train_Y_val[:10]))
print("Validation Set의 정확도: {:.2f}".format(best_rf_model.score(train_X_val, train_Y_val)))
print("Test set의 예측: {}".format(best_logreg_model.predict(test_X)[:10]))


# ## ③ SVM
# 

# In[161]:

gamma_set = [0.001, 0.01, 0.1, 1, 10, 100]
c_set = [0.001, 0.01, 0.1, 1, 10, 100]


# In[162]:

result6 = []
for gamma in gamma_set:
    for C in c_set:
        svm_model = SVC(decision_function_shape='ovo', gamma=gamma, C=C, probability = True, max_iter=10000)
        svm_model = svm_model.fit(train_X_train, train_Y_train)
        Y_val_score = svm_model.predict_proba(train_X_val)[:, 1]
        val_proba = "{:.4f}".format(svm_model.score(train_X_val, train_Y_val))
        fpr, tpr, _ = roc_curve(train_Y_val, Y_val_score, pos_label=True)
        result6.append((svm_model, gamma, C,val_proba, auc(fpr, tpr)))


# In[163]:

svm_result = sorted(result6, key=lambda x: x[3], reverse=True)


# In[164]:

svm_result


# * Best Result

# In[165]:

best_svm_result = svm_result[0]
print(best_svm_result)


# * Best Model의 MAE

# In[166]:

best_svm_model = best_svm_result[0]
best_svm_model = best_svm_model.fit(train_X_train, train_Y_train)
print(metrics.mean_absolute_error(best_svm_model.predict(train_X_val), train_Y_val))


# In[167]:

# predict_proba 결과 중 앞부분 6개에 대해서만 확인한다.
print("예측 확률:\n{}".format(best_svm_model.predict_proba(train_X_val)[:6]))

# 행 방향으로 확률을 더하면 모두 1이 된다.
print("합: {}".format(best_svm_model.predict_proba(train_X_val)[:6].sum(axis=1)))


# * predict_proba의 결과에 argmax 함수를 적용해서 예측을 재연

# In[168]:

print("가장 큰 예측 확률의 인덱스:\n{}".format(np.argmax(best_svm_model.predict_proba(train_X_val), axis=1)))
print("예측:\n{}".format(best_svm_model.predict(train_X_val)))


# In[171]:

print("훈련 데이터에 있는 클래스 종류: {}".format(best_svm_model.classes_))
argmax_dec_func = np.argmax(best_svm_model.decision_function(train_X_val), axis=1)
print("가장 큰 결정 함수의 인덱스: {}".format(argmax_dec_func[:10]))
print("Validation set의 예측: {}".format(best_svm_model.predict(train_X_val)[:10]))
print("실제 Validation set: {}".format(train_Y_val[:10]))
print("Validation Set의 정확도: {:.2f}".format(best_svm_model.score(train_X_val, train_Y_val)))
print("Test set의 예측: {}".format(best_logreg_model.predict(test_X)[:10]))


# ## ④ SoftMax

# In[273]:

nb_classes = 11  # 0 ~ 10


# In[274]:

X = tf.placeholder(tf.float32, [None, 15])
Y = tf.placeholder(tf.int32, [None, 1])  # 0 ~ 10


# In[275]:

Y_one_hot = tf.one_hot(Y, nb_classes)  # one hot
print("one_hot", Y_one_hot)


# In[276]:

Y_one_hot = tf.reshape(Y_one_hot, [-1, nb_classes])
print("reshape", Y_one_hot)


# In[277]:

W = tf.Variable(tf.random_normal([15, nb_classes]), name='weight')
b = tf.Variable(tf.random_normal([nb_classes]), name='bias')


# In[278]:

# tf.nn.softmax computes softmax activations
# softmax = exp(logits) / reduce_sum(exp(logits), dim)
logits = tf.matmul(X, W) + b
hypothesis = tf.nn.softmax(logits)


# In[279]:

# Cross entropy cost/loss
cost_i = tf.nn.softmax_cross_entropy_with_logits(logits=logits,
                                                 labels=Y_one_hot)
cost = tf.reduce_mean(cost_i)
optimizer = tf.train.GradientDescentOptimizer(learning_rate=0.1).minimize(cost)

prediction = tf.argmax(hypothesis, 1)
correct_prediction = tf.equal(prediction, tf.argmax(Y_one_hot, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))


# In[304]:

# Launch graph
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    result8=[]
    for step in range(50000):
        sess.run(optimizer, feed_dict={X: x_data, Y: y_data})
        if step % 100 == 0:
            loss, acc = sess.run([cost, accuracy], feed_dict={
                                 X: x_data, Y: y_data})
            result8.append([hypothesis, step, loss, acc])
            print("Step: {:5}\tLoss: {:.3f}\tAcc: {:.2%}".format(step, loss, acc))

    # Let's see if we can predict
    pred = sess.run(prediction, feed_dict={X: x_data})
    # y_data: (N,1) = flatten => (N, ) matches pred.shape
    for p, y in zip(pred, y_data.flatten()):
        print("[{}] Prediction: {} True Y: {}".format(p == int(y), p, int(y)))


# In[305]:

sm_result = sorted(result8, key=lambda x: x[3], reverse=True)


# In[306]:

sm_result


# * Best Result

# In[315]:

best_sm_result = sm_result[:1]
print(best_sm_result)


# In[325]:

test_X.shape


# * 예측한 Y 값

# In[343]:

test_X = np.loadtxt('test_X.csv', delimiter=',', dtype=np.float32)
# Launch graph
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    
    # Let's see if we can predict
    pred = sess.run(prediction, feed_dict={X: test_X})
    # y_data: (N,1) = flatten => (N, ) matches pred.shape
    for p in pred:
        print("Prediction: {} ".format(p))


# ### 3. 결론

# ### 1) 분석 결과
# 
# ### (1) 적합한 모델들의 성능 평가
# 
# ### ① Logistic Regression
# 
#     - MAE: 2.607
#     - Validation Set의 정확도: 0.14
#     - Test set 예측(처음 10개): 8, 10, 1, 8, 7, 10, 8, 0, 1, 9
# 
# 
# ### ② Random Forest
# 
#     - MAE: 1.478
#     - Validation Set의 정확도: 0.35
#     - Test set의 예측(처음 10개): 8, 10, 1, 8, 7, 10, 8, 0, 1, 9
# 
# ### ③ SVM
# 
#     - MAE: 1.415
#     - Validation Set의 정확도: 0.34
#     - Test set의 예측(처음 10개): 8, 10, 1, 8, 7, 10, 8, 0, 1, 9
# 
# 
# ### ④ SoftMax
#    
#     - Validation Set의 정확도: 0.37
#     - Test set의 예측(처음 10개): 3, 3, 4, 4, 4, 4, 3, 4, 4, 3
# 
# 
# ### (2) 성능 평가 결과 정리
# 
#     - 먼저 지도 학습 방법인 Logistic model, RandomForest, SVM을 사용한 결과 Validation Set에서의 정확도가 각각 0.14/0.35/0.34로 Random Forest 방법이 35%의 가장 높은 예측 정확도를 보였다. Random Forest 방법은 다양성을 극대화 하여 예측력이 상당히 우수한 편이고 배깅과 동일하게 붓트스트랩 표본을 이용한 다수의 트리의 예측 결과를 종합하여 의사결정을 진행하기 때문에 안정성도 상당히 높은 방법이므로 다른 분류 방법보다 예측률이 조금 더 높게 나올 수 있다고 생각된다.
#     
#     - 다음으로 비지도 학습 방법인 Softmax 방법을 사용한 결과 Validation Set에서의 정확도가 0.37로 앞서 3개의 모델보다 높은 정확도를 보였다. Softmax 모델의 입력받은 값은  0~1사이의 값으로 모두 정규화되며 출력 값들의 총합은 항상 1이 되는 특성을 가지고 이러한 특성이 조금 더 예측 값들을 정확하게 분류하게 만들어 준 원인으로 판단된다.
#     
#     - 따라서 Softmax방법으로 test set의 ideo_self에 값을 부여한 뒤 test_answer.csv로 파일을 저장하였다.
#     (Sheet에서 가장 오른쪽 열에 해당하는 값이 ideo_self에 대한 예측 값이다.)
#     
# ### 3) 분석의 한계점
# 
#     - 분석에서의 한계점은 데이터 셋의 크기가 작은 편에 속하기 때문에 Training set과 Validation set 등을 나누고 나면 더욱 그 set의 크기가 작아져서 더 정확한 training이 힘들었을 것으로 판단된다. 따라서 이러한 점을 보완하고 분석의 정확도를 더 높이기 위해선 데이터를 더욱 많이 확보하여 반복적인 training으로 test set에 대한 예측률을 더욱 증대시킬 수 있을 것이라고 생각한다.
