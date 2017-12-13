//+------------------------------------------------------------------+
//|                                      ForexMarketDataAnalizer.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include "ForexMarketDataManager.mqh"
#include <Math\Alglib\statistics.mqh>
CBaseStat base_stat;

class CForexMarketDataAnalyzier
   {
    private:
      CForexMarketDataManager dm;
    public:
      void SetDataManager(CForexMarketDataManager &data_manager){dm=data_manager;};
      double GetPearsonCorr2(string symbol_x, string symbol_y);
      void GetPearsonCorrN(const string &symbols[], double &corr[], string &symbol_1[],string &symbol2[]);
   };

double CForexMarketDataAnalyzier::GetPearsonCorr2(string symbol_x,string symbol_y)
   {
    double price_x[],price_y[];
    ArrayResize(price_x,dm.NumPrice());
    ArrayResize(price_y,dm.NumPrice());
    for(int i=0;i<dm.NumPrice();i++)
      {
       price_x[i]=dm.GetSymbolPriceAt(symbol_x).At(i);
       price_y[i]=dm.GetSymbolPriceAt(symbol_y).At(i);
      }
    return base_stat.PearsonCorr2(price_x,price_y,dm.NumPrice()); 
   }
   
void CForexMarketDataAnalyzier::GetPearsonCorrN(const string &symbols[],double &corr[],string &symbol1[],string &symbol2[])
   {
    int num_symbol=ArraySize(symbols);
    int num_pairs=num_symbol*(num_symbol-1)/2;
    ArrayResize(corr,num_pairs);
    ArrayResize(symbol1,num_pairs);
    ArrayResize(symbol2,num_pairs);
    int counter=0;
    for(int i=0;i<num_symbol-1;i++)
      {
       for(int j=i+1;j<num_symbol;j++)
         {
          symbol1[counter]=symbols[i];
          symbol2[counter]=symbols[j];
          corr[counter]=GetPearsonCorr2(symbol1[counter],symbol2[counter]);
          counter++;
         }
      }
   }