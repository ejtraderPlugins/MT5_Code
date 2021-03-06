//+------------------------------------------------------------------+
//|                                                     Gambling.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <Strategy\Strategy.mqh>
//仓位状态
struct AddPositionStates
  {
   int               total_buy;
   int               total_sell;
   double            profits_buy;
   double            profits_sell;
  };
//加仓策略类   
class AddPositionStrategy:public CStrategy
  {
public:
                     AddPositionStrategy(void){};
                    ~AddPositionStrategy(void){};
   void              SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame);
protected:
   AddPositionStates pos_state;
   double            add_buy_price[];
   double            add_sell_price[];
   double            add_buy_lots[];
   double            add_sell_lots[];

   MqlTick           latest_price;
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      OnEvent(const MarketEvent &event);
   virtual void      RefreshPositionStates(AddPositionStates &p_state);
   void              CloseAllBuy();
   void              CloseAllSell();
   void              GetAddBuyPrice(const double buy_price_level0,double &buy_price_ts[]);
   void              GetAddBuyLots(const double buy_lots_level0,double &buy_lots_ts[]);
   void              GetAddSellPrice(const double sell_price_level0,double &sell_price_ts[]);
   void              GetAddSellLots(const double sell_lots_level0,double &sell_lots_ts[]);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::InitBuy(const MarketEvent &event)
  {
  RefreshPositionStates(pos_state);
//首次开多头仓,获取加仓价格序列
   if(pos_state.total_buy==0)
     {
      Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_BUY,0.01,latest_price.ask,0,0,"First-buy");
      ArrayResize(add_buy_price,20);
      ArrayResize(add_buy_lots,20);
      GetAddBuyPrice(latest_price.ask,add_buy_price);
      GetAddBuyLots(0.01,add_buy_lots);
      return;
     }
   if(pos_state.total_buy>20) return;
   if(latest_price.ask<add_buy_price[pos_state.total_buy-1])
      Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_BUY,add_buy_lots[pos_state.total_buy-1],latest_price.ask,0,0,"buy level"+string(pos_state.total_buy));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::InitSell(const MarketEvent &event)
  {
//首次开空头仓
   RefreshPositionStates(pos_state);
   if(pos_state.total_sell==0)
     {
      Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_SELL,0.01,latest_price.bid,0,0,"First-sell");
      ArrayResize(add_sell_price,20);
      ArrayResize(add_sell_lots,20);
      GetAddSellPrice(latest_price.bid,add_sell_price);
      GetAddSellLots(0.01,add_sell_lots);
      return;
     }
   if(pos_state.total_sell>20) return;
   if(latest_price.bid>add_sell_price[pos_state.total_sell-1])
      Trade.PositionOpen(ExpertSymbol(),ORDER_TYPE_SELL,add_sell_lots[pos_state.total_sell-1],latest_price.bid,0,0,"sell level"+string(pos_state.total_sell));

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::GetAddBuyPrice(const double buy_price_level0,double &buy_price_ts[])
  {
   for(int i=0;i<ArraySize(buy_price_ts);i++)
     {
      buy_price_ts[i]=buy_price_level0-200*SymbolInfoDouble(ExpertSymbol(),SYMBOL_POINT)*i;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::GetAddBuyLots(const double buy_lots_level0,double &buy_lots_ts[])
  {
   for(int i=0;i<ArraySize(buy_lots_ts);i++)
     {
      buy_lots_ts[i]=0.01*(i+1);
     }
     // for(int i=0;i<ArraySize(buy_lots_ts);i++)
     //{
     // if(i==0) 
     //    buy_lots_ts[i]=0.01;
     // else if(i==1) 
     //    buy_lots_ts[i]=0.02;
     // else 
     //    buy_lots_ts[i]=buy_lots_ts[i-1]+buy_lots_ts[i-2];
     //}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::GetAddSellPrice(const double sell_price_level0,double &sell_price_ts[])
  {
   for(int i=0;i<ArraySize(sell_price_ts);i++)
     {
      sell_price_ts[i]=sell_price_level0+200*SymbolInfoDouble(ExpertSymbol(),SYMBOL_POINT)*i;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::GetAddSellLots(const double sell_lots_level0,double &sell_lots_ts[])
  {
   for(int i=0;i<ArraySize(sell_lots_ts);i++)
     {
      sell_lots_ts[i]=0.01*(i+1);
     }
     //    for(int i=0;i<ArraySize(sell_lots_ts);i++)
     //{
     // if(i==0) 
     //    sell_lots_ts[i]=0.01;
     // else if(i==1) 
     //    sell_lots_ts[i]=0.02;
     // else 
     //    sell_lots_ts[i]=sell_lots_ts[i-1]+sell_lots_ts[i-2];
     //}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::RefreshPositionStates(AddPositionStates &p_state)
  {
   p_state.total_buy=0;
   p_state.total_sell=0;
   p_state.profits_buy=0;
   p_state.profits_sell=0;
   for(int i=0;i<PositionsTotal();i++)
     {
      ulong ticket=PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=ExpertMagic()) continue;
      if(PositionGetString(POSITION_SYMBOL)!=ExpertSymbol()) continue;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
        {
         p_state.total_buy++;
         p_state.profits_buy+=PositionGetDouble(POSITION_PROFIT);
        }
      else
        {
         p_state.total_sell++;
         p_state.profits_sell+=PositionGetDouble(POSITION_PROFIT);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::OnEvent(const MarketEvent &event)
  {
   if(event.type==MARKET_EVENT_TICK && event.symbol==ExpertSymbol())
     {
      //获取最新tick报价
      SymbolInfoTick(ExpertSymbol(),latest_price);
      //刷新仓位信息
      RefreshPositionStates(pos_state);
      //止盈操作
      if(pos_state.profits_buy>500*SymbolInfoDouble(ExpertSymbol(), SYMBOL_POINT)) CloseAllBuy();
      if(pos_state.profits_sell>500*SymbolInfoDouble(ExpertSymbol(), SYMBOL_POINT)) CloseAllSell();

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::CloseAllBuy(void)
  {
   for(int i=0;i<PositionsTotal();i++)
     {
      ulong ticket=PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=ExpertMagic()) continue;
      if(PositionGetString(POSITION_SYMBOL)!=ExpertSymbol()) continue;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
         Trade.PositionClose(ticket);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::CloseAllSell(void)
  {
   for(int i=0;i<PositionsTotal();i++)
     {
      ulong ticket=PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=ExpertMagic()) continue;
      if(PositionGetString(POSITION_SYMBOL)!=ExpertSymbol()) continue;
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
         Trade.PositionClose(ticket);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddPositionStrategy::SetEventDetect(string symbol,ENUM_TIMEFRAMES time_frame)
  {
   AddBarOpenEvent(symbol,time_frame);
   AddTickEvent(symbol);
  }
//+------------------------------------------------------------------+
