<span style="font-family:.PingFangUITextSC-Regular;">用户需要对现有的</span> Python 脚本``tag_cka_processor7.py`` 进行迭代修改，主要涉及以下几个方面：

1. 增加字段：通过``store_id`` 关联匹配以下字段，并放在最后：
   
   - ``dt_num``
   - ``order_cnt_mtd``
   - ``gmv_mtd``
   - ``profit_mtd``
   - ``gmv_rate_mtd``
   - ``b_fee``
   - ``c_fee``
   - ``actual_take_rate``
   - ``contract_take_rate``
   - ``rate_difference_flag``
   - ``rate_difference_value``
   这些字段存在于``pd.read_excel(self.raw_data_path, sheet_name='经营', dtype={'store_id': str})`` 中。
2. 将缩写的英文字母替换成对应的中文，如 "shell" 改为 "壳牌"。
3. 修改分词逻辑：不要排除 "和顺" 这个客户名。
4. 产出新字段 "简称"，逻辑如下：
   
   - 优先从 sheet_name='1' 中通过关联``party_first_name`` 查找 "简称"，如果找到非空值则使用。
   - 否则，从 sheet_name='在线' 中取``actual_controller`` 的值（排除空值和无意义的值）。
   - 否则，对``party_first_name`` 做关键词提取，提取逻辑与原代码一致，空值留空。
5. 产出新字段``coop_station_cnt_已清洗`` ，逻辑如下：
   
   - 按 "简称a" 分组。
   - 对于空值和无意义的值，赋值为1。
   - 否则，去重统计``store_id`` 的数量。
6.产出新字段 主营/非主营_已清洗		
-按 简称 关联  'mapping_table_path': '/Users/didi/Downloads/panth/tag_ct/kacka/分类验证与品牌对照表.xlsx',中的简称 字段，查询 主营/非主营​，如果找到非空值则使用
-否则，赋值非主营

7.产出新字段 品牌名_已清洗
-按 简称 关联  'mapping_table_path': '/Users/didi/Downloads/panth/tag_ct/kacka/分类验证与品牌对照表.xlsx',中的简称 字段，查询 品牌名，如果找到非空值则使用
-否则，赋值其他
8.产出新字段 KA/CKA/小散_已清洗
-当主营/非主营_已清洗 等于 主营  赋值 KA
-否则，当`coop_station_cnt_已清洗`>10 赋值 CKA
-否则 小散
9.合并6.7.8三个生成新字段，用`>`连接
10.最后在代码的结尾用命名行交互展示  `coop_station_cnt_已清洗`的数据分析，中位数 ，众数，众数(仅统计＞3的数据）



<span style="font-family:.PingFangUITextSC-Regular;">数据源：</span>``pd.read_excel(self.raw_data_path, sheet_name='1', dtype={'简称': str})`` 

<span style="font-family:.PingFangUITextSC-Regular;">字段名称：</span>party_first_name	计数	占比	简称


        # <span style="font-family:.PingFangUITextSC-Regular;">检查</span>sheet1_abbr<span style="font-family:.PingFangUITextSC-Regular;">列是否存在</span>         # 生成新字段'简称'：优先从sheet1中查找，然后从在线表中取actual_controller，最后用suggested_abbr

        if 'sheet1_abbr' in self.raw_data.columns:
            self.raw_data['简称'] = self.raw_data.apply(lambda row: 
                row['sheet1_abbr'] if pd.notna(row['sheet1_abbr']) else 
                row['actual_controller'] if pd.notna(row['actual_controller']) and row['actual_controller'] not in ['无', '未知', '不详'] else 
                row['suggested_abbr'] if pd.notna(row['suggested_abbr']) else '', axis=1)
        else:
            # 如果sheet1_abbr列不存在，则跳过该步骤
            self.raw_data['简称'] = self.raw_data.apply(lambda row: 
                row['actual_controller'] if pd.notna(row['actual_controller']) and row['actual_controller'] not in ['无', '未知', '不详'] else 
                row['suggested_abbr'] if pd.notna(row['suggested_abbr']) else '', axis=1)
            self.logger.warning("未找到sheet1_abbr列，已跳过该列的匹配")


sheet1_abbr,存在这里，
<span style="font-family:.PingFangUITextSC-Regular;">数据源：</span>``pd.read_excel(self.raw_data_path, sheet_name='1', dtype={'简称': str})`` 

<span style="font-family:.PingFangUITextSC-Regular;">字段名称：</span>party_first_name，	计数	，占比	，简称，sheet1_abbr；

<span style="font-family:.PingFangUITextSC-Regular;">无实际意义的定义：</span>[“”，’无’, '其他','未知', '不详']


4. 产出新字段 "sheet1_abbr_yqx”，逻辑如下：
   
   - 优先从 sheet_name='1' 中通过关联``party_first_name`` 查找 "sheet1_abbr"，如果找到非无实际意义的值则使用。
   - 否则，优先从 sheet_name='1' 中通过关联``party_first_name`` 查找 “简称”，如果找到非无实际意义的值则使用。
   - 否则，对``party_first_name`` 做关键词提取，
	—<span style="font-family:.PingFangUITextSC-Regular;">排除</span>,# 停用词列表
        self.STOPWORDS = {'中国',  加油站', '公司', '有限公司', '分公司', '集团', '股份', '责任', '销售', '加油站', '石油', '石化', '能源', '燃料', '油品'}
        self.REGION_STOPWORDS = {'山东', '四川', '江苏', '广东', '北京', '上海', '天津', '重庆', '河北', '河南', '湖北', '湖南', '江西', '浙江', '安徽', '福建', '广东', '海南', '辽宁', '吉林', '黑龙江', '陕西', '山西', '青海', '甘肃', '宁夏', '新疆', '西藏', '云南', '贵州', '广西', '内蒙古'}
—排除,查找%市,%县,%省,%区,这些关键词命中,一并排除%
—提取 %石油,%石化的关键词%
        




输出，

保存到
/Users/didi/Downloads/panth/tag_ct/kacka/
命名abbr清洗+时间戳
字段 party_first_name，sheet1_abbr_yqx