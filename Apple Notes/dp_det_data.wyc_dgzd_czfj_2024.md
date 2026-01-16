| <p style="text-align:center;margin:0">dp_det_data</p> | <p style="text-align:center;margin:0">wyc_dgzd_czfj_2024</p> |
| -- | -- |


dp_det_data.wyc_dgzd_czfj_2024


gas_dw.app_gas_merch_real_manage_di

<p style="text-align:center;margin:0">
</p>
离线-生产表
商户用户实付价格管理
 dp_det_data.wyc_tjzj_spid


wyc_sfdg_sfjg

ELECT dt, theater_name, city_name, store_id, store_name, dd_store_contact, data_type, SUM(x_trd_store_cnt), SUM(y_trd_store_cnt), SUM(x_rate), SUM(y_rate), SUM(x_order_cnt), SUM(y_order_cnt), SUM(daogualu), SUM(daogua1ppyineidaogualu), SUM(daogua1_2ppdaogualu), SUM(daogua2_5ppdaogualu), SUM(daogua5pp_daogualu), SUM(bijia_store_cnt), SUM(bijiayouzhanshuzhanbi), SUM(daogua_store_cnt), SUM(bijia_cnt), SUM(bijiacishuzhanbi), SUM(daogua_cnt), SUM(daogua_x_rate), SUM(daogua_y_rate), SUM(daogua_x_order_cnt), SUM(daogua_y_order_cnt), SUM(dingjiazhekouchazhi), SUM(shanghu_hanzhekouchi_butiechazhi), SUM(pingtaibutiechazhi), SUM(qudaobutiechazhi), SUM(disanfangbutiechazhi), SUM(x_total_gmv_rate), SUM(x_merchant_butie_rate), SUM(x_plat_butie_rate), SUM(x_bigc_channel_butie_rate), SUM(x_thirdpart_butie_rate), SUM(y_total_gmv_rate), SUM(y_merchant_butie_rate), SUM(y_plat_butie_rate), SUM(y_bigc_channel_butie_rate), SUM(y_thirdpart_butie_rate), SUM(dingjiazhekouchazhi) AS dingjiazhekouchazhi1, SUM(zhijiangbutiechazhi), SUM(putongquanbutiechazhi), SUM(qiangjiaquanbutiechazhi), SUM(qitaceluebutiechazhi), SUM(x_total_gmv_rate) AS x_total_gmv_rate1, SUM(y_total_gmv_rate) AS y_total_gmv_rate1, SUM(x_zhijiangbutie_rate), SUM(x_putongquanbutie_rate), SUM(x_qiangjiaquanbutie_rate), SUM(x_qitaceluebutie_rate), SUM(y_zhijiangbutie_rate), SUM(y_putongquanbutie_rate), SUM(y_qiangjiaquanbutie_rate), SUM(y_qitaceluebutie_rate), SUM(x_shuixian_ctr),


select
    dt,
    data_flag,
    replace(replace(data_type, '价格', '折扣'), '优惠', '折扣') as data_type,
    theater_id,
    theater_name,
    city_id,
    city_name,
    store_id,
    store_name,
    x_trd_store_cnt,
    y_trd_store_cnt,
    1 - x_rate as x_rate,
    1 - y_rate as y_rate,
    x_order_cnt,
    y_order_cnt,
    bijia_store_cnt,
    xy_store_cnt,
    daogua_store_cnt,
    bijia_cnt,
    xy_cnt,
    daogua_cnt,
    1pp_daogua_cnt,
    1_2pp_daogua_cnt,
    2_5pp_daogua_cnt,
    5pp_daogua_cnt,
    1 - daogua_x_rate as daogua_x_rate,
    1 - daogua_y_rate as daogua_y_rate,
    daogua_x_order_cnt,
    daogua_y_order_cnt,
    x_before_c_income_rate,
    x_total_gmv_rate,
    x_merchant_butie_rate,
    x_plat_butie_rate,
    x_bigc_channel_butie_rate,
    x_thirdpart_butie_rate,
    x_descend_amt_rate,
    x_coupon_amt_rate,
    x_allowance_amt_rate,
    x_other_amt_rate,
    y_before_c_income_rate,
    y_total_gmv_rate,
    y_merchant_butie_rate,
    y_plat_butie_rate,
    y_bigc_channel_butie_rate,
    y_thirdpart_butie_rate,
    y_descend_amt_rate,
    y_coupon_amt_rate,
    y_allowance_amt_rate,
    y_other_amt_rate,
    attribution_result1,
    attribution_result2,
    dd_store_contact,
    data_level as data_area_type
from
    gas_dw.app_gas_merch_real_manage_di
where
    dt >= '$[YYYY-MM-DD - 180D]'



=IF(SUM(U2:W2)=100,1,0)