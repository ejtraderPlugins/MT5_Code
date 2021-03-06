//+------------------------------------------------------------------+
//|                                                EventListener.mqh |
//|           Copyright 2016, Vasiliy Sokolov, St-Petersburg, Russia |
//|                                https://www.mql5.com/en/users/c-4 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Vasiliy Sokolov."
#property link      "https://www.mql5.com/en/users/c-4"
#include <Strategy\Strategy.mqh>
#include <Expert\Signal\SignalMACD.mqh>
//+------------------------------------------------------------------+
//| Strategy receives events and displays in terminal.               |
//+------------------------------------------------------------------+
class CSignalSamples : public CStrategy
{
private:
   CSignalMACD       m_signal_macd;
   CSymbolInfo       m_info;
   CiOpen            m_open;
   CiHigh            m_high;
   CiLow             m_low;
   CiClose           m_close;
   CIndicators       m_indicators;
public:
                     CSignalSamples(void);
   virtual void      OnEvent(const MarketEvent& event);                     
};
//+------------------------------------------------------------------+
//| Initialization of the CSignalMacd signal module                  |
//+------------------------------------------------------------------+
CSignalSamples::CSignalSamples(void)
{
   m_signal_macd.Pattern_0(0);
   m_signal_macd.Pattern_1(0);
   m_signal_macd.Pattern_2(0);
   m_signal_macd.Pattern_3(100);
   m_signal_macd.Pattern_4(0);
   m_signal_macd.Pattern_5(0);
   m_info.Name(Symbol());                                  // Initializing the object that represents the trading symbol of the strategy
   m_signal_macd.Init(GetPointer(m_info), Period(), 10);   // Initializing the signal module by the trading symbol and timeframe
   m_signal_macd.InitIndicators(GetPointer(m_indicators)); // Creating required indicators in the signal module based on the empty list of indicators m_indicators
   m_signal_macd.EveryTick(true);                          // Testing mode
   m_signal_macd.Magic(ExpertMagic());                     // Magic number
   m_signal_macd.PatternsUsage(8);                         // Pattern mask
   m_open.Create(Symbol(), Period());                      // Initializing the timeseries of Open prices
   m_high.Create(Symbol(), Period());                      // Initializing the timeseries of High prices
   m_low.Create(Symbol(), Period());                       // Initializing the timeseries of Low prices
   m_close.Create(Symbol(), Period());                     // Initializing the timeseries of Close prices
   m_signal_macd.SetPriceSeries(GetPointer(m_open),        // Initializing the signal module by timeseries objects
                              GetPointer(m_high),
                              GetPointer(m_low),
                              GetPointer(m_close));
                              
}
//+------------------------------------------------------------------+
//| Buying.                                                          |
//+------------------------------------------------------------------+
void CSignalSamples::OnEvent(const MarketEvent &event)
{
   if(event.type != MARKET_EVENT_BAR_OPEN)
      return;
   m_indicators.Refresh();
   m_signal_macd.SetDirection();
   int power_sell = m_signal_macd.ShortCondition();
   int power_buy = m_signal_macd.LongCondition();
   if(power_buy != 0 || power_sell != 0)
      printf("PowerSell: " + (string)power_sell + " PowerBuy: " + (string)power_buy);
}
//+------------------------------------------------------------------+
