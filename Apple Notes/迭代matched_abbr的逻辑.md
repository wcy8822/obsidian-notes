**1. 字段定义**
**matched_abbr 字段表示通过模糊匹配算法**

**从`简称`中识别出`品牌名`，用于关联品牌映射表和确定客户等级。**





路径：/Users/didi/Downloads/panth/tag_ct/kacka/标签CKA清洗数据_20250731_115509/分析专用数据_20250731_115529.csv
字段名如下

| province_name_0714 | city_id | city_name | store_id | store_name | party_first_name | cleaned_party_name | cleaned_keywords | matched_abbr | confidence | <span style="font-family:.PingFangUITextSC-Regular;">主营</span>/非主营 | KA/CKA/小散 | <span style="font-family:.PingFangUITextSC-Regular;">品牌名</span> | actual_controller | coop_station_cnt | is_coop_station_cnt_valid | <span style="font-family:.PingFangUITextSC-Regular;">最终客户等级</span> | <span style="font-family:.PingFangUITextSC-Regular;">分类层级</span> | suggested_abbr | is_controller_matched | is_dirty | store_level_mtd_v2 | order_cnt_mtd | is_overlap |
| -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |


数据清洗需求：
1.<span style="font-family:.PingFangUITextSC-Regular;">重新计算，</span>

| <span style="font-family:.PingFangUITextSC-Regular;">主营</span>/非主营 | KA/CKA/小散 | <span style="font-family:.PingFangUITextSC-Regular;">品牌名</span> | actual_controller | coop_station_cnt | is_coop_station_cnt_valid | <span style="font-family:.PingFangUITextSC-Regular;">最终客户等级</span> | <span style="font-family:.PingFangUITextSC-Regular;">分类层级</span> |
| -- | -- | -- | -- | -- | -- | -- | -- |
|  |  |  |  |  |  |  |  |



2.计算逻辑：
<span style="font-family:.PingFangUITextSC-Regular;">对照数据，</span> 'mapping_table_path': '/Users/didi/Downloads/panth/tag_ct/kacka/分类验证与品牌对照表.xlsx',
<span style="font-family:.PingFangUITextSC-Regular;">包含字段如下，</span>

| <span style="font-family:.PingFangUITextSC-Bold;"><b>简称</b></span>**_id** | <span style="font-family:.PingFangUITextSC-Bold;"><b>简称</b></span> | <span style="font-family:.PingFangUITextSC-Bold;"><b>主营</b></span>**/非主营** | **KA/CKA/小散** | <span style="font-family:.PingFangUITextSC-Bold;"><b>品牌名</b></span> |
| -- | -- | -- | -- | -- |



1.<span style="font-family:.PingFangUITextSC-Regular;">用</span>matched_abbr<span style="font-family:.PingFangUITextSC-Regular;">和对照表中的</span><span style="font-family:.PingFangUITextSC-Bold;"><b>简称进行匹配，</b></span>	•	匹配优先级实现（精确 > 子串 > 模糊）

<span style="font-family:.PingFangUITextSC-Bold;"><b>2.匹配返回，对照数据中的</b></span>

| <span style="font-family:.PingFangUITextSC-Bold;"><b>主营</b></span>**/非主营** |  | <span style="font-family:.PingFangUITextSC-Bold;"><b>品牌名</b></span> |
| -- | -- | -- |


替换原表中的相同字段和数据
<span style="font-family:.PingFangUITextSC-Regular;">主营</span>/非主营：
- 1.
来源 ：品牌对照表（ 分类验证与品牌对照表.xlsx ）
- 2.
逻辑 ：

- 当品牌匹配成功（ matched_abbr 非空），从对照表中获取对应值
- 当匹配失败或对照表中无对应值，默认填充为'非主营'

<span style="font-family:.PingFangUITextSC-Bold;"><b>品牌名：</b></span>
- 1.
来源 ：品牌对照表（ 分类验证与品牌对照表.xlsx ）
- 2.
逻辑 ：

- 当品牌匹配成功（ matched_abbr 非空），从对照表中获取对应值
- 当匹配失败或对照表中无对应值，默认填充为’其他’

.KA/CKA/小散 字段产出逻辑
- 1.
<span style="font-family:.PingFangUITextSC-Regular;">计算逻辑</span> （ Classifier.classify_data ）：
- 如果 主营/非主营 == '主营' → 'KA'
- 否则，如果 coop_station_cnt （合作油站数量）>= 10 → 'CKA'
- 否则 → '小散'

 coop_station_cnt 的逻辑
1.计算matched_abbr 的分组下，去重统计store_id数量
	a.当matched_abbr 的值实际意义，比如空值 其他 等，赋值默认1
	b.否则，去重统计store_id数量
	
<span style="font-family:.PingFangUITextSC-Regular;">分类层级的逻辑</span>

<span style="font-family:.PingFangUITextSC-Regular;">主营</span>/非主营和KA/CKA/小散和品牌 字段的值组合起来，用>关联 比如 主营>KA>中国石化




1. 确认 Excel 对照表格（分类验证与品牌对照表.xlsx）的格式和数据完整性，确认
2. 确认是否需要处理特殊字符或异常值，是的
    关键处理：以字符串形式读取store_id，避免科学计数法
        """
        try:
            # 以字符串形式读取store_id，避免科学计数法
            self.raw_data = pd.read_excel(self.raw_data_path, sheet_name='在线', dtype={'store_id': str})
            
            # 清洗store_id格式：移除引号、空格等特殊字符
            self.raw_data['store_id'] = self.raw_data['store_id'].apply(
                lambda x: re.sub(r'["\'\s]', '', str(x)) if pd.notna(x) else x
            )
            
            logger.info(f"原始数据加载成功，共{len(self.raw_data)}条记录")
            logger.info(f"原始数据列名: {list(self.raw_data.columns)}")

1. 提供清洗后数据的保存路径和格式要求:
保存到原路径，保存成csv，文件名+时间戳（到分秒）

1. 确认是否需要保留原始字段或仅保留清洗后的字段：保留原字段，清洗后的字段+已清洗，已清洗是后缀，比如品牌名_已清洗


仔细确认需求，评估方案，需要我的输入分配为我的todo，给出你的计划方案。跟我交互拉齐，待我完全确认后，我将回复“确认，请开始”，你在开始将需求转化为具体的代码编写。