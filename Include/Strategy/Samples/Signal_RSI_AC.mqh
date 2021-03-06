//+------------------------------------------------------------------+
//|                                                EventListener.mqh |
//|           Copyright 2016, Vasiliy Sokolov, St-Petersburg, Russia |
//|                                https://www.mql5.com/en/users/c-4 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "https://www.mql5.com/en/users/c-4"
#include <Strategy\Strategy.mqh>
#include <Strategy\SignalAdapter.mqh>
input int RSI_Period = 14; // RSI Period
//+------------------------------------------------------------------+
//| Strategy receives events and displays in terminal.               |
//+------------------------------------------------------------------+
class COnSignal_RSI_AC : public CStrategy
{
private:
   CSignalAdapter    m_adapter_rsi;
   CSignalAdapter    m_adapter_ac;
public:
                     COnSignal_RSI_AC(void);
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      SupportBuy(const MarketEvent& event, CPosition* pos);
   virtual void      SupportSell(const MarketEvent& event, CPosition* pos);
};
//+------------------------------------------------------------------+
//| Initialization of the CSignalMacd signal module                  |
//+------------------------------------------------------------------+
COnSignal_RSI_AC::COnSignal_RSI_AC(void)
{
   MqlSignalParams params;
   params.every_tick = false;
   params.magic = 32910;
   params.point = 10.0;
   params.symbol = Symbol();
   params.period = Period();
   params.usage_pattern = 2;
   params.signal_type = SIGNAL_AC;
   CSignalAC* ac = m_adapter_ac.CreateSignal(params);
   params.usage_pattern = 1;
   params.magic = 32911;
   params.signal_type = SIGNAL_RSI;
   CSignalRSI* rsi = m_adapter_rsi.CreateSignal(params);
   rsi.PeriodRSI(RSI_Period);
}
//+------------------------------------------------------------------+
//| Buying.                                                          |
//+------------------------------------------------------------------+
void COnSignal_RSI_AC::InitBuy(const MarketEvent &event)
{
   if(event.type != MARKET_EVENT_BAR_OPEN)
      return;
   if(positions.open_buy > 0)
      return;
   if(m_adapter_rsi.LongSignal())
      Trade.Buy(1.0);
}
//+------------------------------------------------------------------+
//| Closing Buys                                                     |
//+------------------------------------------------------------------+
void COnSignal_RSI_AC::SupportBuy(const MarketEvent &event, CPosition* pos)
{
   if(event.type != MARKET_EVENT_BAR_OPEN)
      return;
   if(m_adapter_ac.ShortSignal())
      pos.CloseAtMarket();
}
//+------------------------------------------------------------------+
//| Selling.                                                         |
//+------------------------------------------------------------------+
void COnSignal_RSI_AC::InitSell(const MarketEvent &event)
{
   if(event.type != MARKET_EVENT_BAR_OPEN)
      return;
   if(positions.open_sell > 0)
      return;
   if(m_adapter_rsi.ShortSignal())
      Trade.Sell(1.0);
}
//+------------------------------------------------------------------+
//| Closing Buys                                                     |
//+------------------------------------------------------------------+
void COnSignal_RSI_AC::SupportSell(const MarketEvent &event, CPosition* pos)
{
   if(event.type != MARKET_EVENT_BAR_OPEN)
      return;
   if(m_adapter_ac.LongSignal())
      pos.CloseAtMarket();
}
//+------------------------------------------------------------------+
