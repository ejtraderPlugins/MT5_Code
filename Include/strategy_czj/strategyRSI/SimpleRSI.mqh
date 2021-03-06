//+------------------------------------------------------------------+
//|                                                    SimpleRSI.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include <Strategy\Strategy.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSimpleRSIStrategy:public CStrategy
  {
private:
   int               rsi_handle;
   double            rsi_up;
   double            rsi_down;
   double            rsi_buffer[];
   MqlTick           latest_price;
   double            order_lots;
   bool  only_single_position;
protected:
   virtual void      OnEvent(const MarketEvent &event);
public:
                     CSimpleRSIStrategy(void);
                    ~CSimpleRSIStrategy(void){};
   void              SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame);
   void              SetMultiPosition(){only_single_position=false;};

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSimpleRSIStrategy::CSimpleRSIStrategy(void)
  {
   rsi_handle=iRSI(ExpertSymbol(),Timeframe(),12,PRICE_CLOSE);
   rsi_up=70;
   rsi_down=30;
   order_lots=0.1;
   only_single_position=true;
  }
void CSimpleRSIStrategy::SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame)
   {
    AddBarOpenEvent(symbol,time_frame);
    AddTickEvent(symbol);
   }
void CSimpleRSIStrategy::OnEvent(const MarketEvent &event)
   {
    // 品种的tick事件发生时候的处理
    if(event.symbol==ExpertSymbol()&&event.type==MARKET_EVENT_TICK)
      {
       Print("tick event");
       CopyBuffer(rsi_handle,0,0,3,rsi_buffer);
       bool rsi_short=rsi_buffer[0]>rsi_up;
       bool rsi_long=rsi_buffer[0]<rsi_down;
       SymbolInfoTick(ExpertSymbol(),latest_price);
       for(int i=0;i<ActivePositions.Total();i++)
         {
          CPosition *cpos=ActivePositions.At(i);
          if(cpos.ExpertMagic()!=ExpertMagic())continue;
          if(cpos.Symbol() != ExpertSymbol())continue;
          
          if(cpos.Direction()==POSITION_TYPE_BUY&&rsi_short)
             Trade.PositionClose(cpos.ID());
          if(cpos.Direction()==POSITION_TYPE_SELL&&rsi_long)
             Trade.PositionClose(cpos.ID());
         }
      }
     //---品种的BAR事件发生时候的处理
     if(event.symbol==ExpertSymbol()&&event.period==Timeframe()&&event.type==MARKET_EVENT_BAR_OPEN)
       {
        CopyBuffer(rsi_handle,0,0,3,rsi_buffer);
        bool rsi_short=rsi_buffer[0]>rsi_up;
        bool rsi_long=rsi_buffer[0]<rsi_down;
        if(only_single_position)
          {
           bool open_buy=positions.open_buy==0&&rsi_long;
           bool open_sell=positions.open_sell==0&&rsi_short;
          }
        else
          {
           bool open_buy=rsi_long;
           bool open_sell=rsi_short;
          }
        
        if(positions.open_buy==0&&rsi_long)
          Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_BUY,order_lots,latest_price.ask,0,0,"buy RSI"+(string)rsi_buffer[0]);
        if(positions.open_sell==0&&rsi_short)
          Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_SELL,order_lots,latest_price.bid,0,0,"sell RSI"+(string)rsi_buffer[0]);
       }
   }
//+------------------------------------------------------------------+

