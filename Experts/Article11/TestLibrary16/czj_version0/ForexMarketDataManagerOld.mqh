//+------------------------------------------------------------------+
//|                                      ForexMatrketDataManager.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayDouble.mqh>
//+------------------------------------------------------------------+
//|      外汇全市场数据接口                                          |
//+------------------------------------------------------------------+
class CForexMarketDataManager:public CObject
  {
private:
   string            symbols[];//品种数组
   ENUM_TIMEFRAMES   tf;//周期
   CArrayObj         symbol_price;//价格数据
   datetime          symbol_time[];//时间
   int               price_num;
   int               symbol_num;
public:
   void              SetParameter(const string &forex_symbol[],const ENUM_TIMEFRAMES time_frame);//设置参数

   int               NumPrice(void) {return price_num;};
   int               NumSymbol(void){return symbol_num;};
   ENUM_TIMEFRAMES   TimeFrame(void){return tf;};//返回周期

   string            GetSymbolAt(const int index){return symbols[index];};//获取指定索引的品种数组
   datetime          GetTimeAt(const int index){return symbol_time[index];};

   void              RefreshSymbolsPrice(datetime begin,datetime end);//刷新给定时间间隔的价格数据
   void              RefreshSymbolsPrice(datetime begin);//刷新给定时间起点和价格数据
   void              RefreshSymbolsPrice(int num);//刷新给定数量的价格数据
   
   CArrayDouble     *GetSymbolPriceAt(int index);//返回给定索引的数据
   CArrayDouble     *GetSymbolPriceAt(string symbol_name);//返回给定品种的数据
   void  GetSymbolTime(datetime &dt_arr[]){ArrayCopy(dt_arr,symbol_time);};
  };
//+------------------------------------------------------------------+
void CForexMarketDataManager::SetParameter(const string &forex_symbol[],const ENUM_TIMEFRAMES time_frame)
  {
   ArrayCopy(symbols,forex_symbol);
   tf=time_frame;
   symbol_num=ArraySize(symbols);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CForexMarketDataManager::RefreshSymbolsPrice(datetime begin,datetime end)
  {
   symbol_price.Shutdown();
   datetime dt=begin;
   int num=0;
   while(true)
     {
      dt=dt+PeriodSeconds(tf);
      if(dt>end) break;
      ArrayResize(symbol_time,num+1);
      symbol_time[num]=dt;
      num++;
     }
   price_num=num;

   for(int i=0;i<symbol_num;i++)
     {
      CArrayDouble *price=new CArrayDouble();
      for(int j=0;j<price_num;j++)
        {
         double close[];
         if(CopyClose(symbols[i],tf,symbol_time[j],1,close)<0)
            price.Add(EMPTY_VALUE);
         else
            {
             price.Add(close[0]);
            }
        }
      
      symbol_price.Add(price);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CForexMarketDataManager::RefreshSymbolsPrice(datetime begin)
  {
   RefreshSymbolsPrice(begin,TimeCurrent());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CForexMarketDataManager::RefreshSymbolsPrice(int num)
  {
   datetime end=TimeCurrent();
   datetime begin=end-num*PeriodSeconds(tf);
   RefreshSymbolsPrice(begin,end);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArrayDouble *CForexMarketDataManager::GetSymbolPriceAt(int index)
  {
   return symbol_price.At(index);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CArrayDouble *CForexMarketDataManager::GetSymbolPriceAt(string symbol_name)
  {
   for(int i=0;i<ArraySize(symbols);i++)
     {
      if(symbol_name==symbols[i])
        {
         return symbol_price.At(i);
        }
     }
   return NULL;
  }

//+------------------------------------------------------------------+
