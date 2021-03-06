//+------------------------------------------------------------------+
//|                                              DealInformation.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

ENUM_DEAL_PROPERTY_DOUBLE deal_infor_double[]={DEAL_VOLUME,DEAL_PRICE,DEAL_COMMISSION,DEAL_SWAP,DEAL_PROFIT};
ENUM_DEAL_PROPERTY_INTEGER deal_infor_integer[]={DEAL_TICKET,DEAL_ORDER,DEAL_TIME,DEAL_TIME_MSC,DEAL_TYPE,DEAL_ENTRY,DEAL_MAGIC,DEAL_REASON,DEAL_POSITION_ID};
ENUM_DEAL_PROPERTY_STRING deal_infor_string[]={DEAL_SYMBOL,DEAL_COMMENT};
string deal_double_flag[]={"成交量","成交价格","手续费","库存费","获利"};
string deal_integer_flag[]={"交易号","订单号","时间","时间(毫秒)","类型1","类型2","魔术号","原因","仓位号"};
string deal_string_flag[]={"品种","注释"};
int double_choose_index[]={0,1,2,3,4};
int integer_choose_index[]={0,1,2,3,4,5,6,7,8};
int string_choose_index[]={0,1};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CHistoryDealInfor
  {
public:
                     CHistoryDealInfor(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CHistoryDealInfor::CHistoryDealInfor(void)
  {
   int double_size=ArraySize(double_choose_index);
   int integer_size=ArraySize(integer_choose_index);
   int string_size=ArraySize(string_choose_index);
   
   HistorySelect(0,D'2030.01.01');
   for(int i=0;i<HistoryDealsTotal();i++)
     {
      
     }

  }
//+------------------------------------------------------------------+
