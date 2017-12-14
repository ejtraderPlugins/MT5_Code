//+------------------------------------------------------------------+
//|                                                  TestScripts.mq5 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include "ForexMarketDataManager.mqh"
#include "ForexMarketDataAnalizer.mqh"
#include<Math\Alglib\statistics.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   //test_new_data_manager();
   test_data_analysis();
  }

void test_new_data_manager()
   {
    string s[]={"XAUUSD","USDJPY"};
    ENUM_TIMEFRAMES period[]={PERIOD_M1,PERIOD_H1};
    CForexMarketDataManager *dm =new CForexMarketDataManager();
    dm.SetParameter(s,period);
    dm.RefreshSymbolsPrice(100);
    CArrayDouble *price1=dm.GetSymbolPriceAt("USDJPY",PERIOD_M1);
    CArrayDouble *price2=dm.GetSymbolPriceAt("XAUUSD",PERIOD_H1);
    CArrayLong *dt1 = dm.GetTimeAt(0);
    CArrayLong *dt2 = dm.GetTimeAt(1);
    
    for(int i=0;i<price1.Total();i++)
      {
       Print("USDJPY-M1:",price1.At(i), "at ", (datetime)dt1.At(i));
      }
    for(int i=0;i<price2.Total();i++)
      {
       Print("XAUUSD-H1:",price2.At(i), "at ",(datetime)dt2.At(i));
      }
   }
 void test_data_analysis()
   {
    ENUM_TIMEFRAMES period[]={PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1};
    string s[];
    ArrayResize(s,SymbolsTotal(true));
    for(int i=0;i<SymbolsTotal(true);i++)
      {
       s[i]=SymbolName(i,true);
      }
    CForexMarketDataManager *dm =new CForexMarketDataManager();
    dm.SetParameter(s,period);
    dm.RefreshSymbolsPrice(D'2017.10.01',D'2017.10.20');
    CForexMarketDataAnalyzier *da=new CForexMarketDataAnalyzier();
    da.SetDataManager(dm);
    CArrayObj *res = new CArrayObj();
    da.GetPearsonCorrN(res);
    for(int i=0;i<res.Total();i++)
      {
       CArrayObj *period_corr=res.At(i);
       for(int j=0;j<period_corr.Total();j++)
         {
          CForexCorr *fc = period_corr.At(j);
          Print(fc.symbol1," ",fc.symbol2," ",fc.time_frame," ",fc.r);
         }
      }
   }
//+------------------------------------------------------------------+
