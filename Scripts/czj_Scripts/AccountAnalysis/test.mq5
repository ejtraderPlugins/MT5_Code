//+------------------------------------------------------------------+
//|                                                         test.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <RiskManage_czj\AccountInformation.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   //get_order_information();
   get_order_information2();
  }
//+------------------------------------------------------------------+
void get_order_information()
   {
    HistorySelect(0,D'2020.01.01');
   Print(HistoryDealsTotal());
   Print(HistoryOrdersTotal());
   Print(PositionsTotal());
   for(int i=0;i<HistoryOrdersTotal();i++)
     {
      ulong order_ticket=HistoryOrderGetTicket(i);
      double order_volume_init=HistoryOrderGetDouble(order_ticket,ORDER_VOLUME_INITIAL);
      double order_volume_current=HistoryOrderGetDouble(order_ticket,ORDER_VOLUME_CURRENT);
      double order_price_open=HistoryOrderGetDouble(order_ticket,ORDER_PRICE_OPEN);
      double order_price_current=HistoryOrderGetDouble(order_ticket,ORDER_PRICE_CURRENT);
      double order_sl=HistoryOrderGetDouble(order_ticket,ORDER_SL);
      double order_tp=HistoryOrderGetDouble(order_ticket,ORDER_TP);
      double order_price_stop_limit=HistoryOrderGetDouble(order_ticket,ORDER_PRICE_STOPLIMIT);
      //Print("第"+string(i)+"个订单:");
      //string order_infor_name_string[]={"交易品种"};
      //string order_infor_name_integer[]={"时间1","订单","类型","时间2","状态"};
      //string order_infor_name_double[]={"交易量1","交易量2","价位1","价位2","SL","TP"};
      //ENUM_ORDER_PROPERTY_STRING order_flag_string[]={ORDER_SYMBOL};
      //ENUM_ORDER_PROPERTY_INTEGER order_flag_integer[]={ORDER_TIME_SETUP,ORDER_TICKET,ORDER_TYPE,ORDER_TIME_DONE,ORDER_STATE};
      //ENUM_ORDER_PROPERTY_DOUBLE order_flag_double[]={ORDER_VOLUME_INITIAL,ORDER_VOLUME_CURRENT,ORDER_PRICE_OPEN,ORDER_PRICE_CURRENT,ORDER_SL,ORDER_TP};
      
      string order_infor_name_string[]={"交易品种","注释"};
      string order_infor_name_integer[]={"时间1","订单","类型","时间2","状态","PositionID"};
      string order_infor_name_double[]={"交易量1","交易量2","价位1","价位2","SL","TP"};
      ENUM_ORDER_PROPERTY_STRING order_flag_string[]={ORDER_SYMBOL,ORDER_COMMENT};
      ENUM_ORDER_PROPERTY_INTEGER order_flag_integer[]={ORDER_TIME_SETUP,ORDER_TICKET,ORDER_TYPE,ORDER_TIME_DONE,ORDER_STATE,ORDER_POSITION_ID};
      ENUM_ORDER_PROPERTY_DOUBLE order_flag_double[]={ORDER_VOLUME_INITIAL,ORDER_VOLUME_CURRENT,ORDER_PRICE_OPEN,ORDER_PRICE_CURRENT,ORDER_SL,ORDER_TP};
      
      string order_infor_for_print="";
      for(int j=0;j<ArraySize(order_infor_name_string);j++)
        order_infor_for_print+=order_infor_name_string[j]+":"+HistoryOrderGetString(order_ticket,order_flag_string[j])+" ";
      for(int j=0;j<ArraySize(order_infor_name_integer);j++)
        {
         order_infor_for_print+=order_infor_name_integer[j]+":"+HistoryOrderGetInteger(order_ticket,order_flag_integer[j])+" ";
        }
        
      for(int j=0;j<ArraySize(order_infor_name_double);j++)
        order_infor_for_print+=order_infor_name_double[j]+":"+HistoryOrderGetDouble(order_ticket,order_flag_double[j])+" ";
      Print(order_infor_for_print);
     }
   }

void get_order_information2()
   {
    COrderFlow order_flow=new COrderFlow();
    string infor[]; 
    order_flow.ToPrint();
    order_flow.ToCSV("AccountAnalysis\\Test2.txt");
   }