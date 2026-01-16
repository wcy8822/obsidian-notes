# **商户运营day1**

**会议：**

![[Pasted Graphic 9.png]]



共享资金池

大水池测试都在华中做的测试

审批流+中台
标准：最严格的 安全
KA/CKA by 池子



| <p style="text-align:center;margin:0"><b>B_1363940166509527040</b></p> | <p style="text-align:center;margin:0"><b>B_1363940760179572736</b></p> | <p style="text-align:center;margin:0"><b>B_1364188580230725632</b></p> | <p style="text-align:center;margin:0"><b>B_1364189047854596096</b></p> | <p style="text-align:center;margin:0"><b>B_1364189640613167104</b></p> |
| -- | -- | -- | -- | -- |
| <p style="text-align:center;margin:0">ztjywyc_AD_25Q2_11_B7折立省15元</p> | <p style="text-align:center;margin:0">ztjywyc_AD_25Q2_11_B8折立省10元</p> | <p style="text-align:center;margin:0">ztjywyc_AD_25Q2_11_C9折立省5元</p> | <p style="text-align:center;margin:0">ztjywyc_AD_25Q2_jq_11_C8折立省5元</p> | <p style="text-align:center;margin:0">ztjywyc_AD_25Q2_jq_11_C9折立省3元</p> |



| <p style="text-align:center;margin:0"><b>5919443818810180867</b></p> | <p style="text-align:center;margin:0"><b>5919354354880480810</b></p> | <p style="text-align:center;margin:0"><b>5919356477881976256</b></p> | <p style="text-align:center;margin:0"><b>5919444556751832297</b></p> | <p style="text-align:center;margin:0"><b>5919445081698338275</b></p> |
| -- | -- | -- | -- | -- |



| <p style="text-align:center;margin:0"><b>5914275246093894935</b></p> | <p style="text-align:center;margin:0"><b>5914284726730884329</b></p> | <p style="text-align:center;margin:0"><b>5914285188427285702</b></p> |
| -- | -- | -- |
| <p style="text-align:center;margin:0">ztjywyc_AD_25Q1_11_C7折立省15元</p> | <p style="text-align:center;margin:0">ztjywyc_AD_25Q1_11_C8折立省10元</p> | <p style="text-align:center;margin:0">ztjywyc_AD_25Q1_11_C9折立省5元</p> |


select
    bind_uid
from
    epub_dw.dwd_pub_mkt_coupon_instance_df
where
    dt = '${V_DATE}'
    AND am_batch_id IN (
      '5878489195471701074',
	'5878489760280872018',	
'5878490200653431887',
 '**5914275246093894935**'**,**
'**5914284726730884329**'**,**
'**5914285188427285702**'**,**
      '5919443818810180867',
      '5919354354880480810',
'**5919444556751832297**',
'**5919445081698338275**',
'5919356477881976256'
    )
    and status in ('1', '2', '3')
    and cast(bind_time as timestamp) >= cast(concat(year('${V_DATE}'), '-', month('${V_DATE}'), '-01 00:00:00') as timestamp)
    and cast(bind_time as timestamp) <= cast('${V_DATE} 23:59:59' as timestamp)
group by
    bind_uid



停车位/卫生间/附近5KM最优惠/新人特惠