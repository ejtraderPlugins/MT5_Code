//+------------------------------------------------------------------+
//|                                           AccountInformation.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include <Arrays\ArrayLong.mqh>
#include <Arrays\ArrayObj.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct AccountInfor
  {
   double            balance;
   double            equity;
   double            margin_used;
   double            margin_percent;
   long              lever;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPositionInfor:public CObject
  {
public:
   datetime          open_time;
   datetime          close_time;
   string            symbol;
   double            open_price;
   double            close_price;
   ENUM_POSITION_TYPE position_type;
   double            open_volume;
   double            close_volume;
   double            profits;
   long              id;
   long              ea_magic;
   long              close_type;
   double              hold_time;
   double            swap;
   double            commission;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CRiskManager
  {
private:
   AccountInfor      account;
   CArrayObj         position;
public:
                     CRiskManager(void){};
                    ~CRiskManager(void);
   void              RefreshInfor(void);
   void              ToFile(string path);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRiskManager::~CRiskManager(void)
  {
   position.Shutdown();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRiskManager::RefreshInfor(void)
  {
//    获取账户信息
   account.balance=AccountInfoDouble(ACCOUNT_BALANCE);
   account.equity=AccountInfoDouble(ACCOUNT_EQUITY);
   account.margin_used=AccountInfoDouble(ACCOUNT_MARGIN);
   account.margin_percent=AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);
   account.lever=AccountInfoInteger(ACCOUNT_LEVERAGE);
//    计算仓位情况
   HistorySelect(0,D'3000.01.01');
   for(int i=0;i<HistoryDealsTotal();i++)
     {
      ulong ticket=HistoryDealGetTicket(i);
      if(HistoryDealGetInteger(ticket,DEAL_ENTRY)==DEAL_ENTRY_IN)
        {
         CPositionInfor *pos=new CPositionInfor();
         pos.id=HistoryDealGetInteger(ticket,DEAL_POSITION_ID);
         pos.symbol=HistoryDealGetString(ticket,DEAL_SYMBOL);
         pos.open_time=HistoryDealGetInteger(ticket,DEAL_TIME);
         pos.open_price=HistoryDealGetDouble(ticket,DEAL_PRICE);
         pos.position_type=HistoryDealGetInteger(ticket,DEAL_TYPE);
         pos.open_volume=HistoryDealGetDouble(ticket,DEAL_VOLUME);
         pos.ea_magic=HistoryDealGetInteger(ticket,DEAL_MAGIC);
         pos.swap=HistoryDealGetDouble(ticket,DEAL_SWAP);
         pos.commission=HistoryDealGetDouble(ticket,DEAL_COMMISSION);
         double close_volume_sum=0.0;
         double close_price_sum=0.0;
         double profits=0.0;
         double swap=0;
         double commision=0;
         long close_time;
         //          寻找对应的平仓交易
         for(int j=0;j<HistoryDealsTotal();j++)
           {
            ulong ticket2=HistoryDealGetTicket(j);
            if(HistoryDealGetInteger(ticket2,DEAL_ENTRY)==DEAL_ENTRY_OUT && HistoryDealGetInteger(ticket2,DEAL_POSITION_ID)==pos.id)
              {
               close_volume_sum+=HistoryDealGetDouble(ticket2,DEAL_VOLUME);
               close_price_sum+=HistoryDealGetDouble(ticket2,DEAL_VOLUME)*HistoryDealGetDouble(ticket2,DEAL_PRICE);
               profits+=HistoryDealGetDouble(ticket2,DEAL_PROFIT);
               close_time=close_time<HistoryDealGetInteger(ticket2,DEAL_TIME)?HistoryDealGetInteger(ticket2,DEAL_TIME):close_time;
               swap+=HistoryDealGetDouble(ticket2,DEAL_SWAP);
               commision+=HistoryDealGetDouble(ticket2,DEAL_COMMISSION);
              }
           }
         pos.close_time=close_time;
         pos.close_price=close_volume_sum==0?0:close_price_sum/close_volume_sum;
         pos.profits=profits;
         pos.close_volume=close_volume_sum;
         pos.swap+=swap;
         pos.commission+=commision;
         if(close_volume_sum==pos.open_volume)
           {
            pos.close_type=0;
            pos.hold_time=(double)(pos.close_time-pos.open_time)/(60*60);
           }
         else if(close_volume_sum==0)
           {
            pos.close_type=1;
            pos.hold_time=(double)(TimeCurrent()-pos.open_time)/(60*60);
           }

         else
           {
            pos.close_type=2;
            pos.hold_time=(double)(TimeCurrent()-pos.open_time)/(60*60);
           }
         position.Add(pos);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRiskManager::ToFile(string path)
  {
   int file_handle=FileOpen(path,FILE_WRITE|FILE_CSV);
   if(file_handle!=INVALID_HANDLE)
     {
      FileWrite(file_handle,
                "开仓时间",
                "类型",
                "交易量(开)",
                "交易量(平)",
                "交易品种",
                "开仓价格",
                "平仓时间(最后)",
                "平仓价格(均价)",
                "利润",
                "是否完全平仓",
                "手续费",
                "库存费",
                "策略",
                "持仓时间"
                );
      for(int i=0;i<position.Total();i++)
        {
         CPositionInfor *pos=position.At(i);
         FileWrite(file_handle,
                   pos.open_time,
                   pos.position_type,
                   pos.open_volume,
                   pos.close_volume,
                   pos.symbol,
                   pos.open_price,
                   pos.close_time,
                   pos.close_price,
                   pos.profits,
                   pos.close_type,
                   pos.commission,
                   pos.swap,
                   pos.ea_magic,
                   pos.hold_time);
        }
      FileClose(file_handle);
      Print("Write data OK!");
     }
   else
      Print("打开文件错误",GetLastError());
  }
//+------------------------------------------------------------------+
