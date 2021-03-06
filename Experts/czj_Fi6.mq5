//+------------------------------------------------------------------+
//|                                                       czj_Fi.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

input int period=50;
input int out_time=5000;
input int range_point=300;
input int range_period=20;
input int EA_Magic=8881;
input double lots=0.1;
input double buy_in_fi=0.618;
input double buy_out_fi_win=1;
input double buy_out_fi_loss=-2.0;
input double sell_in_fi=0.618;
input double sell_out_fi_win=1;
input double sell_out_fi_loss=-2.0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      //检查bar数是否足够
      if(Bars(_Symbol,_Period)<period)
            return;
      int total=0;
      int total_buy=0;
      int total_sell=0;
      //检查仓位，持仓则判断是否需要平仓
      if(PositionSelect(_Symbol)==true)
      {  
         total=PositionsTotal();
         for(int i=0;i<total;i++)
            {  
               string position_symbol=PositionGetSymbol(i);
               if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
                  total_buy++;
               else
                  total_sell++;   
            }
            
      }
      if(total_sell>100)
         return;
      double high_price[];
      double low_price[];
      double take_profit;
      double stop_loss;
      double size=0.0;
      int max_loc;
      int min_loc;
      double max_price;
      double min_price;
      MqlTick latest_price;
      MqlTradeRequest mrequest;
      MqlTradeResult mresult;
      ZeroMemory(mrequest);
      //ZeroMemory(mrequest);
      
      if(!SymbolInfoTick(_Symbol,latest_price))
         {
            Alert("获取最新报价错误：", GetLastError());
            return;
         }  
      CopyHigh(_Symbol,_Period,0,period,high_price);
      CopyLow(_Symbol,_Period,0,period,low_price);

      max_loc = ArrayMaximum(high_price);
      min_loc = ArrayMinimum(low_price);
      max_price = high_price[max_loc];
      min_price = high_price[min_loc];
      
      bool buy_condition_basic = (max_loc>min_loc)&&(max_loc-min_loc<range_period)&&(max_price-min_price>range_point*_Point);
      bool buy_condition_level1 = latest_price.ask<0.618*(max_price-min_price)+min_price;
      bool buy_condition_level2 = latest_price.ask<0.5*(max_price-min_price)+min_price;
      bool buy_condition_level3 = latest_price.ask<0.382*(max_price-min_price)+min_price;
      
      bool sell_condition_basic = (max_loc<min_loc)&&(min_loc-max_loc<range_period)&&(max_price-min_price>range_point*_Point);
      bool sell_condition_level1 = latest_price.bid>max_price-0.618*(max_price-min_price);
      bool sell_condition_level2 = latest_price.bid>max_price-0.5*(max_price-min_price);
      bool sell_condition_level3 = latest_price.bid>max_price-0.382*(max_price-min_price);
      
      if(buy_condition_basic)
         {
         mrequest.action=TRADE_ACTION_DEAL;
         mrequest.price=NormalizeDouble(latest_price.ask,_Digits);
         mrequest.symbol=_Symbol;
         mrequest.magic=EA_Magic;
         mrequest.type=ORDER_TYPE_BUY;
         mrequest.type_filling=ORDER_FILLING_FOK;
         mrequest.deviation=5;
         bool order_need_send=false;
         if(buy_condition_level1&&total_buy<1)
            {
               take_profit=0.782*(max_price-min_price)+min_price;
               stop_loss=-2*(max_price-min_price)+min_price;
               size=0.1;
               order_need_send=true;
            }
         if(buy_condition_level2&&total_buy<2)
            {
               take_profit=0.782*(max_price-min_price)+min_price;
               stop_loss=-2.618*(max_price-min_price)+min_price;
               size=0.3;
               order_need_send=true;
            }
         if(buy_condition_level3&&total_buy<3)
            {
               take_profit=0.782*(max_price-min_price)+min_price;
               stop_loss=-2.618*(max_price-min_price)+min_price;
               size=0.5;
               order_need_send=true;
            }
         if(order_need_send)
            {
            Print("***************************send buy order:", total, " ", total_sell, " ", total_buy);
            mrequest.volume=size;
            mrequest.tp=NormalizeDouble(take_profit,_Digits);
            mrequest.sl=NormalizeDouble(stop_loss, _Digits);
            OrderSend(mrequest, mresult);
            if(mresult.retcode==10009||mresult.retcode==10008)
               {
                  Alert("买入订单已经成功下单，订单#:", mresult.order,"!!");
               }
            else
               {
                  Alert("买入订单请求无法完成,", GetLastError());
                  ResetLastError();
                  return;
               } 
            }
         }
      if(sell_condition_basic)
         
         {
         mrequest.action=TRADE_ACTION_DEAL;
         mrequest.price=NormalizeDouble(latest_price.bid,_Digits);
         mrequest.type=ORDER_TYPE_SELL;
         mrequest.symbol=_Symbol;
         mrequest.magic=EA_Magic;
         mrequest.type_filling=ORDER_FILLING_FOK;
         mrequest.deviation=5;
         bool order_need_send=false;
         if(sell_condition_level1&&total_sell<1)
            {  
               take_profit=max_price-0.782*(max_price-min_price);
               stop_loss=max_price-(-2)*(max_price-min_price);
               size=0.1;
               order_need_send=true;
            }
         if(sell_condition_level2&&total_sell<2)
            {
               take_profit=max_price-0.782*(max_price-min_price);
               stop_loss=max_price-(-2.618)*(max_price-min_price);
               size=0.3;
               order_need_send=true;
            }
         if(sell_condition_level3&&total_sell<3)
            {
            take_profit=max_price-0.782*(max_price-min_price);
            stop_loss=max_price-(-2.618)*(max_price-min_price);
            size=0.5;
            order_need_send=true;
            }
         if(order_need_send)
            {
            mrequest.volume=size;
            mrequest.tp=NormalizeDouble(take_profit,_Digits);
            mrequest.sl=NormalizeDouble(stop_loss, _Digits);
            OrderSend(mrequest, mresult);
            if(mresult.retcode==10009||mresult.retcode==10008)
               {
                  Alert("卖出订单已经成功下单，订单#:", mresult.order,"!!");
               }
            else
               {
                  Alert("卖出订单请求无法完成,", GetLastError());
                  ResetLastError();
                  return;
               } 
            }
         }
  }


//+------------------------------------------------------------------+
void check_for_open(void)
   {
   
   }