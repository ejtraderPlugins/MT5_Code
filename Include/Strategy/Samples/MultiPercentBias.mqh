//+------------------------------------------------------------------+
//|                                              MultiPecentBias.mqh |
//|                                      Copyright 2017,Daixiaorong. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017,Daixiaorong."
#property link      "https://www.mql5.com"
#property copyright "Copyright 2017,Daixiaorong."
#property link      "https://www.mql5.com"

#include <Indicators\Oscilators.mqh>
#include <Indicators\Trend.mqh>
#include <Math\Stat\Normal.mqh> 
#include "..\Strategy.mqh"
//+------------------------------------------------------------------+
//| 采用乖离率的百分位数进场或者滑动窗口的乖离率变动进场                                                               |
//+------------------------------------------------------------------+
class CMultiPercentBias:public CStrategy
  {
private:
   int               m_ma_period;
   ENUM_APPLIED_PRICE m_applied_price;
   double            m_current_lots;
   double            m_invest_level;
   double            buy_in_percent;
   double            buy_out_percent;
   double            sell_in_percent;
   double            sell_out_percent;
   double            best_out_time;
   double            m_profit_out;
   int               m_max_lots;
   int               time_unit;
   bool              every_tick;
   CiBIAS            m_bias;
   CiMA              m_ma;
   double            bias_mean;
   double            bias_std;
   bool              CalBiasStataFlag;
   void              CalBiasStata();
   bool              IsTrackEvents(const MarketEvent &event);
protected:
   virtual void      InitBuy(const MarketEvent &event);
   virtual void      InitSell(const MarketEvent &event);
   virtual void      OnEvent(const MarketEvent &event);
   virtual void      SupportBuy(const MarketEvent &event,CPosition *pos);
   virtual void      SupportSell(const MarketEvent &event,CPosition *pos);
   double            SecondsConvert(long seconds,int mode=0);
   int               StartIndex(void) {return every_tick?0:1;}
public:
                     CMultiPercentBias(void);
                    ~CMultiPercentBias(void);
   bool              CheckOutTime(CPosition *pos);
   void              Lots(double value)         { m_current_lots=value;}
   double            Lots(void)                 {return m_current_lots;}
   void              InvestLevel(double value);
   double            InvestLevel(void) {return m_invest_level;}
   void              SetParams(int ma_period,double BuyInLevel,double BuyOutLevel,double SellInLevel,double SellOutLevel,
                               double BestOutTime=0.0,int TimeUnit=0,double profit_out=0.0,bool EveryTick=false,int max_lots=1);
  };
//+------------------------------------------------------------------+
//| 初始化                                                                 |
//+------------------------------------------------------------------+
CMultiPercentBias::CMultiPercentBias(void)
  {
   m_ma_period=24;
   m_applied_price=PRICE_CLOSE;
   buy_in_percent=0.001;
   buy_out_percent=0.60;
   sell_in_percent=0.999;
   sell_out_percent=0.40;
   best_out_time=0.0;
   time_unit=0;
   every_tick=true;
   m_max_lots=1;
   m_current_lots=1.00;
   m_invest_level=0.0;
   m_profit_out=0.0;
   bias_mean=0.0;
   bias_std=0.0;
   CalBiasStataFlag=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMultiPercentBias::~CMultiPercentBias(void)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMultiPercentBias::OnEvent(const MarketEvent &event)
  {
   m_bias.Refresh();
   m_ma.Refresh();
    //---计算乖离指标的均值和标准差
   if(!CalBiasStataFlag)
     {
      CalBiasStata();
     }
   
  }
//+------------------------------------------------------------------+
//|  买单入场条件                                                                |
//+------------------------------------------------------------------+
void CMultiPercentBias::InitBuy(const MarketEvent &event)
  {
   if(!CalBiasStataFlag) return;
   if(!IsTrackEvents(event)) return;
   if(positions.open_buy>m_max_lots-1) return;
   int idx=StartIndex();
   if(m_bias.Main(idx)<=buy_in_percent)
      Trade.Buy(m_current_lots,event.symbol,(string)ExpertMagic());

  }
//+------------------------------------------------------------------+
//| 买单出场条件                                                                 |
//+------------------------------------------------------------------+
void CMultiPercentBias::SupportBuy(const MarketEvent &event,CPosition *pos)
  {
   int idx=StartIndex();
   if((m_bias.Main(idx)>=buy_out_percent && m_ma.Main(idx)-m_ma.Main(idx+m_ma_period)<0) || CheckOutTime(pos))
      pos.CloseAtMarket((string)ExpertMagic());
  }
//+------------------------------------------------------------------+
//|卖单入场条件                                                                  |
//+------------------------------------------------------------------+
void CMultiPercentBias::InitSell(const MarketEvent &event)
  {
   if(!CalBiasStataFlag) return;
   if(!IsTrackEvents(event)) return;
   if(positions.open_sell>m_max_lots-1) return;
   int idx=StartIndex();
   if(m_bias.Main(idx)>=sell_in_percent)
      Trade.Sell(m_current_lots,event.symbol,(string)ExpertMagic());
  }
//+------------------------------------------------------------------+
//|卖单出场条件                                                                 |
//+------------------------------------------------------------------+
void CMultiPercentBias::SupportSell(const MarketEvent &event,CPosition *pos)
  {
   int idx=StartIndex();
   if((m_bias.Main(idx)<=sell_out_percent && m_ma.Main(idx)-m_ma.Main(idx+m_ma_period)>0) || CheckOutTime(pos))
      pos.CloseAtMarket((string)ExpertMagic());
  }
//+------------------------------------------------------------------+
//| 计算乖离指标的均值和标准差 
//| 重新计算乖离的进场阀值                                                                |
//+------------------------------------------------------------------+
void CMultiPercentBias::CalBiasStata()
  {
   double bias_data[];
   if(m_bias.GetData(0,2000,0,bias_data)>0)
     {
      int error_code;
      bias_mean=MathMean(bias_data);
      bias_std=MathStandardDeviation(bias_data);
      buy_in_percent=MathQuantileNormal(buy_in_percent,bias_mean,bias_std,error_code);
      buy_out_percent=MathQuantileNormal(buy_out_percent,bias_mean,bias_std,error_code);
      sell_in_percent=MathQuantileNormal(sell_in_percent,bias_mean,bias_std,error_code);
      sell_out_percent=MathQuantileNormal(sell_out_percent,bias_mean,bias_std,error_code);
      printf(DoubleToString(buy_in_percent)+" "+DoubleToString(buy_out_percent)+" "
      +DoubleToString(sell_in_percent)+" "+DoubleToString(sell_out_percent));
      CalBiasStataFlag=true;
     }
   else
      printf((string)ExpertMagic()+":读取bias数据错误!");
  }
//+------------------------------------------------------------------+
//| 设置参数 
//| ma_period：    ma周期
//| BuyInLevel：   多单进场的分位数
//  BuyOutLevel：  多单出场的分位数
//  SellInLevel：  空单进场的分位数
//  SellOutLevel： 空单出场的分位数
//  BestOutTime=0.0：最佳出场时间
//  TimeUnit=0 ：     时间的单位
//  profit_out=0.0 ：出场时间到之后的止盈值
//  EveryTick=false： 是否当前Bar交易
//  max_lots=1     ：  允许的最大手数                                                                |
//+------------------------------------------------------------------+
void CMultiPercentBias::SetParams(int    ma_period,
                           double BuyInLevel,
                           double BuyOutLevel,
                           double SellInLevel,
                           double SellOutLevel,
                           double BestOutTime=0.0,
                           int    TimeUnit=0,
                           double profit_out=0.0,
                           bool   EveryTick=false,
                           int    max_lots=1)
  {
   m_ma_period=ma_period;
   buy_in_percent=BuyInLevel;
   buy_out_percent=BuyOutLevel;
   sell_in_percent=SellInLevel;
   sell_out_percent=SellOutLevel;
   best_out_time=BestOutTime;
   time_unit=TimeUnit;
   m_profit_out=profit_out;
   every_tick=EveryTick;
   m_max_lots=max_lots;
   m_bias.Create(ExpertSymbol(),Timeframe(),m_ma_period,m_applied_price);
   m_ma.Create(ExpertSymbol(),Timeframe(),m_ma_period,0,MODE_SMA,m_applied_price);

  }
//+------------------------------------------------------------------+
//|  将秒数化为分钟或者小时，或者天数,分别为mode= 0,1,2默认为0                                                              |
//+------------------------------------------------------------------+
double CMultiPercentBias::SecondsConvert(long seconds,int mode=0)
  {
   double res=0.0;
   switch(mode)
     {
      case 0 :
         res=double(seconds)/60.00000000;
         break;
      case 1:
         res=double(seconds)/(60.00000000*60.00000000);
         break;
      default:
         res=double(seconds)/(60.00000000*60.00000000*24.00000000);
         break;
     }
   return res;
  }
//+------------------------------------------------------------------+
//| 检查是否需要固定时间出场                                                                 |
//+------------------------------------------------------------------+
bool CMultiPercentBias::CheckOutTime(CPosition *pos)
  {
   if(best_out_time>0)
     {
      if(m_profit_out>0.0)
        {
         return (SecondsConvert((long)(TimeCurrent()-pos.TimeOpen()),time_unit)>=best_out_time) && (pos.Profit()>=m_profit_out);
        }
      else
         return SecondsConvert((long)(TimeCurrent()-pos.TimeOpen()),time_unit)>=best_out_time;
     }
   else
      return false;
  }
//+------------------------------------------------------------------+
//| 固定比例投资                                                                |
//+------------------------------------------------------------------+
void CMultiPercentBias::InvestLevel(double value)
  {
   m_invest_level=value;
   if(m_invest_level>0)
      m_current_lots=AccountInfoDouble(ACCOUNT_MARGIN_FREE)*m_invest_level;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMultiPercentBias::IsTrackEvents(const MarketEvent &event)
  {
   if(event.type!=MARKET_EVENT_BAR_OPEN) return false;
   if(event.symbol!=ExpertSymbol() || event.period!=Timeframe()) return false;
   return true;
  }
//+------------------------------------------------------------------+
