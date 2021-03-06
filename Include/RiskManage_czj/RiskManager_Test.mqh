//+------------------------------------------------------------------+
//|                                             RiskManager_Test.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#include "RiskManager.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetAccountInformation()
  {
   Print("账户信息");
//ENUM_ACCOUNT_INFO_DOUBLE account_double[]={ACCOUNT_BALANCE,ACCOUNT_CREDIT,ACCOUNT_PROFIT,ACCOUNT_EQUITY,ACCOUNT_MARGIN,ACCOUNT_MARGIN_FREE,ACCOUNT_MARGIN_LEVEL,ACCOUNT_MARGIN_SO_CALL,ACCOUNT_MARGIN_SO_SO,ACCOUNT_MARGIN_INITIAL,ACCOUNT_MARGIN_MAINTENANCE,ACCOUNT_ASSETS,ACCOUNT_LIABILITIES,ACCOUNT_COMMISSION_BLOCKED};
//string account_double_flag[]={"balance","credit","profit","equity","margin","margin_free","margin_level","margin_so_call","margin_so_so","margin_init","margin_maitance","account_assets","liability","commission_block"};
//int account_double_choose_index[]={0,3,2,4,6};
//for(int i=0;i<ArraySize(account_double_choose_index);i++)
//  {
//   Print(account_double_flag[account_double_choose_index[i]],":",AccountInfoDouble(account_double[account_double_choose_index[i]]));
//  }

//ENUM_ACCOUNT_INFO_INTEGER account_integer[]={ACCOUNT_LOGIN,ACCOUNT_TRADE_MODE,ACCOUNT_LEVERAGE,ACCOUNT_LIMIT_ORDERS,ACCOUNT_MARGIN_SO_MODE,ACCOUNT_TRADE_ALLOWED,ACCOUNT_TRADE_EXPERT,ACCOUNT_MARGIN_MODE};
//string account_integer_flag[]={"login num","trade mode","leverage","limit orders","so mode","trade allowed","trade experts","margin_mode"};
//int account_integer_choose_index[]={0,1,2,3,4,5,6,7};
//for(int i=0;i<ArraySize(account_integer_choose_index);i++)
//  {
//   Print(account_integer_flag[account_integer_choose_index[i]],":",AccountInfoInteger(account_integer[account_integer_choose_index[i]]));
//  }

   HistorySelect(0,D'2030.01.01');
   for(int i=0;i<HistoryDealsTotal();i++)
     {
      ulong ticket=HistoryDealGetTicket(i);
      Print(i," ",
            TimeToString(HistoryDealGetInteger(ticket,DEAL_TIME))," ",
            ticket," ",
            HistoryDealGetString(ticket,DEAL_SYMBOL)," ",
            HistoryDealGetInteger(ticket,DEAL_TYPE)," ",
            HistoryDealGetInteger(ticket,DEAL_ENTRY)," ",
            HistoryDealGetDouble(ticket,DEAL_VOLUME)," ",
            HistoryDealGetDouble(ticket,DEAL_PRICE)," ",
            string(HistoryDealGetInteger(ticket,DEAL_ORDER))," ",
            HistoryDealGetDouble(ticket,DEAL_COMMISSION)," ",
            HistoryDealGetDouble(ticket,DEAL_SWAP), " ",
            HistoryDealGetDouble(ticket,DEAL_PROFIT)," ",
            HistoryDealGetInteger(ticket,DEAL_POSITION_ID));
            
     }
  }
void test_risk_manager()
   {
    CRiskManager *rm=new CRiskManager();
    rm.RefreshInfor();
    rm.ToFile("test.txt");
    delete rm;
   }
//+------------------------------------------------------------------+
