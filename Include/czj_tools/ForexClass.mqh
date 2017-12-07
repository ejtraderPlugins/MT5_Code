//+------------------------------------------------------------------+
//|                                                   ForexClass.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <Object.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ForexFamily:public CObject
  {
protected:
   string            name;
   int               num;
   string            symbol_names[];
   double            symbol_coefficient[];
public:
                     ForexFamily(void){};
   void              Init(string family_name);
                    ~ForexFamily(void){};
   double            GetCoeffAt(const int index);
   string            GetSymbolNameAt(const int index);
   int               GetSymbolNum(void){return num;}
   string            GetFamilyName(void){return name;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ForexFamily::Init(string family_name)
  {
   if(family_name=="USD")
     {
      string  sn[]={"XAUUSD","XTIUSD","EURUSD","GBPUSD","AUDUSD","NZDUSD","USDJPY","USDCAD","USDCHF"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      double   coeff[]={-1,-1,-1,-1,-1,-1,1,1,1};
      ArrayCopy(symbol_names,sn);
      ArrayCopy(symbol_coefficient,coeff);
     }
   else if(family_name=="GBP")
     {
      string sn[]={"EURGBP","GBPAUD","GBPCAD","GBPCHF","GBPJPY","GBPNZD","GBPUSD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={-1,1,1,1,1,1,1};
      ArrayCopy(symbol_coefficient,coeff);
     }
   else if(family_name=="EUR")
     {
      string sn[]={"EURAUD","EURCAD","EURCHF","EURGBP","EURJPY","EURNZD","EURUSD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1,1,1,1,1,1};
      ArrayCopy(symbol_coefficient,coeff);
     }
     
   else if(family_name=="AUD")
     {
      string sn[]={"AUDCHF","AUDJPY","AUDNZD","AUDUSD","AUDCAD","EURAUD","GBPAUD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1,1,1,1,-1,-1};
      ArrayCopy(symbol_coefficient,coeff);
     }
     
    else if(family_name=="CHF")
     {
      string sn[]={"CHFJPY","CADCHF","EURCHF","GBPCHF","NZDCHF","USDCHF","AUDCHF"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,-1,-1,-1,-1,-1,-1};
      ArrayCopy(symbol_coefficient,coeff);
     }
   else if(family_name=="CAD")
     {
      string sn[]={"CADCHF","CADJPY","EURCAD","GBPCAD","NZDCAD","USDCAD","AUDCAD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1,-1,-1,-1,-1,-1};
      ArrayCopy(symbol_coefficient,coeff);
     }  
   else if(family_name=="JPY")
     {
      string sn[]={"CADJPY","CHFJPY","EURJPY","GBPJPY","NZDJPY","USDJPY","AUDJPY"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={-1,-1,-1,-1,-1,-1,-1};
      ArrayCopy(symbol_coefficient,coeff);
     }
   else if(family_name=="NZD")
     {
      string sn[]={"NZDCAD","NZDCHF","NZDJPY","NZDUSD","EURNZD","GBPNZD","AUDNZD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1,1,1,-1,-1,-1};
      ArrayCopy(symbol_coefficient,coeff);
     }    
   else if(family_name=="A-1")
      {
      string sn[]={"XAUUSD","USDJPY"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1};
      ArrayCopy(symbol_coefficient,coeff);
      }
   else if(family_name=="A-2")
      {
      string sn[]={"XAUUSD","XAGUSD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1};
      ArrayCopy(symbol_coefficient,coeff);
      }
   else if(family_name=="A-3")
      {
      string sn[]={"XTIUSD","XBRUSD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1};
      ArrayCopy(symbol_coefficient,coeff);
      }
   else if(family_name=="A-4")
      {
      string sn[]={"USDJPY","USDCHF"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1};
      ArrayCopy(symbol_coefficient,coeff);
      }
   else if(family_name=="A-5")
      {
      string sn[]={"GBPUSD","EURUSD"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      ArrayCopy(symbol_names,sn);
      double   coeff[]={1,1};
      ArrayCopy(symbol_coefficient,coeff);
      }
   else
     {
      string sn[]={"XAUUSD","EURUSD","GBPUSD","AUDUSD","NZDUSD","USDJPY","USDCAD","USDCHF"};
      num=ArraySize(sn);
      ArrayResize(symbol_names,num);
      double   coeff[]={-1,-1,-1,-1,-1,1,1,1};
      ArrayCopy(symbol_names,sn);
      ArrayCopy(symbol_coefficient,coeff);
     }
     
   name=family_name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ForexFamily::GetCoeffAt(const int index)
  {
   return symbol_coefficient[index];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ForexFamily::GetSymbolNameAt(const int index)
  {
   return symbol_names[index];
  }
//+------------------------------------------------------------------+
