# coding: utf-8

# In[1]:


import os 
new_directory = "/Users/didi/Desktop"
os.chdir(new_directory)
os.getcwd()


# In[2]:


import warnings
warnings.filterwarnings('ignore')


# In[3]:


import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np
#这是导入训练数据
data = pd.read_excel("/Users/didi/Downloads/发改委调价.xlsx") 


# In[4]:


#这是训练，不用管
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
models = {}
poly = PolynomialFeatures(degree=2)
for oil_type in data['油品类型'].unique(): 
    oil_data = data[data['油品类型'] == oil_type]
    #oil_data['系数/吨'] = np.where((oil_data['综合变化率'] > -0.01) & (oil_data['综合变化率'] < 0.01), 0, oil_data['系数/吨'])
    X_oil = oil_data[['综合变化率']]
    y_oil = oil_data['系数/吨']
     
    X_poly_oil = poly.fit_transform(X_oil)
 
    poly_reg_oil = LinearRegression()
    poly_reg_oil.fit(X_poly_oil, y_oil)
     
    models[oil_type] = poly_reg_oil
 
formulas = {}
 
for oil_type, model in models.items(): 
    coef = model.coef_
    intercept = model.intercept_
 
    formula = f"系数/吨 = {intercept} + {coef[1]} * 综合变化率 + {coef[2]} * 综合变化率^2"
     
    formulas[oil_type] = formula

formulas


# In[5]:


#可以从这里开始看，这是我们训练好的
columns = ['油品类型', '综合变化率', '系数/吨', '系数/升', '预测调价幅度-吨', '预测调价幅度-升']
df_empty = pd.DataFrame(columns=columns)
oil_types = ['92#(93#)', '95#(97#)', '0#']

synthetic_change_rates = '-0.0071'  # 综合变化率 ，每次在这里输入最新一天的变化率

# 构造数据表
data = []
for oil_type, change_rate in zip(oil_types, synthetic_change_rates):
    row = {
        '油品类型': oil_type, 
        '综合变化率':synthetic_change_rates,
        '系数/吨': None,  # 系数/吨留空
        '系数/升': None,  # 系数/升留空
        '预测调价幅度-吨': None,  # 预测调价幅度-吨留空
        '预测调价幅度-升': None   # 预测调价幅度-升留空
    }
    data.append(row)
df = pd.DataFrame(data)
df


# In[6]:


# 将综合变化率列转换为浮点数
df['综合变化率'] = pd.to_numeric(df['综合变化率'], errors='coerce')

# 二次多项式公式
formulas = {
    '92#(93#)': '4782.41093424494 + 487.7508381348447 * 综合变化率 + -5039.2746781931655 * 综合变化率**2',
    '0#': '4603.428069935102 + 461.0991695797703 * 综合变化率 + -7840.58090395578 * 综合变化率**2',
    '95#(97#)': '4782.411350991742 + 487.76651457941216 * 综合变化率 + -5039.241016913767 * 综合变化率**2',
}

actual_vs_predicted = {}
results = []

# 计算系数/吨
for oil_type, formula in formulas.items():
    oil_data = df[df['油品类型'] == oil_type]
    oil_data['系数/吨'] = np.where(
        (oil_data['综合变化率'] >= -0.01) & (oil_data['综合变化率'] <= 0.01),
        0,
        eval(formula.replace('综合变化率', 'oil_data["综合变化率"]'))
    )

    oil_data['预测调价幅度-吨'] = oil_data['综合变化率'] * oil_data['系数/吨']
    
    # 计算系数升，这里四舍五入，保留整数
    if oil_type == '92#(93#)':
        oil_data['系数/升'] = np.round(np.where(
            (oil_data['综合变化率'] >= -0.01) & (oil_data['综合变化率'] <= 0.01),
            0,
            oil_data['系数/吨'] / 1388 * 1.06
        )).astype(int)
    elif oil_type == '95#(97#)':
        oil_data['系数/升'] = np.round(np.where(
            (oil_data['综合变化率'] >= -0.01) & (oil_data['综合变化率'] <= 0.01),
            0,
            oil_data['系数/吨'] / 1388 * 1.12
        )).astype(int)
    elif oil_type == '0#':
        oil_data['系数/升'] = np.round(np.where(
            (oil_data['综合变化率'] >= -0.01) & (oil_data['综合变化率'] <= 0.01),
            0,
            oil_data['系数/吨'] / 1176
        )).astype(int)

    # 计算预测调价幅度-升
    oil_data['预测调价幅度-升'] = np.round(np.where(
        (oil_data['综合变化率'] >= -0.01) & (oil_data['综合变化率'] <= 0.01),
        0,
        oil_data['预测调价幅度-吨'] / (1388 if oil_type in ['92#(93#)', '95#(97#)'] else 1176) * (1.06 if oil_type == '92#(93#)' else 1.12 if oil_type == '95#(97#)' else 1)
    ), 2)
    
    # 添加到结果字典和列表  
    actual_vs_predicted[oil_type] = oil_data
    results.append(oil_data)

# 合并所有油品类型的数据
actual_vs_predicted_df = pd.concat(results)

# 写入Excel文件，直接导出到桌面
with pd.ExcelWriter('发改委调价预测.xlsx') as writer:
    for oil_type, df in actual_vs_predicted.items():
        df.to_excel(writer, sheet_name=oil_type, index=False)


# In[7]:


actual_vs_predicted_df


# In[ ]: