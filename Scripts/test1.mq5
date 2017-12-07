//+------------------------------------------------------------------+
//|                                                        test1.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <czj_tools\SymbolPrice.mqh>
#include <czj_tools\MarketPrice.mqh>
#include <Arrays\ArrayObj.mqh>
#include <Math\Alglib\alglib.mqh>
#include <czj_tools\Cointegration.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   //test_bar_num();
   //test_symbol_points();
   //test_CMatrixDouble();
   //test_regression();
   //test_new_row();
   //test_down_load_data();
   get_market_infor();

  }
//+------------------------------------------------------------------+

void test_bar_num()
   {
    string symbols[]={"XAUUSD","USDJPY","XTIUSD","XBRUSD","GBPUSD"};
    ENUM_TIMEFRAMES period=PERIOD_M1;
    for(int i=0;i<ArraySize(symbols);i++)
      {
       double price[];
       CopyClose(symbols[i],period,D'2017.05.01',D'2017.06.01',price);
       Print(symbols[i]," ", ArraySize(price)," ", price[0]);
      }
   }

void test_symbol_points()
   {
      string symbols[]={"XAUUSD","GBPUSD","EURUSD","NZDUSD","AUDUSD","USDJPY","USDCAD","XTIUSD","XBRUSD","GBPUSD"};
      for(int i=0;i<ArraySize(symbols);i++)
        {
         Print(symbols[i]," ", SymbolInfoDouble(symbols[i],SYMBOL_POINT));
        }
   }

void test_new_row()
   {
      Print("1");
      Print("3\n\r,5");
   }
   
void test_down_load_data()
   {
    MqlRates rates[];
    datetime dt_begin=D'2016.12.02';
    //datetime d1=D'2016.07.19 12:30:27';
    //datetime d2=D'2016.07.19 15:30:27';
    //Print(int(d1)-int(d2));
    datetime dt_end=D'2017.03.01';
    //Print("download data");
    if(CopyRates(_Symbol,_Period,dt_begin,dt_end,rates)<0)
      Print(false);
    Print(ArraySize(rates));
    Print(rates[0].time);
   }
void get_market_infor()
   {
    int handle_file=FileOpen("symbols_name.csv",FILE_WRITE|FILE_CSV);
    for(int i=0;i<SymbolsTotal(false);i++)
      {
       FileWrite(handle_file,SymbolName(i,false));
      }
    FileClose(handle_file);
   }