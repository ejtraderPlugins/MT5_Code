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
//test_data_manager();
   //test_corr();
   test_data_analysizer();
  }
//+------------------------------------------------------------------+
void test_data_manager()
  {
   CForexMarketDataManager *dm=new CForexMarketDataManager();
   string s[]={"XAUUSD","USDJPY"};
   ENUM_TIMEFRAMES period=PERIOD_H1;
   dm.SetParameter(s,period);
   dm.RefreshSymbolsPrice(10);
   CArrayDouble price=dm.GetSymbolPriceAt("USDJPY");
   datetime t[];
   dm.GetSymbolTime(t);
   for(int i=0;i<dm.NumPrice();i++)
     {
      //Print(t[i],":",price[i]);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void test_corr()
  {
   CForexMarketDataManager *dm=new CForexMarketDataManager();
   string s[]={"XAUUSD","USDJPY"};
   ENUM_TIMEFRAMES period=PERIOD_M1;
   dm.SetParameter(s,period);
   dm.RefreshSymbolsPrice(100);
   CArrayDouble usdjpy = dm.GetSymbolPriceAt(s[0]);
   CArrayDouble xauusd = dm.GetSymbolPriceAt(s[1]);
   double close1[];
   double close2[];
   ArrayResize(close1,usdjpy.Total());
   ArrayResize(close2,xauusd.Total());
   for(int i=0;i<usdjpy.Total();i++)
     {
      close1[i]=usdjpy.At(i);
      //close1[i]=i;
      Print(close1[i]);
     }
   for(int i=0;i<xauusd.Total();i++)
     {
      close2[i]=xauusd.At(i);
      //close2[i]=i;
      Print(close2[i]);
     }
   CBaseStat bs=new CBaseStat();
   Print("r:",bs.PearsonCorr2(close1,close2,100));
  }
void test_data_analysizer()
   {
    CForexMarketDataManager *dm=new CForexMarketDataManager();
    string all_symbols[];
    ArrayResize(all_symbols,SymbolsTotal(true));
    for(int i=0;i<SymbolsTotal(true);i++)
      {
       all_symbols[i]=SymbolName(i,true);
       Print(all_symbols[i]);
      }
    dm.SetParameter(all_symbols,PERIOD_M5);
    dm.RefreshSymbolsPrice(100);
    Print(dm.NumSymbol());
    Print(dm.NumPrice());
    CForexMarketDataAnalyzier *da=new CForexMarketDataAnalyzier();
    da.SetDataManager(dm);
    double corref[];
    string s1[];
    string s2[];
    da.GetPearsonCorrN(all_symbols,corref,s1,s2);
    Print(da.GetPearsonCorr2(all_symbols[1],all_symbols[2]));
    for(int i=0;i<ArraySize(s1);i++)
      {
       Print("symbol1:",s1[i]," symbol2:",s2[i],"corr:",corref[i]);
      }
   }
//+------------------------------------------------------------------+
