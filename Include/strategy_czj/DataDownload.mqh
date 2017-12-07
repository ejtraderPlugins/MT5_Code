//+------------------------------------------------------------------+
//|                                                 DataDownload.mqh |
//|                                                       chizhijing |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "chizhijing"
#property link      "https://www.mql5.com"
#include <Strategy\Strategy.mqh>

class CDataDownload:public CStrategy
   {
    public:
       virtual void      OnEvent(const MarketEvent &event);
   };
void CDataDownload::OnEvent(const MarketEvent &event)
   {
    if(event.symbol==ExpertSymbol()&&event.type==MARKET_EVENT_BAR_OPEN)
      Copy
      
   }   