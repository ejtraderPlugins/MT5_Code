//+------------------------------------------------------------------+
//|                                                TrendAnalysis.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
class LongTermAnalysis
  {
protected:
   string            symbol_name;
   ENUM_TIMEFRAMES   time_frame;
   MqlTick           latest_price;
   int               tau_ma;
   int               tau_boll;
   double            delta_sigma_boll;

   int               handle_ma;
   int               handle_boll;
   int               handle_zigzag;

   double            ma[1];
   double            up[1],down[1],middle[1];
   double            zigzag[20];

public:
   double dist_price_with_ma;
   double dist_price_with_boll;
   double fibonacci_ratio;
                     LongTermAnalysis(void);
                     LongTermAnalysis(string s_name,ENUM_TIMEFRAMES tf);
   double            Dist_Ma_Price(void);
   double            Dist_Boll_Price(void);
   void              Get_zigzag_extrems(void);
   double            Fibonacci_Ratio(void);
   double            Support_Resistence_Price(void);
   void      GetStatics(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LongTermAnalysis::LongTermAnalysis(string s_name,ENUM_TIMEFRAMES tf)
  {
   symbol_name=s_name;
   time_frame=tf;
   SymbolInfoTick(symbol_name,latest_price);
   tau_ma=200;
   tau_boll=20;
   delta_sigma_boll=2.0;
   handle_ma=iMA(symbol_name,time_frame,tau_ma,0,MODE_EMA,PRICE_CLOSE);
   handle_boll=iBands(symbol_name,time_frame,tau_boll,0,delta_sigma_boll,PRICE_CLOSE);
   handle_zigzag=iCustom(symbol_name,time_frame,"Examples\\ZigZag");
   Get_zigzag_extrems();
   GetStatics();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LongTermAnalysis::LongTermAnalysis(void)
  {
   symbol_name=_Symbol;
   time_frame=_Period;
   SymbolInfoTick(symbol_name,latest_price);
   tau_ma=200;
   tau_boll=20;
   delta_sigma_boll=2.0;
   handle_ma=iMA(symbol_name,time_frame,tau_ma,0,MODE_EMA,PRICE_CLOSE);
   handle_boll=iBands(symbol_name,time_frame,tau_boll,0,delta_sigma_boll,PRICE_CLOSE);
   handle_zigzag=iCustom(symbol_name,time_frame,"Examples\\ZigZag");
   Get_zigzag_extrems();
   GetStatics();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LongTermAnalysis::Dist_Ma_Price(void)
  {
   CopyBuffer(handle_ma,0,0,1,ma);
   return latest_price.ask-ma[0];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LongTermAnalysis::Dist_Boll_Price(void)
  {
   CopyBuffer(handle_boll,0,0,1,middle);
   CopyBuffer(handle_boll,1,0,1,up);
   CopyBuffer(handle_boll,2,0,1,down);
   return (latest_price.ask-middle[0])/(up[0]-middle[0]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LongTermAnalysis::Get_zigzag_extrems(void)
  {
   double values[1000];
   CopyBuffer(handle_zigzag,0,0,1000,values);
   int counter=0;
   for(int i=ArraySize(values)-1;i>0;i--)
     {
      if(counter==20) break;
      if(values[i]==0) continue;
      counter++;
      zigzag[counter-1]=values[i];
      //Print("zigzag:",zigzag[counter-1]);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LongTermAnalysis::Fibonacci_Ratio(void)
  {
   double range1=zigzag[1]-zigzag[0];
   double range2=zigzag[2]-zigzag[1];
   if(MathAbs(range1)>MathAbs(range2)*0.75)
      return (latest_price.ask-zigzag[1])/(zigzag[2]-zigzag[1]);
   else
      return (latest_price.ask-zigzag[0])/(zigzag[1]-zigzag[0]);
  }
  void LongTermAnalysis::GetStatics(void)
   {
    dist_price_with_ma=Dist_Ma_Price();
    dist_price_with_boll=Dist_Boll_Price();
    fibonacci_ratio=Fibonacci_Ratio();
   }
//+------------------------------------------------------------------+