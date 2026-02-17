//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#property strict

#include "../MQH\Enums.mqh"
#include "../Signals/SignalBase.mqh"
#include "../MQH\TradingManager.mqh"
#include "../TradePad/TradePad.mqh"


struct StructTableParameters{
   string            trName;
   
   int               trTicket;
   
   bool              trIsInitialized;
   bool              trIsTableTrade;
   
   ENUM_ORDER_TYPE   trOrderType;
   double            trHeadRiskPercent;
   double            trHeadPips;
   
   //EnumTPadEntryType trEntryType;
   bool              trEntryType_Price;
   bool              trEntryType_Ema;
   bool              trEntryType_Disabled;
   ENUM_TIMEFRAMES   trEntryTimeframe;
   int               trEntryPeriod;
   
   int               trLookBack;
   int               trTouchPoints;
   
   //EnumTPadExitType_SL  trExitType_SL;
   bool              trExitType_SL_Price;
   bool              trExitType_SL_Pips;
   bool              trExitType_SL_Ema;
   
   ENUM_TIMEFRAMES      trExitTimeframe_SL;
   int                  trExitType_SL_Ema_Period;
   double               trExitType_SL_Pips_Pips;
   double               trExitType_SL_Price_Price;
   
   //EnumTPadExitType_TP  trExitType_TP;
   bool              trExitType_TP_RR;
   bool              trExitType_TP_Price;
   bool              trExitType_TP_Ema;
   bool              trExitType_TP_Indicator;
   ENUM_TIMEFRAMES      trExitTimeframe_TP;
   int                  trExitPeriod_TP;
   
   double               trExitType_TP_RR_RR;
   double               trExitType_TP_Price_Price;
   int                  trExitType_TP_Indicator_Indicator;
   
   bool              trBreakEvenEnable;
   double            trBreakEvenPips;        //Risk
   
   bool              trTslEnable;
   double            trTslPips;        
   
   bool              trSplitOrderEnable;
   double            trSplitOrderPercent;
   
   int               trExpireDays;
   int               trExpireHours;
   int               trExpireMinutes;
   
   bool              trEaFiltersEnable;
   
   void Load(string str){
      string   sep_lvl  = FILE_SEP_LEVEL_1;
      string   support[];
      TM.ParseStringToArray(str,support,sep_lvl);
      
      int   i  = 0;
      trName                  = support[i++];
      
      trTicket                = (int)support[i++];
      
      trIsInitialized         = (int)support[i++];
      trIsTableTrade          = (int)support[i++];
      
      trOrderType             = (ENUM_ORDER_TYPE)(int)support[i++];
      trHeadRiskPercent       = StringToDouble(support[i++]);
      trHeadPips              = StringToDouble(support[i++]);
      
      //trEntryType             = (EnumTPadEntryType)(int)support[i++];
      trEntryType_Price       = (int)support[i++];
      trEntryType_Ema         = (int)support[i++];
      trEntryType_Disabled    = (int)support[i++];
      trEntryTimeframe        = (ENUM_TIMEFRAMES)(int)support[i++];
      trEntryPeriod           = (int)support[i++];
      
      trLookBack              = (int)support[i++];
      trTouchPoints           = (int)support[i++];
      
      //trExitType_SL           = (EnumTPadExitType_SL)(int)support[i++];
      
      trExitType_SL_Ema          = (int)support[i++];
      trExitType_SL_Price        = (int)support[i++];
      trExitType_SL_Pips         = (int)support[i++];
      trExitType_SL_Price_Price  = StringToDouble(support[i++]);
      trExitType_SL_Pips_Pips    = StringToDouble(support[i++]);
      trExitTimeframe_SL         = (ENUM_TIMEFRAMES)(int)support[i++];
      //trExitType_SL_Ema_Period         = (int)support[i++];
      
      trExitType_SL_Ema_Period   = (int)support[i++];
      
      //trExitType_TP           = (EnumTPadExitType_TP)(int)support[i++];
      trExitType_TP_Ema       = (int)support[i++];
      trExitType_TP_Indicator = (int)support[i++];
      trExitType_TP_Price     = (int)support[i++];
      trExitType_TP_RR        = (int)support[i++];
      
      trExitType_TP_Indicator_Indicator   = int(support[i++]);
      trExitType_TP_Price_Price           = StringToDouble(support[i++]);
      trExitType_TP_RR_RR                 = StringToDouble(support[i++]);
      
      trExitTimeframe_TP      = (ENUM_TIMEFRAMES)(int)support[i++];
      trExitPeriod_TP         = (int)support[i++];
      
      trBreakEvenEnable       = (int)support[i++];
      trBreakEvenPips         = StringToDouble(support[i++]);
      
      trTslEnable             = (int)support[i++];
      trTslPips               = StringToDouble(support[i++]);
      
      trSplitOrderEnable      = (int)support[i++];
      trSplitOrderPercent     = StringToDouble(support[i++]);
      
      trExpireDays            = (int)support[i++];
      trExpireHours           = (int)support[i++];
      trExpireMinutes         = (int)support[i++];
      
      trEaFiltersEnable       = (int)support[i++];
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trName)+", "+
               "Try to load trade. -> "+ 
               str+" <- "+
               ToString()
               );
   }
   
   string Save(){
      string   sep_lvl_1   = FILE_SEP_LEVEL_1;
      
      string val =  
                           trName+sep_lvl_1+
                           
                           TM.ToString(trTicket)+sep_lvl_1+
                           
                           TM.ToString((int)trIsInitialized)+sep_lvl_1+
                           TM.ToString((int)trIsTableTrade)+sep_lvl_1+
                           
                           TM.ToString((int)trOrderType)+sep_lvl_1+
                           TM.ToString(trHeadRiskPercent)+sep_lvl_1+
                           TM.ToString(trHeadPips)+sep_lvl_1+
                           
                           //TM.ToString((int)trEntryType)+sep_lvl_1+
                           TM.ToString((int)trEntryType_Price)+sep_lvl_1+
                           TM.ToString((int)trEntryType_Ema)+sep_lvl_1+
                           TM.ToString((int)trEntryType_Disabled)+sep_lvl_1+
                           TM.ToString((int)trEntryTimeframe)+sep_lvl_1+
                           TM.ToString(trEntryPeriod)+sep_lvl_1+
                           
                           TM.ToString(trLookBack)+sep_lvl_1+
                           TM.ToString(trTouchPoints)+sep_lvl_1+
                           
                           TM.ToString((int)trExitType_SL_Ema)+sep_lvl_1+
                           TM.ToString((int)trExitType_SL_Price)+sep_lvl_1+
                           TM.ToString((int)trExitType_SL_Pips)+sep_lvl_1+
                           
                           TM.ToString(trExitType_SL_Price_Price)+sep_lvl_1+
                           TM.ToString(trExitType_SL_Pips_Pips)+sep_lvl_1+
                           
                           TM.ToString((int)trExitTimeframe_SL)+sep_lvl_1+
                           TM.ToString(trExitType_SL_Ema_Period)+sep_lvl_1+
                           
                           TM.ToString((int)trExitType_TP_Ema)+sep_lvl_1+
                           TM.ToString((int)trExitType_TP_Indicator)+sep_lvl_1+
                           TM.ToString((int)trExitType_TP_Price)+sep_lvl_1+
                           TM.ToString((int)trExitType_TP_RR)+sep_lvl_1+
                           TM.ToString(trExitType_TP_Indicator_Indicator)+sep_lvl_1+
                           TM.ToString(trExitType_TP_Price_Price)+sep_lvl_1+
                           TM.ToString(trExitType_TP_RR_RR)+sep_lvl_1+
                           
                           TM.ToString((int)trExitTimeframe_TP)+sep_lvl_1+
                           TM.ToString(trExitPeriod_TP)+sep_lvl_1+
                           
                           TM.ToString((int)trBreakEvenEnable)+sep_lvl_1+
                           TM.ToString(trBreakEvenPips)+sep_lvl_1+
                           
                           TM.ToString((int)trTslEnable)+sep_lvl_1+
                           TM.ToString(trTslPips)+sep_lvl_1+
                           
                           TM.ToString((int)trSplitOrderEnable)+sep_lvl_1+
                           TM.ToString(trSplitOrderPercent)+sep_lvl_1+
                           
                           TM.ToString(trExpireDays)+sep_lvl_1+
                           TM.ToString(trExpireHours)+sep_lvl_1+
                           TM.ToString(trExpireMinutes)+sep_lvl_1+
                           
                           TM.ToString((int)trEaFiltersEnable)
                           ;
                           
                           
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trName)+", "+
               "Try to save trade. -> "+ 
               val+" <- "+
               ToString()
               );
               
      return val;
   }
   
   void Initialize(string name, string reason){
      trIsInitialized   = true;
      trIsTableTrade    = true;
      
      trName   = name;
      
      UpdateDataByTable();
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(reason)+", "+
               ToString()
               );
   }
   
   void InitializeByTicket(int ticket, string name, string reason){
      trIsInitialized   = true;
      trTicket          = ticket;
      
      trName   = name;
      
      UpdateDataByTicket();
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(reason)+", "+
               ToString()
               );
   }
   
   //TABLE TRADE
   void UpdateDataByTable(){
      UpdateOrderType();
      
      UpdateHeadRiskPercent();
      //UpdateHeadPips();
      
      UpdateEntryType();
      //UpdateEntryTimeframe();
      UpdateEntryPeriod();
      //UpdateLookBack();
      //UpdateTouchPoints();
      
      UpdateExitType_SL();
      UpdateExitTimeframe_SL();
      UpdateExitPeriod_SL();
      
      UpdateExitType_TP();
      UpdateExitTimeframe_TP();
      UpdateExitPeriod_TP();
      
      UpdateBreakEvenEnable();
      UpdateBreakEvenPips();
      
      UpdateTslEnable();
      UpdateTslPips();
      
      UpdateSplitEnable();
      UpdateSplitPercent();
      
      UpdateExTiDay();
      UpdateExTiHour();
      UpdateExTiMin();
      
      UpdateEaFiltersEnable();   
   }
   
   void UpdateOrderType(){
      trOrderType       = glTradePad.GetTPadOrderType();
   }
   
   void UpdateHeadRiskPercent(){
      trHeadRiskPercent = glTradePad.GetRiskPercent();
   }
   
   /*
   void UpdateHeadPips(){
      trHeadPips        = glTradePad.GetHeadPips();
   }
   */
   
   void UpdateEntryType(){
      //trEntryType       = glTradePad.GetTPadEntryType();
      trEntryType_Price    = glTradePad.GetTPadEntryType_Price();
      //trEntryType_Ema      = glTradePad.GetTPadEntryType_Ema();
      trEntryType_Disabled = glTradePad.GetTPadEntryType_Disabled();
   }
   /*
   void UpdateEntryTimeframe(){
      trEntryTimeframe  = glTradePad.GetTimeFrameEntryType();
   }
   */
   void UpdateEntryPeriod(){
      trEntryPeriod     = glTradePad.GetEntryPeriod();
   }
   /*
   void UpdateLookBack(){
      trLookBack        = glTradePad.GetLookBack();
   }
   */
   /*
   void UpdateTouchPoints(){
      trTouchPoints     = glTradePad.GetTouchPoints();
   }
   */
   
   void UpdateExitType_SL(){
      //trExitType_SL        = glTradePad.GetTPadExitType_SL();
      trExitType_SL_Pips   = glTradePad.GetTPadExitType_SL_Pips();
      trExitType_SL_Price  = glTradePad.GetTPadExitType_SL_Price();
      trExitType_SL_Ema    = glTradePad.GetTPadExitType_SL_Ema();
      
      trExitType_SL_Pips_Pips    = glTradePad.GetExitPeriod_SL_Pips();
      trExitType_SL_Price_Price  = glTradePad.GetExitPeriod_SL_Price();
   }
   
   
   void UpdateExitTimeframe_SL(){
      trExitTimeframe_SL   = glTradePad.GetTimeFrameExitType_SL();
   }
   
   void UpdateExitPeriod_SL(){
      trExitType_SL_Ema_Period      = glTradePad.GetExitPeriod_SL_Ema();
   }
   
   void UpdateExitType_TP(){
      //trExitType_TP        = glTradePad.GetTPadExitType_TP();
      
      trExitType_TP_Ema       = glTradePad.GetTPadExitType_TP_Ema();
      trExitType_TP_Indicator = glTradePad.GetTPadExitType_TP_Indicator();
      trExitType_TP_Price     = glTradePad.GetTPadExitType_TP_Price();
      trExitType_TP_RR        = glTradePad.GetTPadExitType_TP_RR();
      
      trExitType_TP_RR_RR                 = glTradePad.GetTPadCEdit_TP_RR();
      trExitType_TP_Price_Price           = glTradePad.GetTPadCEdit_TP_Price();
      trExitType_TP_Indicator_Indicator   = glTradePad.GetTPadCEdit_TP_Indicator();
      
   }
   
   void UpdateExitTimeframe_TP(){
      trExitTimeframe_TP   = glTradePad.GetTimeFrameExitType_TP();
   }
   
   void UpdateExitPeriod_TP(){
      trExitPeriod_TP      = glTradePad.GetExitPeriod_TP();
   }
   
   void UpdateBreakEvenEnable(){
      trBreakEvenEnable = glTradePad.GetBreakEvenEnable();
   }
   
   void UpdateBreakEvenPips(){
      trBreakEvenPips   = glTradePad.GetBreakEvenPips();
   }
   
   void UpdateTslEnable(){
      trTslEnable = glTradePad.GetTslEnable();
   }
   
   void UpdateTslPips(){
      trTslPips   = glTradePad.GetTslPips();
   }
   
   void UpdateSplitEnable(){
      trSplitOrderEnable = glTradePad.GetSplitEnable();
   }
   
   void UpdateSplitPercent(){
      trSplitOrderPercent   = glTradePad.GetSplitPercent();
   }
   
   void UpdateExTiDay(){
      trExpireDays   = glTradePad.GetExpirationDay();
   }
   
   void UpdateExTiHour(){
      trExpireHours  = glTradePad.GetExpirationHour();
   }
   
   void UpdateExTiMin(){
      trExpireMinutes  = glTradePad.GetExpirationMinute();
   }
   
   void UpdateEaFiltersEnable(){
      trEaFiltersEnable = glTradePad.GetEaFiltersEnable();
   }
   
//Ticket TRADE
   void UpdateDataByTicket(){
      UpdateOrderType_Ticket();
      
      UpdateHeadRiskPercent_Ticket();
      //UpdateHeadPips_Ticket();
      
      UpdateEntryType_Ticket();
      //UpdateEntryTimeframe_Ticket();
      UpdateEntryPeriod_Ticket();
      //UpdateLookBack_Ticket();
      //UpdateTouchPoints_Ticket();
      
      UpdateExitType_SL_Ticket();
      UpdateExitTimeframe_SL_Ticket();
      UpdateExitPeriod_SL_Ticket();
      
      UpdateExitType_TP_Ticket();
      UpdateExitTimeframe_TP_Ticket();
      UpdateExitPeriod_TP_Ticket();
      
      UpdateBreakEvenEnable_Ticket();
      UpdateBreakEvenPips_Ticket();
      
      UpdateSplitEnable_Ticket();
      UpdateSplitPercent_Ticket();
      
      UpdateExTiDay_Ticket();
      UpdateExTiHour_Ticket();
      UpdateExTiMin_Ticket();
      
      UpdateEaFiltersEnable_Ticket();   
   }
   
   void UpdateOrderType_Ticket(){
      StructOrder or;
      or.Initialize(trTicket);
      
      trOrderType = 
                     or.trType
                     ;
                     
   }
   
   void UpdateHeadRiskPercent_Ticket(){
      trHeadRiskPercent = glTradePad.GetRiskPercent();
   }
   
   /*
   void UpdateHeadPips_Ticket(){
      trHeadPips        = glTradePad.GetHeadPips();
   }
   */
   
   void UpdateEntryType_Ticket(){
      //trEntryType       = TPadEntryTypeDisabled;
      
      trEntryType_Price    = false;
      //trEntryType_Ema      = false;
      trEntryType_Disabled = true;
      //trEntryType       = glTradePad.GetTPadEntryType();
   }
   /*
   void UpdateEntryTimeframe_Ticket(){
      trEntryTimeframe  = glTradePad.GetTimeFrameEntryType();
   }
   */
   void UpdateEntryPeriod_Ticket(){
      trEntryPeriod     = glTradePad.GetEntryPeriod();
   }
   /*
   void UpdateLookBack_Ticket(){
      trLookBack        = glTradePad.GetLookBack();
   }
   */
   /*
   void UpdateTouchPoints_Ticket(){
      trTouchPoints     = glTradePad.GetTouchPoints();
   }
   */
   void UpdateExitType_SL_Ticket(){
      //trExitType_SL        = TPadExitType_SL_Disabled;
      
      trExitType_SL_Ema    = false;
      trExitType_SL_Pips   = false;
      trExitType_SL_Price  = false;
   }
   
   void UpdateExitTimeframe_SL_Ticket(){
      trExitTimeframe_SL   = glTradePad.GetTimeFrameExitType_SL();
   }
   
   void UpdateExitPeriod_SL_Ticket(){
      trExitType_SL_Ema_Period      = glTradePad.GetExitPeriod_SL_Ema();
   }
   
   void UpdateExitType_TP_Ticket(){
      LOG("");
      //trExitType_TP        = TPadExitType_TP_Disabled;
   }
   
   void UpdateExitTimeframe_TP_Ticket(){
      trExitTimeframe_TP   = glTradePad.GetTimeFrameExitType_TP();
   }
   
   void UpdateExitPeriod_TP_Ticket(){
      trExitPeriod_TP      = glTradePad.GetExitPeriod_TP();
   }
   
   void UpdateBreakEvenEnable_Ticket(){
      trBreakEvenEnable = false;//glTradePad.GetBreakEvenEnable();
   }
   
   void UpdateBreakEvenPips_Ticket(){
      trBreakEvenPips   = 0;//glTradePad.GetBreakEvenPips();
   }
   
   void UpdateSplitEnable_Ticket(){
      trSplitOrderEnable = false;//glTradePad.GetSplitEnable();
   }
   
   void UpdateSplitPercent_Ticket(){
      trSplitOrderPercent   = 0;//glTradePad.GetSplitPercent();
   }
   
   void UpdateExTiDay_Ticket(){
      trExpireDays   = 0;//glTradePad.GetExpirationDay();
   }
   
   void UpdateExTiHour_Ticket(){
      trExpireHours  = 0;//glTradePad.GetExpirationHour();
   }
   
   void UpdateExTiMin_Ticket(){
      trExpireMinutes  = 0;//glTradePad.GetExpirationMinute();
   }
   
   void UpdateEaFiltersEnable_Ticket(){
      trEaFiltersEnable = glTradePad.GetEaFiltersEnable();
   }
   
//--- 
   void SetOrderType(){
      glTradePad.SetTPadOrderType(trOrderType);
   }
   
   void SetHeadRiskPercent(){
      glTradePad.SetRiskPercent(trHeadRiskPercent);
   }
   
   /*
   void SetHeadPips(){
      glTradePad.SetHeadPips(trHeadPips);
   }
   */
   /*
   void SetEntryType(){
      glTradePad.SetTPadEntryType(trEntryType);
   }
   */
   void SetEntryType_Price(){
      glTradePad.SetTPadEntryType_Price(trEntryType_Price);
   }
   
   /*
   void SetEntryType_Ema(){
      glTradePad.SetTPadEntryType_Ema(trEntryType_Ema);
   }
   */
   
   void SetEntryType_Disabled(){
      glTradePad.SetTPadEntryType_Disabled(trEntryType_Disabled);
   }
   
   /*
   void SetEntryTimeframe(){
      glTradePad.SetTimeFrameEntryType(trEntryTimeframe);
   }
   */
   void SetEntryPeriod(){
      glTradePad.SetEntryPeriod(trEntryPeriod);
   }
   /*
   void SetLookBack(){
      glTradePad.SetLookBack(trLookBack);
   }
   */
   /*
   void SetTouchPoints(){
      glTradePad.SetTouchPoints(trTouchPoints);
   }
   */
   void SetExitType_SL_Price(){
      glTradePad.SetTPadExitType_SL_Price(trExitType_SL_Price);
   }
   
   void SetExitType_SL_Pips(){
      glTradePad.SetTPadExitType_SL_Pips(trExitType_SL_Pips);
   }
   
   void SetExitType_SL_Ema(){
      glTradePad.SetTPadExitType_SL_Ema(trExitType_SL_Ema);
   }
   
   void SetExitType_SL_Price_Price(){
      glTradePad.SetExitPeriod_SL_Price(trExitType_SL_Price_Price);
   }
   
   void SetExitType_SL_Pips_Pips(){
      glTradePad.SetExitPeriod_SL_Pips(trExitType_SL_Pips_Pips);
   }
   
   void SetExitTimeframe_SL(){
      glTradePad.SetTimeFrameExitType_SL(trExitTimeframe_SL);
   }
   
   void SetExitPeriod_SL(){
      glTradePad.SetExitPeriod_SL_Ema(trExitType_SL_Ema_Period);
   }
   
   void SetExitType_TP(){
      SetExitType_TP_RR();
      SetExitType_TP_Price(HEAD_TO_STRING);
      SetExitType_TP_Indicator();
      SetExitType_TP_Ema();
      
      SetExitType_TP_RR_RR();
      SetExitType_TP_Indicator_Indicator();
      SetExitType_TP_Price_Price();
   }
   
   void SetExitType_TP_RR(){
      glTradePad.SetTPadExitType_TP_RR(trExitType_TP_RR);
   }
   
   void SetExitType_TP_Price(string reason){
      glTradePad.SetTPadExitType_TP_Price(trExitType_TP_Price, reason+"::"+HEAD_TO_STRING);
   }
   
   void SetExitType_TP_Indicator(){
      glTradePad.SetTPadExitType_TP_Indicator(trExitType_TP_Indicator);
   }
   
   void SetExitType_TP_Ema(){
      glTradePad.SetTPadExitType_TP_Ema(trExitType_TP_Ema);
   }
   
   void SetExitType_TP_RR_RR(){
      glTradePad.SetExitPeriod_TP_RR(trExitType_TP_RR_RR);
   }
   
   void SetExitType_TP_Price_Price(){
      glTradePad.SetExitPeriod_TP_Price(trExitType_TP_Price_Price);
   }
   
   void SetExitType_TP_Indicator_Indicator(){
      glTradePad.SetExitPeriod_TP_Indicator(trExitType_TP_Indicator_Indicator);
   }
   
   
   
   void SetExitTimeframe_TP(){
      glTradePad.SetTimeFrameExitType_TP(trExitTimeframe_TP);
   }
   
   void SetExitPeriod_TP(){
      glTradePad.SetExitPeriod_TP(trExitPeriod_TP);
   }
   
   void SetBreakEvenEnable(){
      glTradePad.SetBreakEvenEnable(trBreakEvenEnable);
   }
   
   void SetBreakEvenPips(){
      glTradePad.SetBreakEvenPips(trBreakEvenPips);
   }
   
   void SetTslEnable(){
      glTradePad.SetTslEnable(trTslEnable);
   }
   
   void SetTslPips(){
      glTradePad.SetTslPips(trTslPips);
   }
   
   void SetSplitEnable(){
      glTradePad.SetSplitEnable(trSplitOrderEnable);
   }
   
   void SetSplitPercent(){
      glTradePad.SetSplitPercent(trSplitOrderPercent);
   }
   
   void SetExTiDay(){
      glTradePad.SetExpirationDay(trExpireDays);
   }
   
   void SetExTiHour(){
      glTradePad.SetExpirationHour(trExpireHours);
   }
   
   void SetExTiMin(){
      glTradePad.SetExpirationMinute(trExpireMinutes);
   }
   
   void SetEaFiltersEnable(){
      glTradePad.SetEaFiltersEnable(trEaFiltersEnable);
   }
   
//---
   
   void SetParameters(){
      SetOrderType();
      
      SetHeadRiskPercent();
      //SetHeadPips();
      
      //SetEntryType();
      SetEntryType_Price();
      //SetEntryType_Ema();
      SetEntryType_Disabled();
      //SetEntryTimeframe();
      SetEntryPeriod();
      //SetLookBack();
      //SetTouchPoints();
      
      //SetExitType_SL();
      SetExitType_SL_Ema();
      SetExitType_SL_Pips();
      SetExitType_SL_Price();
      
      SetExitType_SL_Pips_Pips();
      SetExitType_SL_Price_Price();
      
      SetExitTimeframe_SL();
      SetExitPeriod_SL();
      
      SetExitType_TP();
      SetExitTimeframe_TP();
      SetExitPeriod_TP();
      
      SetBreakEvenEnable();
      SetBreakEvenPips();
      
      SetTslEnable();
      SetTslPips();
      
      SetSplitEnable();
      SetSplitPercent();
      
      SetExTiDay();
      SetExTiHour();
      SetExTiMin();
      
      SetEaFiltersEnable();   
   }

//---
   
   string ToString(){
      string val  = StringFormat(
            " || STP: N:%s, iTT?:%s | oT:%s, rPc:%s, hp:%s | enT:%s, enTF:%s, enP:%s | lBk:%s, tPs:%s | exTsl e:%s, exTsl pi:%s, exTsl pr:%s, exTFsl:%s, exPsl:%s | exTtp E:%s, exTtp I:%s, exTtp P:%s, exTtp RR:%s, exTFtp:%s, exPtp:%s | beE?:%s, beP:%s | tslE?:%s, tslP:%s | soE?:%s, soPc:%s  | eD:%s, eH:%s, eM:%s | eaE?:%s || ", 
             trName,
             
             TM.ToString(trIsTableTrade),
             
             EnumToString(trOrderType),
             TM.ToString(trHeadRiskPercent),
             TM.ToString(trHeadPips),
             
             TM.ToString(trEntryType_Price) + ":" + TM.ToString(trEntryType_Ema) + ":" + TM.ToString(trEntryType_Disabled),
             EnumToString(trEntryTimeframe),
             TM.ToString(trEntryPeriod),
             
             TM.ToString(trLookBack),
             TM.ToString(trTouchPoints),
             
             //EnumToString(trExitType_SL),
             TM.ToString(trExitType_SL_Ema),
             TM.ToString(trExitType_SL_Pips),
             TM.ToString(trExitType_SL_Price),
             EnumToString(trExitTimeframe_SL),
             TM.ToString(trExitType_SL_Ema_Period),
             
             //EnumToString(trExitType_TP),
             TM.ToString(trExitType_TP_Ema),
             TM.ToString(trExitType_TP_Indicator),
             TM.ToString(trExitType_TP_Price),
             TM.ToString(trExitType_TP_RR),
             EnumToString(trExitTimeframe_TP),
             TM.ToString(trExitPeriod_TP),
             
             TM.ToString(trBreakEvenEnable),
             TM.ToString(trBreakEvenPips),
             
             TM.ToString(trTslEnable),
             TM.ToString(trTslPips),
             
             TM.ToString(trSplitOrderEnable),
             TM.ToString(trSplitOrderPercent),
             
             TM.ToString(trExpireDays),
             TM.ToString(trExpireHours),
             TM.ToString(trExpireMinutes),
             
             TM.ToString(trEaFiltersEnable)
             
             );
      
      return val;
   }
   
   
};
