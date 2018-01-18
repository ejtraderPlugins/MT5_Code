//+------------------------------------------------------------------+
//|                                                        test1.mq5 |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"
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
   //get_market_infor();
   //test_datetime_to_others();
   //test_resize();
   //test_indicator();
   //func_test_main();
   test_symbols_digits();

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
    int handle_file=FileOpen("symbols_name_CFDFutures_13.csv",FILE_WRITE|FILE_CSV);
    for(int i=0;i<SymbolsTotal(true);i++)
      {
       FileWrite(handle_file,SymbolName(i,true));
      }
    FileClose(handle_file);
   }
 void test_datetime_to_others()
   {
    datetime dt_begin=D'2017.03.02 12:00';
    datetime dt_end=D'2017.03.02 11:15';
    Print(dt_begin," ", dt_end);
    Print((int)dt_begin," ", (int)dt_end);
    Print((long)dt_begin," ", (long)dt_end);
    Print((dt_begin-dt_end));
    Print(long(dt_begin-dt_end));
    Print(PeriodSeconds(PERIOD_M15));
   }
   
void test_resize()
   {
    int a[];
    for(int i=0;i<5;i++)
      {
         ArrayResize(a,i+1);
         a[i]=i;
      }
     for(int i=0;i<5;i++)
       {
        Print(a[i]);
       }
   }
void test_indicator()
   {
    int rsi_handle1=iRSI("XAUUSD",PERIOD_H1,12,PRICE_CLOSE);
    int rsi_handle2=iRSI("CADCHF",PERIOD_H1,12,PRICE_CLOSE);
    Print(rsi_handle1," ",rsi_handle2);
   }
   
void func_test(const double &arr[],bool &big5,bool &less0)
   {
    for(int i=0;i<ArraySize(arr);i++)
      {
       if(arr[i]>5)
         {
          big5=true;
         }
       if(arr[i]<0)
         {
          less0=true;
         }
      }
     Print(big5,less0);
   }
void func_test_main()
   {
    bool is_big_5=false;
    bool is_less_0=false;
    double a[]={-3,6,8};
    Print(is_big_5,is_less_0);
    func_test(a,is_big_5,is_less_0);
    Print(is_big_5,is_less_0);
   }
void test_symbols_digits()
   {
    for(int i=0;i<SymbolsTotal(true);i++)
      {
       string symbol_choose=SymbolName(i,true);
       double point = SymbolInfoDouble(symbol_choose,SYMBOL_POINT);
       long digits = SymbolInfoInteger(symbol_choose,SYMBOL_DIGITS);
       double tick_size=SymbolInfoDouble(symbol_choose,SYMBOL_TRADE_TICK_SIZE);
       double size=SymbolInfoDouble(symbol_choose,SYMBOL_TRADE_CONTRACT_SIZE);
       
       Print("Symbol:",symbol_choose," Point:", point," Digits:",digits, " Tick Size:",tick_size, " Size:",size);
      }
   }