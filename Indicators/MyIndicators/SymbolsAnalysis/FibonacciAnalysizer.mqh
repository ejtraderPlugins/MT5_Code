//+------------------------------------------------------------------+
//|                                          FibonacciAnalysizer.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#property version   "1.00"

ENUM_TIMEFRAMES period_arr[]={PERIOD_M1,PERIOD_M5,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1};
string period_names[]={"M1","M5","M30","H1","H4","D1"};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CFibonacciAnalysizer
  {
private:
   int               handle_zigzag[];//zigzag指标句柄
   string            symbol_name;

public:
                     CFibonacciAnalysizer();
                    ~CFibonacciAnalysizer();
   void              Init(const string symbol);
   void              Analysis(void);
   double            fibonacci_ratio[];// Fibonacci比例
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CFibonacciAnalysizer::CFibonacciAnalysizer()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CFibonacciAnalysizer::~CFibonacciAnalysizer()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CFibonacciAnalysizer::Init(const string symbol)
  {
   symbol_name=symbol;
   int num=ArraySize(period_arr);
   ArrayResize(handle_zigzag,num);
   ArrayResize(fibonacci_ratio,num);
   for(int i=0;i<num;i++)
      handle_zigzag[i]=iCustom(symbol_name,period_arr[i],"Examples\\ZigZag");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CFibonacciAnalysizer::Analysis(void)
  {
   MqlTick latest_price;
   SymbolInfoTick(symbol_name,latest_price);
   for(int i=0;i<ArraySize(handle_zigzag);i++)
     {
      double values[500];
      double zz[2]={0,0};
      int counter=0;
      CopyBuffer(handle_zigzag[i],0,0,500,values);
      for(int j=ArraySize(values)-2;j>0;j--)
        {
         if(counter==2) break;
         if(values[j]==0) continue;
         zz[counter]=values[j];
         counter++;
        }
      fibonacci_ratio[i]=MathAbs(latest_price.bid-zz[0])/(zz[0]-zz[1]);
     }

  }
//+------------------------------------------------------------------+
