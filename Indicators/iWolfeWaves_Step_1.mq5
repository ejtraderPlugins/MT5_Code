#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot UpArrow
#property indicator_label1  "UpArrow"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrAqua
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot DnArrow
#property indicator_label2  "DnArrow"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrDeepPink
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot UpDot
#property indicator_label3  "UpDot"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrAqua
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot DnDot
#property indicator_label4  "DnDot"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrDeepPink
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

//--- input parameters

enum ESorce{
   Src_HighLow=0,
   Src_Close=1,
   Src_RSI=2,
   Src_MA=3
};

enum EDirection{
   Dir_NBars=0,
   Dir_CCI=1
};

struct SPeackTrough{
   double   Val;
   int      Dir;
   int      Bar;
};

input ESorce               SrcSelect      =  Src_HighLow;
input EDirection           DirSelect      =  Dir_NBars;
input int                  RSIPeriod      =  14;
input ENUM_APPLIED_PRICE   RSIPrice       =  PRICE_CLOSE;
input int                  MAPeriod       =  14;
input int                  MAShift        =  0;
input ENUM_MA_METHOD       MAMethod       =  MODE_SMA;
input ENUM_APPLIED_PRICE   MAPrice        =  PRICE_CLOSE;
input int                  CCIPeriod      =  14;
input ENUM_APPLIED_PRICE   CCIPrice       =  PRICE_TYPICAL;
input int                  ZZPeriod       =  14;

int handle=INVALID_HANDLE;
//--- indicator buffers
double         UpArrowBuffer[];
double         DnArrowBuffer[];
double         UpDotBuffer[];
double         DnDotBuffer[];

SPeackTrough PeackTrough[];
int PreCount;
int CurCount;
int PreDir;
int CurDir;
datetime LastTime;

bool _DrawWaves;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){

   handle=iCustom(Symbol(),Period(),"ZigZags\\iUniZigZagSW",SrcSelect,
                                             DirSelect,
                                             RSIPeriod,
                                             RSIPrice,
                                             MAPeriod,
                                             MAShift,
                                             MAMethod,
                                             MAPrice,
                                             CCIPeriod,
                                             CCIPrice,
                                             ZZPeriod);
   
   if(handle==INVALID_HANDLE){
      Alert("Error load indicator");
      return(INIT_FAILED);
   }  
  
   SetIndexBuffer(0,UpArrowBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,DnArrowBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,UpDotBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,DnDotBuffer,INDICATOR_DATA);

   PlotIndexSetInteger(0,PLOT_ARROW,233);
   PlotIndexSetInteger(1,PLOT_ARROW,234);
   
   PlotIndexSetInteger(2,PLOT_ARROW,159);
   PlotIndexSetInteger(3,PLOT_ARROW,159);   
   
   PlotIndexSetInteger(0,PLOT_ARROW_SHIFT,10);
   PlotIndexSetInteger(1,PLOT_ARROW_SHIFT,-10);  

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   ObjectsDeleteAll(0,MQLInfoString(MQL_PROGRAM_NAME));
   ChartRedraw(0);
}  
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   int start;
   
   if(prev_calculated==0){
      start=1;      
      CurCount=0;
      PreCount=0;
      CurDir=0;
      PreDir=0;      
      LastTime=0;
   }
   else{
      start=prev_calculated-1;
   }
   

   for(int i=start;i<rates_total;i++){
   
      if(time[i]>LastTime){
         LastTime=time[i];
         PreCount=CurCount;
         PreDir=CurDir;
      }
      else{
         CurCount=PreCount;
         CurDir=PreDir;
      }
   
      UpArrowBuffer[i]=EMPTY_VALUE;
      DnArrowBuffer[i]=EMPTY_VALUE;
      
      UpDotBuffer[i]=EMPTY_VALUE;
      DnDotBuffer[i]=EMPTY_VALUE;    
      
      double hval[1];
      double lval[1];
      
      double zz[1];
      
      // new max      
      
      double lhb[2];
      if(CopyBuffer(handle,4,rates_total-i-1,2,lhb)<=0){
         return(0);
      }
      if(lhb[0]!=lhb[1]){
         if(CopyBuffer(handle,0,rates_total-i-1,1,hval)<=0){
            return(0);
         }      
         if(CurDir==1){
            RefreshLast(i,hval[0]);
         }
         else{
            AddNew(i,hval[0],1);
         }
         //
      }
     
      
      // new min
      
      double llb[2];
      if(CopyBuffer(handle,5,rates_total-i-1,2,llb)<=0){
         return(0);
      }
      if(llb[0]!=llb[1]){
         if(CopyBuffer(handle,1,rates_total-i-1,1,lval)<=0){
            return(0);
         }         
         if(CurDir==-1){
            RefreshLast(i,lval[0]);
         }
         else{
            AddNew(i,lval[0],-1);
          
         }
         //
      }      
   }
   
   return(rates_total);
}
//+------------------------------------------------------------------+

void RefreshLast(int i,double v){
   PeackTrough[CurCount-1].Bar=i;
   PeackTrough[CurCount-1].Val=v;
} 

void AddNew(int i,double v,int d){
   if(CurCount>=ArraySize(PeackTrough)){
      ArrayResize(PeackTrough,ArraySize(PeackTrough)+1024);
   }
   PeackTrough[CurCount].Dir=d;
   PeackTrough[CurCount].Val=v;
   PeackTrough[CurCount].Bar=i;
   CurCount++;   
   CurDir=d;
} 
