//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property strict
#include <stderror.mqh> 
#include <stdlib.mqh> 

#include <ChartObjects\\ChartObjectsLines.mqh>


/*
input int                  env_ma_period_1            = 14;             // MA averaging period 
input int                  env_ma_method_1            = MODE_SMA;       // MA averaging method 
input int                  env_ma_shift_1             = 0;              // moving average shift 
input int                  env_applied_price_1        = PRICE_CLOSE;    // applied price 
input double               env_deviation_1            = 0.10;           // deviation (in percents) 
*/
//23.11.23
struct StructIndicator_Envelopes{
   
   int                  _1_ma_period;
   ENUM_MA_METHOD       _2_ma_method;
   int                  _3_ma_shift;
   ENUM_APPLIED_PRICE   _4_applied_price;
   double               _5_deviation;

   bool                 trIsInitialized;
   
   string ToString(){
      string   val   = StringFormat(" | Envelopes: p:%s, m-d:%s, sh:%s, ap:%s, d:%s | ",
                                       
                                       TM.ToString(_1_ma_period),
                                       EnumToString(_2_ma_method),
                                       TM.ToString(_3_ma_shift),
                                       EnumToString(_4_applied_price),
                                       TM.ToString(_5_deviation)
                                       );
      return   val;                        
   }

   void Initialize(
                     int                  ma_period,
                     ENUM_MA_METHOD       ma_method,
                     int                  ma_shift,
                     ENUM_APPLIED_PRICE   applied_price,
                     double               deviation
   )
   {
      trIsInitialized   = true;
      
      _1_ma_period      = ma_period;
      _2_ma_method      = ma_method;
      _3_ma_shift       = ma_shift;
      _4_applied_price  = applied_price;
      _5_deviation      = deviation;
   }
   
   double GetIndicator(int mode, int shift){
      double val = iEnvelopes(Symbol(),Period(),
      
                                                _1_ma_period,
                                                _2_ma_method,
                                                _3_ma_shift,
                                                _4_applied_price,
                                                _5_deviation,
                                                
                                                mode,shift
                                                );
      return val;                           
   }
};


//12.08.22
struct StructIndicatorArrow{
   datetime          trTime;
   double            trPrice;
   SignalType        trSignalType;
   bool              trIsInitialized;

   void Initialize(int shift, double price, SignalType signalType){
      trIsInitialized   = true;
      trTime            = iTime(_Symbol,_Period,shift);
      trPrice           = price;
      trSignalType      = signalType;
   }
   
   int GetBar(){
      return   iBarShift(_Symbol,_Period,trTime);
   }
   
   string ToString(){
      string   val   = StringFormat(" | StructArrow: st:%s, t:%s, p:%s, b:%s | ",
                                       
                                       EnumToString(trSignalType),
                                       
                                       TM.ToString(trTime),
                                       TM.ToString(trPrice),
                                       
                                       TM.ToString(GetBar())
                                       );
      return   val;                        
   }
};

struct StructSarBreakout{
   string            trPair;
   ENUM_TIMEFRAMES   trTimeframe;

   datetime    trTime;
   
   double      trPrice;
   
   SignalType  trSignalType;
   
   bool        trIsInitialized;
   
   void Initialize(string pair, ENUM_TIMEFRAMES tf, SignalType signal, datetime time, double price){
   
      trIsInitialized   = true;
      
      trPair            = pair;
      trTimeframe       = tf;
      
      trSignalType      = signal;
      
      trTime            = time;
      
      trPrice           = price;
      
      TM.Log(
               HEAD_TO_STRING+
               ToString()
               );
   }
   
   string ToString(){
      string val      = 
                        trIsInitialized ?
                           StringFormat(" | p:%s, tf:%s, st:%s, t:%s, p:%s | ",
                                 TM.ToString(trPair),
                                 EnumToString(trTimeframe),
                                 
                                 EnumToString(trSignalType),
                                 
                                 TM.ToString(trTime),
                                 
                                 TM.ToString(trPrice)
                                 ) :
                           " | null | "
                           ;      
      
      return val;
   }   
};

//09.08.2022
//24.11.2022
struct StructCandle{
   string            trSymbol;
   
   ENUM_TIMEFRAMES   trTimeframe;
   
   datetime          trTime;
   
   double            trOpenPrice;
   double            trClosePrice;
   double            trHighPrice;
   double            trLowPrice;
   
   long              trVolume;
   
   bool              trIsInitialized;
   
   SignalType        trSignalType;

   void Initialize(int shift, string symbol = NULL, ENUM_TIMEFRAMES tf = 0){
      trIsInitialized   = true;
      
      trSymbol          = symbol == NULL ? _Symbol : symbol;
      trTimeframe       = tf == 0 ? (ENUM_TIMEFRAMES)_Period : tf;
      
      trTime            = iTime(trSymbol,trTimeframe,shift);
      
      trOpenPrice       = iOpen(trSymbol,trTimeframe,shift);
      trClosePrice      = iClose(trSymbol,trTimeframe,shift);
      trHighPrice       = iHigh(trSymbol,trTimeframe,shift);
      trLowPrice        = iLow(trSymbol,trTimeframe,shift);
      trVolume          = iVolume(trSymbol,trTimeframe,shift);
      
      trSignalType      = trOpenPrice < trClosePrice ? BUY : trOpenPrice > trClosePrice ? SELL : NO;
   }
   
   void DrawCandle(color clr = NULL){
      if (!trIsInitialized) return;
      
      string   obName   = glPrefix + "CDL_" + TM.ToString(trTime);
      double   price    = trLowPrice + GetCandleSize() / 2;
      
               clr      = clr != NULL ? clr : trSignalType == BUY ? clrOlive : trSignalType == SELL ? clrRed : clrAqua;
      
      CChartObjectTrend trend;
      if (!trend.Create(0, obName, 0, trTime, price, trTime, price))
         trend.Attach(0,obName,0,2);
      trend.Color(clr);
      trend.Width(5);
      trend.Detach();
      
      LOG(
            TM.ToString(GetLastError())
            );
   }
   
   int GetBarShift(){
      return   iBarShift(trSymbol,trTimeframe,trTime);
   }
   
   double GetCandleBody(){
      return   MathAbs(trOpenPrice - trClosePrice);
   }
   
   double GetCandleBody_Pips(){
      return   GetCandleBody() / TM.Pip(trSymbol);
   }
   
   double GetCandleSize(){
      return   MathAbs(trHighPrice - trLowPrice);
   }
   
   double GetCandleSize_Pips(){
      return   GetCandleSize() / TM.Pip(trSymbol);
   }
   
   string ToString(){
      string   val   = 
         !trIsInitialized  ? 
            " | null | " :
            StringFormat(" | StructCandle: s:%s, tf:%s, b:%s, t:%s, st:%s :: O:%s, C:%s, H:%s, L:%s :: V:%s :: cB:%s, cS:%s | ",
                                       TM.ToString(trSymbol),
                                       EnumToString(trTimeframe),
                                       
                                       TM.ToString(GetBarShift()),
                                       TM.ToString(trTime),
                                       
                                       EnumToString(trSignalType),
                                       
                                       TM.ToString(trOpenPrice),
                                       TM.ToString(trClosePrice),
                                       TM.ToString(trHighPrice),
                                       TM.ToString(trLowPrice),
                                       TM.ToString(trVolume),
                                       
                                       TM.ToString(GetCandleBody_Pips()),
                                       TM.ToString(GetCandleSize_Pips())
                                       );
      return   val;                        
   }
};



//23.03.2022
//08.06.2022
struct StructDateTime{
   datetime trTime;
   
   void Initialize(
                     int year,
                     int month,
                     int day,
                     int hour,
                     int minute,
                     int second){
      string time_str = (string)year+"."+(string)month+"."+(string)day+" "+(string)hour+":"+(string)minute+":"+(string)second;
      trTime = StringToTime(time_str);
   }
   
   void PrepairTimeByString(string str_time){
      datetime time_current = TimeCurrent();
      Initialize(
                  TimeYear(time_current),
                  TimeMonth(time_current),
                  TimeDay(time_current),
                  TimeHour(StringToTime(str_time)),
                  TimeMinute(StringToTime(str_time)),
                  TimeSeconds(StringToTime(str_time))
                  );
   }
   
   void PrepairDayByTime(datetime time){
      Initialize(
                  TimeYear(time),
                  TimeMonth(time),
                  TimeDay(time),
                  TimeHour(0),
                  TimeMinute(0),
                  TimeSeconds(0)
                  );
   }
   
   void PrepairTimeByInt(int hour, int minute, int sec){
      datetime time_current = TimeCurrent();
      Initialize(
                  TimeYear(time_current),
                  TimeMonth(time_current),
                  TimeDay(time_current),
                  hour,
                  minute,
                  sec
                  );
   }
   
   void PrepairNyTimeByYear(int year){
      Initialize(
                     year,
                     1,
                     1,
                     0,
                     0,
                     0
                     );
   }
};


struct SPoint{
   double x;
   double y;
   
   string ToString(){
      string   val   = 
         StringFormat(" | SPoint: x:%s, y:%s  | ",
                                       
                                       TM.ToString(x),
                                       TM.ToString(y)
                                       )
                                       ;
      return   val;                        
   }
};


struct StructAlert{
   string   trName;
   
   /*
[PAIRSYMBOL] ENTER TRADE:
SELL : [PAIRSYMBOL] at [PRICE] 2022 DEC 01 GMT-7 00:00:00     
   */
   void Alert_Entry(int open_type){
      double   price    = open_type % 2 == 0 ? Ask    : Bid;
      string   signal   = open_type % 2 == 0 ? "BUY"  : "SELL";
      string   msg      = 
                           TM.ToString(_Symbol) + " " +
                           "ENTER TRADE: " +
                           signal + " : "+
                           TM.ToString(_Symbol) +
                           " at "+
                           TM.ToString(price) + " "+
                           TM.ToString(TimeCurrent())
                           ;
      
      Alert_Send(signal, msg, HEAD_TO_STRING);
   }
   
   /*
[PAIRSYMBOL] EXIT TRADE:
[PAIRSYMBOL] at GMT-7 00:00:00 EXIT [PRICE]
   */
   void Alert_Exit(int close_type){
      double   price    = close_type % 2 == 0 ? Bid    : Ask;
      string   signal   = close_type == -1 ? "BOTH" : close_type == BUY ? "BUY"  : "SELL";
      string   msg      = 
                           TM.ToString(_Symbol) + " " +
                           "EXIT TRADE: " +
                           signal + " : "+
                           TM.ToString(_Symbol) +
                           " at "+
                           TM.ToString(price) + " "+
                           TM.ToString(TimeCurrent())
                           ;
      
      Alert_Send(signal, msg, HEAD_TO_STRING);
   }
   
/*
When TRAILING STOP is Triggered, Alert:
[PAIRSYMBOL] TRAILING STOP TRIGGER:
[PAIRSYMBOL] TRIGGER TS [PRICE] / 2022 DEC 01 GMT-7 00:00:00 
*/   
   
   void Alert_TslTriggered(int ticket, double price){
      string   signal   = "TSL is triggered";
      string   msg      = 
                           TM.ToString(_Symbol) + " " +
                           "Ticket # " +
                           TM.ToString(ticket) + ": " +
                           "TRAILING STOP TRIGGER: " +
                           TM.ToString(_Symbol) +
                           " TRIGGER TS "+
                           TM.ToString(price) + " / "+
                           TM.ToString(TimeCurrent())
                           ;
      
      Alert_Send(signal, msg, HEAD_TO_STRING);
   }
   
/*
When TRAILING STOP is moved, Alert:
[PAIRSYMBOL] MOVE TRAILING STOP:
[PAIRSYMBOL] MOVE TS [PRICE] / 2022 DEC 01 GMT-7 00:00:00 
*/ 

   void Alert_TslMoved(int ticket, double price){
      string   signal   = "TSL is moved";
      string   msg      = 
                           TM.ToString(_Symbol) + " " +
                           "Ticket # " +
                           TM.ToString(ticket) + ": " +
                           "MOVE TRAILING STOP: " +
                           TM.ToString(_Symbol) +
                           " MOVE TS "+
                           TM.ToString(price) + " / "+
                           TM.ToString(TimeCurrent())
                           ;
      
      Alert_Send(signal, msg, HEAD_TO_STRING);
   }
   
/*
When Trade is STOPPED, Alert:
[PAIRSYMBOL] STOP LOSS HIT:
[PAIRSYMBOL] SL HIT [PRICE] / 2022 DEC 01 GMT-7 00:00:00 
TOTAL PIPS: [NUMBER OF PIPS (+/-) FROM ORIGINAL ENTRY] */   
   
   void Alert_SlTriggered(int ticket){
      StructOrder order;
      ZeroMemory(order);
      order.Initialize(ticket,SELECT_BY_TICKET);

      string   signal   = "SL triggered";
      string   msg      = 
                           TM.ToString(_Symbol) + " " +
                           "Ticket # " +
                           TM.ToString(ticket) + ": " +
                           "STOP LOSS HIT: " +
                           TM.ToString(_Symbol) +
                           " SL HIT "+
                           TM.ToString(order.trClosePrice) + " / "+
                           TM.ToString(TimeCurrent())+
                           " TOTAL PIPS: "+
                           TM.ToString(order.GetProfitPips())
                           ;
      
      Alert_Send(signal, msg, HEAD_TO_STRING);
   }
   
/*
When Trade is EXITED or Take Profit, Alert:
[PAIRSYMBOL] EXIT TRADE / TAKE PROFIT:
[PAIRSYMBOL] EXIT TRADE / TAKE PROFIT [PRICE] / 2022 DEC 01 GMT-7 00:00:00
TOTAL PIPS: [NUMBER OF PIPS (+/-) FROM ORIGINAL ENTRY]  
*/   

   void Alert_TpTriggered(int ticket){
      StructOrder order;
      ZeroMemory(order);
      order.Initialize(ticket,SELECT_BY_TICKET);

      string   signal   = "TP triggered";
      string   msg      = 
                           TM.ToString(_Symbol) + " " +
                           "Ticket # " +
                           TM.ToString(ticket) + ": " +
                           "TAKE PROFIT: " +
                           TM.ToString(_Symbol) +
                           " TP HIT "+
                           TM.ToString(order.trClosePrice) + " / "+
                           TM.ToString(TimeCurrent())+
                           " TOTAL PIPS: "+
                           TM.ToString(order.GetProfitPips())
                           ;
      
      Alert_Send(signal, msg, HEAD_TO_STRING);
   }
   
/*
When Trade is EXITED or Take Profit, Alert:
[PAIRSYMBOL] EXIT TRADE / TAKE PROFIT:
[PAIRSYMBOL] EXIT TRADE / TAKE PROFIT [PRICE] / 2022 DEC 01 GMT-7 00:00:00
TOTAL PIPS: [NUMBER OF PIPS (+/-) FROM ORIGINAL ENTRY]  
*/   

   void Alert_ExitTriggered(int ticket){
      StructOrder order;
      ZeroMemory(order);
      order.Initialize(ticket,SELECT_BY_TICKET);

      string   signal   = "Exit triggered";
      string   msg      = 
                           TM.ToString(_Symbol) + " " +
                           "Ticket # " +
                           TM.ToString(ticket) + ": " +
                           "EXIT TRADE: " +
                           TM.ToString(_Symbol) +
                           " EXIT TRADE "+
                           TM.ToString(order.trClosePrice) + " / "+
                           TM.ToString(TimeCurrent())+
                           " TOTAL PIPS: "+
                           TM.ToString(order.GetProfitPips())
                           ;
      
      Alert_Send(signal, msg, HEAD_TO_STRING);
   }
   
   
   private:
   void Alert_Send(string signal, string msg, string reason){
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(signal)+", "+
               TM.ToString(msg)+", "+
               TM.ToString(reason)
               );
               
      if (enable_alert)    Alert(msg);
      if (enable_email)    SendMail(signal,msg);
      if (enable_mobile)   SendNotification(msg);
   }
};


//05.06.2022
//06.06.2022
//08.06.2022
//22.06.2022
//30.06.2022
//01.07.2022
//11.07.2022
//18.07.2022
//30.08.2022
//double ToString() should be 23.06.2022+
//24.11.2022

struct StructOrder{

   ENUM_ORDER_TYPE   trType;

   int      trTicket;
   int      trMagicNumber;
   int      trLastError;
   
   int      trDigits;
   
   string   trSymbol;
   string   trComment;
   
   double   trOpenPrice;
   double   trClosePrice;
   double   trLot;
   double   trStopLoss;
   double   trTakeProfit;
   double   trProfit;
   double   trSwap;
   double   trComission;
   
   datetime trOpenTime;
   datetime trCloseTime;
   datetime trExpiration;
   
   bool     trEnableLog;
   bool     trIsInitialized;
   
   void ReInitialize(string reason, bool isLog){
      if (isLog && trEnableLog){
         TM.Log(
                  HEAD_TO_STRING+
                  ToString()+", "+
                  TM.ToString(reason)
                  );
      }
   
      if (trIsInitialized){
         
         Initialize(trTicket,SELECT_BY_TICKET);
         
         if (isLog && trEnableLog){
            TM.Log(
                     HEAD_TO_STRING+
                     ToString()+", "+
                     TM.ToString(reason)
                     );
         }
      }
   }
   
   void Initialize(int index, int select, int pool = MODE_TRADES){
      ZeroMemory(this);
      if (OrderSelect(index,select,pool)){
         trType         = (ENUM_ORDER_TYPE)OrderType();
      
         trTicket       = OrderTicket();
         trMagicNumber  = OrderMagicNumber();
         
         trSymbol       = OrderSymbol();
         trComment      = OrderComment();
         
         trOpenPrice    = OrderOpenPrice();
         trClosePrice   = OrderClosePrice();
         trLot          = OrderLots();
         trStopLoss     = OrderStopLoss();
         trTakeProfit   = OrderTakeProfit();
         trProfit       = OrderProfit();
         trSwap         = OrderSwap();
         trComission    = OrderCommission();
         
         trOpenTime     = OrderOpenTime();
         trCloseTime    = OrderCloseTime();
         trExpiration   = OrderExpiration();
         
         trDigits       = (int)MarketInfo(trSymbol,MODE_DIGITS);
         
         trEnableLog       = enable_logging;
         trIsInitialized   = true;
      }
   }
   
   string ToString(){
      string val      = 
                        trIsInitialized ?
                           StringFormat(" | t#%s, sym:%s, type:%s, mn:%s, com:%s, op:%s, cp:%s, lot:%s, sl:%s, tp:%s, :: pft:%s, cms:%s, sw:%s :: ot:%s, ct:%s, et:%s  :: ob:%s, cb:%s | ",
                                 TM.ToString(trTicket),
                                 
                                 TM.ToString(trSymbol),
                                 
                                 TM.ToStringOrderType(trType),
                                 TM.ToString(trMagicNumber),
                                 
                                 TM.ToString(trComment),
                                 
                                 TM.ToString(trOpenPrice),
                                 TM.ToString(trClosePrice),
                                 TM.ToString(trLot,2),
                                 
                                 TM.ToString(trStopLoss),
                                 TM.ToString(trTakeProfit),
                                 
                                 TM.ToString(trProfit,2),
                                 TM.ToString(trComission,2),
                                 TM.ToString(trSwap,2),
                                 
                                 TM.ToString(trOpenTime),
                                 TM.ToString(trCloseTime),
                                 TM.ToString(trExpiration),
                                 
                                 TM.ToString(GetOpenBar()),
                                 TM.ToString(GetCloseBar())
                                 ) :
                           " | null | "
                           ;      
      
      return val;
   }   
   
   bool IsCommentEqualTo(string com){
      return trComment == com;
   }
   
   bool IsCommentContain(string com){
      return StringFind(trComment,com) != -1;
   }
   
   double GetProfitTotal(){
      return   trProfit + trComission + trSwap;
   }
   
   string GetCommentClear(){
      string   val   = trComment;
    
      string   sup[];
      TM.ParseStringToArray(val,sup,"[");
      int   size  = ArraySize(sup);
      val   = size > 0 ? sup[0] : val;
      val   = StringTrimLeft(val);
      val   = StringTrimRight(val);
      
      //StringReplace(val,"[sl]","");
      //StringReplace(val,"[tp]","");
      
      return   val;
   }
   
   bool IsClosedByTp(){
      return StringFind(trComment,"[tp]") != -1;
   }
   
   bool IsClosedBySl(){
      return StringFind(trComment,"[sl]") != -1;
   }
   
   double GetStopLossDist(){
      double   val   = 0;
      
      if (trStopLoss > 0){
         val   = MathAbs(trOpenPrice - trStopLoss);
      }
      
      return   val;
   }
   
   double GetStopLossDistPips(){
      double   val   = GetStopLossDist() / TM.Pip(trSymbol);
      
      return   val;
   }
   
   
   double GetProfitPips(){
      double   val   = 0;
      
      if (trType < 2){
         double   closePrice  = trCloseTime == 0   ? GetPriceCurrentClose()   : trClosePrice;
         double   dist        = trType % 2 == 0    ? closePrice - trOpenPrice : trOpenPrice - closePrice;
                  val         = dist / TM.Pip(trSymbol);
      }
      
      return   val;
   }
   
   double Ask(){
      return   MarketInfo(trSymbol,MODE_ASK);
   }
   
   double Bid(){
      return   MarketInfo(trSymbol,MODE_BID);
   }
   
   double GetPriceCurrentOpen(){
      return   trType % 2 == 0 ? Ask() : Bid();
   }
   
   double GetPriceCurrentClose(){
      return   trType % 2 == 0 ? Bid() : Ask();
   }
   
   int GetOpenBar(ENUM_TIMEFRAMES tf = 0){
      return   iBarShift(_Symbol, tf, trOpenTime);
   }
   
   int GetCloseBar(ENUM_TIMEFRAMES tf = 0){
      return   iBarShift(_Symbol, tf, trCloseTime);
   }
   
   bool ModifySLTP(double priceSl, double priceTp, string reason, color clr = clrNONE){
               priceSl  = NormalizeDouble(priceSl,trDigits);
               priceTp  = NormalizeDouble(priceTp,trDigits);
      string   msg   = "MSG: ";
      bool     val   = false;
      
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (trTicket > 0){
            if (!OrderModify(trTicket,trOpenPrice,priceSl,priceTp,0,clr)){ 
               trLastError   = GetLastError();
               
               if (trEnableLog)
                  msg   = (
                           HEAD_TO_STRING+
                           TM.ToString(trTicket)+", "+
                           TM.ToString(trLastError)+", "+
                           TM.ToString(trStopLoss)+", "+
                           TM.ToString(priceSl,trDigits)+", "+
                           TM.ToString(priceTp,trDigits)+", "+
                           TM.ToString(Bid(),trDigits)+", "+
                           TM.ToString(Ask(),trDigits)+", "+
                           TM.ToString(MarketInfo(trSymbol,MODE_STOPLEVEL))+" || "+
                           TM.ToString(ErrorDescription(trLastError))+" || "+
                           ToString()
                           );
            }
            else {
               val   = true;
               
               if (trEnableLog)
                  msg   = (
                              HEAD_TO_STRING+
                              TM.ToString(trTicket)+", "+
                              TM.ToString(Bid(),trDigits)+", "+
                              TM.ToString(Ask(),trDigits)+" || "+
                              TM.ToStringOrder(OrderTicket())+" || "+
                              ToString()
                              );
            }               
         }
      }
      
      if (trEnableLog)
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(val)+", "+
                  TM.ToString(trTicket)+", "+
                  TM.ToString(priceSl,trDigits)+", "+
                  TM.ToString(priceTp,trDigits)+", "+
                  TM.ToString(msg)+", "+
                  TM.ToString(reason)
                  );
      return   val;
   }   
   bool ModifyStopLoss(double price, string reason, color clr = clrNONE){
               price = NormalizeDouble(price,trDigits);
      string   msg   = "MSG: ";
      bool     val   = false;
      
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (trTicket > 0){
            if (!OrderModify(trTicket,trOpenPrice,price,trTakeProfit,0,clr)){ 
               trLastError   = GetLastError();
               
               if (trEnableLog)
                  msg   = (
                           HEAD_TO_STRING+
                           TM.ToString(trTicket)+", "+
                           TM.ToString(trLastError)+", "+
                           TM.ToString(trStopLoss)+", "+
                           TM.ToString(price)+", "+
                           TM.ToString(Bid())+", "+
                           TM.ToString(Ask())+", "+
                           TM.ToString(MarketInfo(trSymbol,MODE_STOPLEVEL))+" || "+
                           TM.ToString(ErrorDescription(trLastError))+" || "+
                           ToString()
                           );
            }
            else {
               val   = true;
               
               if (trEnableLog)
                  msg   = (
                              HEAD_TO_STRING+
                              TM.ToString(trTicket)+", "+
                              TM.ToString(Bid())+", "+
                              TM.ToString(Ask())+" || "+
                              TM.ToStringOrder(OrderTicket())+" || "+
                              ToString()
                              );
            }               
         }
      }
      
      if (trEnableLog)
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(val)+", "+
                  TM.ToString(trTicket)+", "+
                  TM.ToString(price)+", "+
                  TM.ToString(msg)+", "+
                  TM.ToString(reason)
                  );
      return   val;
   }
   
   bool ModifyTakeProfit(double price, string reason, color clr = clrNONE){
               price = NormalizeDouble(price,trDigits);
      string   msg   = "MSG: ";
      bool     val   = false;
      
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (trTicket > 0){
            if (!OrderModify(trTicket,trOpenPrice,trStopLoss,price,0,clr)){ 
               trLastError   = GetLastError();
               
               if (trEnableLog)
                  msg   = (
                           HEAD_TO_STRING+
                           TM.ToString(trTicket)+", "+
                           TM.ToString(trLastError)+", "+
                           TM.ToString(trTakeProfit)+", "+
                           TM.ToString(price)+", "+
                           TM.ToString(Bid())+", "+
                           TM.ToString(Ask())+", "+
                           TM.ToString(MarketInfo(trSymbol,MODE_STOPLEVEL))+" || "+
                           TM.ToString(ErrorDescription(trLastError))+" || "+
                           ToString()
                           );
            }
            else {
               val   = true;
               
               if (trEnableLog)
                  msg   = (
                              HEAD_TO_STRING+
                              TM.ToString(trTicket)+", "+
                              TM.ToString(Bid())+", "+
                              TM.ToString(Ask())+" || "+
                              TM.ToStringOrder(OrderTicket())+" || "+
                              ToString()
                              );
            }               
         }
      }
      
      if (trEnableLog)
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(val)+", "+
                  TM.ToString(trTicket)+", "+
                  TM.ToString(price)+", "+
                  TM.ToString(msg)+", "+
                  TM.ToString(reason)
                  );
      return   val;
   }
   
   bool DeletePendingOrder(string reason, color clr = clrLightBlue){
      bool  val   = false;
      ResetLastError();
      
      if (trEnableLog)
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(reason)+", "+
               ToString()
               );
            
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (!OrderDelete(trTicket,clr)){
            trLastError = GetLastError();
            
            if (trEnableLog)
               TM.Log(
                     HEAD_TO_STRING+
                     "Error while deleting pending trade "+
                     TM.ToString(trLastError)+" || "+
                     TM.ToString(ErrorDescription(trLastError))+" || "+
                     ToString()
                     );
         }
         else{
            val   = true;
            ReInitialize(HEAD_TO_STRING, true);
            
            if (trEnableLog)
               TM.Log(
                     HEAD_TO_STRING+
                     ToString()
                     );
         }
      }
      
      return   val;
   }
   
   int GetTicketPartialClosedOrder(string reason){
      int val = 0;
      string support[]; 
      for (int i = OrdersTotal()-1; i >= 0;i--){
         if (OrderSelect(i,SELECT_BY_POS)){
            int pairs_count = StringSplit(OrderComment(),StringGetCharacter("#",0),support);
            if (pairs_count > 1){
               if (StringFind(support[0],"from") != -1 && StrToInteger(support[1]) == trTicket){
                  val = OrderTicket();
                  if (trEnableLog)
                     TM.Log(  
                           HEAD_TO_STRING+
                           "New ticket after partial close: "+
                           TM.ToString(val)+", "+
                           TM.ToString(reason)+", "+
                           ToString()
                           );
                  break;
               }   
            }
         }   
      }     
      
      if (trEnableLog)
         TM.Log(
            HEAD_TO_STRING+
            TM.ToString(val)+", "+
            TM.ToString(reason)+", "+
            ToString()
            );
            
      return val; 
   }
   
   bool CloseMarketTrade(string reason, double lot = 0, color clr = clrLightBlue){
      bool     val   = false;
      
      ResetLastError();
      double   lots  = lot <= 0 || lot > trLot ? trLot : lot;
      
      if (trEnableLog)
         TM.Log(
            HEAD_TO_STRING+
            TM.ToString(lots,2)+", "+
            TM.ToString(lot,2)+", "+
            TM.ToString(reason)+", "+
            ToString()
            );
      
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (!OrderClose(trTicket,lots,OrderClosePrice(),10*TM.FractFactor(trSymbol),clr)){
            trLastError = GetLastError();
            if (trEnableLog)
               TM.Log(
                  HEAD_TO_STRING+
                  "Error while closing market trade "+
                  TM.ToString(trLastError)+" || "+
                  TM.ToString(ErrorDescription(trLastError))+" || "+
                  ToString()
                  );
         }       
         else{
            val   = true;
            
            ReInitialize(HEAD_TO_STRING, true);
            
            if (trEnableLog)
               TM.Log(
                  HEAD_TO_STRING+
                  ToString()
                  );
         }
      }
      else{
         trLastError   = GetLastError();
         if (trEnableLog)
            TM.Log(
               HEAD_TO_STRING+
               "Error while Select market trade "+
               TM.ToString(trLastError)+" || "+
               TM.ToString(ErrorDescription(trLastError))+" || "+
               ToString()
               );
      }
      
      return   val;
   }
   
   int ModeStopLevel(){
      return   (int)MarketInfo(trSymbol,MODE_STOPLEVEL);
   }
   
   
   bool DestroyTrade(string reason, color clr = clrLightBlue){
      bool  val   = false;
      
      if (trType < 2){
         val   = CloseMarketTrade(reason,0,clr);
      }
      else{
         val   = DeletePendingOrder(reason,clr);
      }
      
      if (trEnableLog)
         TM.Log(
            HEAD_TO_STRING+
            TM.ToString(val)+", "+
            TM.ToString(reason)+" || "+
            ToString()
            );
            
      return   val;      
   }
};
























/*

//05.06.2022
//06.06.2022
//08.06.2022
//22.06.2022
//30.06.2022
//01.07.2022
//11.07.2022
//18.07.2022

//double ToString() should be 23.06.2022+

struct StructOrder{

   ENUM_ORDER_TYPE   trType;

   int      trTicket;
   int      trMagicNumber;
   int      trLastError;
   
   int      trDigits;
   
   string   trSymbol;
   string   trComment;
   
   double   trOpenPrice;
   double   trClosePrice;
   double   trLot;
   double   trStopLoss;
   double   trTakeProfit;
   double   trProfit;
   double   trSwap;
   double   trComission;
   
   datetime trOpenTime;
   datetime trCloseTime;
   datetime trExpiration;
   
   bool     trEnableLog;
   bool     trIsInitialized;
   
   void Initialize(int index, int select, int pool = MODE_TRADES){
      ZeroMemory(this);
      if (OrderSelect(index,select,pool)){
         trType         = (ENUM_ORDER_TYPE)OrderType();
      
         trTicket       = OrderTicket();
         trMagicNumber  = OrderMagicNumber();
         
         trSymbol       = OrderSymbol();
         trComment      = OrderComment();
         
         trOpenPrice    = OrderOpenPrice();
         trClosePrice   = OrderClosePrice();
         trLot          = OrderLots();
         trStopLoss     = OrderStopLoss();
         trTakeProfit   = OrderTakeProfit();
         trProfit       = OrderProfit();
         trSwap         = OrderSwap();
         trComission    = OrderCommission();
         
         trOpenTime     = OrderOpenTime();
         trCloseTime    = OrderCloseTime();
         trExpiration   = OrderExpiration();
         
         trDigits       = (int)MarketInfo(trSymbol,MODE_DIGITS);
         
         trEnableLog       = enable_logging;
         trIsInitialized   = true;
      }
   }
   
   string ToString(){
      string val      = 
                        trIsInitialized ?
                           StringFormat(" | t#%s, sym:%s, type:%s, mn:%s, com:%s, op:%s, cp:%s, lot:%s, sl:%s, tp:%s, :: pft:%s, cms:%s, sw:%s :: ot:%s, ct:%s, et:%s | ",
                                 TM.ToString(trTicket),
                                 
                                 TM.ToString(trSymbol),
                                 
                                 TM.ToStringOrderType(trType),
                                 TM.ToString(trMagicNumber),
                                 
                                 TM.ToString(trComment),
                                 
                                 TM.ToString(trOpenPrice),
                                 TM.ToString(trClosePrice),
                                 TM.ToString(trLot,2),
                                 
                                 TM.ToString(trStopLoss),
                                 TM.ToString(trTakeProfit),
                                 
                                 TM.ToString(trProfit,2),
                                 TM.ToString(trComission,2),
                                 TM.ToString(trSwap,2),
                                 
                                 TM.ToString(trOpenTime),
                                 TM.ToString(trCloseTime),
                                 TM.ToString(trExpiration)
                                 ) :
                           " | null | "
                           ;      
      
      return val;
   }   
   
   bool IsCommentEqualTo(string com){
      return trComment == com;
   }
   
   bool IsCommentContain(string com){
      return StringFind(trComment,com) != -1;
   }
   
   double GetProfitTotal(){
      return   trProfit + trComission + trSwap;
   }
   
   string GetCommentClear(){
      string   val   = trComment;
    
      string   sup[];
      TM.ParseStringToArray(val,sup,"[");
      int   size  = ArraySize(sup);
      val   = size > 0 ? sup[0] : val;
      val   = StringTrimLeft(val);
      val   = StringTrimRight(val);
      
      //StringReplace(val,"[sl]","");
      //StringReplace(val,"[tp]","");
      
      return   val;
   }
   
   bool IsClosedByTp(){
      return StringFind(trComment,"[tp]") != -1;
   }
   
   bool IsClosedBySl(){
      return StringFind(trComment,"[sl]") != -1;
   }
   
   double GetProfitPips(){
      double   val   = 0;
      
      if (trType < 2){
         double   closePrice  = trCloseTime == 0   ? GetPriceCurrentClose()   : trClosePrice;
         double   dist        = trType % 2 == 0    ? closePrice - trOpenPrice : trOpenPrice - closePrice;
                  val         = dist / TM.Pip(trSymbol);
      }
      
      return   val;
   }
   
   double Ask(){
      return   MarketInfo(trSymbol,MODE_ASK);
   }
   
   double Bid(){
      return   MarketInfo(trSymbol,MODE_BID);
   }
   
   double GetPriceCurrentOpen(){
      return   trType % 2 == 0 ? Ask() : Bid();
   }
   
   double GetPriceCurrentClose(){
      return   trType % 2 == 0 ? Bid() : Ask();
   }
   
   bool ModifyStopLoss(double price, string reason, color clr = clrNONE){
               price = NormalizeDouble(price,trDigits);
      string   msg   = "MSG: ";
      bool     val   = false;
      
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (trTicket > 0){
            if (!OrderModify(trTicket,trOpenPrice,price,trTakeProfit,0,clr)){ 
               trLastError   = GetLastError();
               
               if (trEnableLog)
                  msg   = (
                           HEAD_TO_STRING+
                           TM.ToString(trTicket)+", "+
                           TM.ToString(trLastError)+", "+
                           TM.ToString(trStopLoss)+", "+
                           TM.ToString(price)+", "+
                           TM.ToString(Bid())+", "+
                           TM.ToString(Ask())+", "+
                           TM.ToString(MarketInfo(trSymbol,MODE_STOPLEVEL))+" || "+
                           TM.ToString(ErrorDescription(trLastError))+" || "+
                           ToString()
                           );
            }
            else {
               val   = true;
               
               if (trEnableLog)
                  msg   = (
                              HEAD_TO_STRING+
                              TM.ToString(trTicket)+", "+
                              TM.ToString(Bid())+", "+
                              TM.ToString(Ask())+" || "+
                              TM.ToStringOrder(OrderTicket())+" || "+
                              ToString()
                              );
            }               
         }
      }
      
      if (trEnableLog)
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(val)+", "+
                  TM.ToString(trTicket)+", "+
                  TM.ToString(price)+", "+
                  TM.ToString(msg)+", "+
                  TM.ToString(reason)
                  );
      return   val;
   }
   
   bool ModifyTakeProfit(double price, string reason, color clr = clrNONE){
               price = NormalizeDouble(price,trDigits);
      string   msg   = "MSG: ";
      bool     val   = false;
      
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (trTicket > 0){
            if (!OrderModify(trTicket,trOpenPrice,trStopLoss,price,0,clr)){ 
               trLastError   = GetLastError();
               
               if (trEnableLog)
                  msg   = (
                           HEAD_TO_STRING+
                           TM.ToString(trTicket)+", "+
                           TM.ToString(trLastError)+", "+
                           TM.ToString(trTakeProfit)+", "+
                           TM.ToString(price)+", "+
                           TM.ToString(Bid())+", "+
                           TM.ToString(Ask())+", "+
                           TM.ToString(MarketInfo(trSymbol,MODE_STOPLEVEL))+" || "+
                           TM.ToString(ErrorDescription(trLastError))+" || "+
                           ToString()
                           );
            }
            else {
               val   = true;
               
               if (trEnableLog)
                  msg   = (
                              HEAD_TO_STRING+
                              TM.ToString(trTicket)+", "+
                              TM.ToString(Bid())+", "+
                              TM.ToString(Ask())+" || "+
                              TM.ToStringOrder(OrderTicket())+" || "+
                              ToString()
                              );
            }               
         }
      }
      
      if (trEnableLog)
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(val)+", "+
                  TM.ToString(trTicket)+", "+
                  TM.ToString(price)+", "+
                  TM.ToString(msg)+", "+
                  TM.ToString(reason)
                  );
      return   val;
   }
   
   bool DeletePendingOrder(string reason, color clr = clrLightBlue){
      bool  val   = false;
      ResetLastError();
      
      if (trEnableLog)
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(reason)+", "+
               ToString()
               );
            
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (!OrderDelete(trTicket,clr)){
            trLastError = GetLastError();
            
            if (trEnableLog)
               TM.Log(
                     HEAD_TO_STRING+
                     "Error while deleting pending trade "+
                     TM.ToString(trLastError)+" || "+
                     TM.ToString(ErrorDescription(trLastError))+" || "+
                     ToString()
                     );
         }
         else{
            val   = true;
            Initialize(trTicket,SELECT_BY_TICKET);
            if (trEnableLog)
               TM.Log(
                     HEAD_TO_STRING+
                     ToString()
                     );
         }
      }
      
      return   val;
   }
   
   int GetTicketPartialClosedOrder(string reason){
      int val = 0;
      string support[]; 
      for (int i = OrdersTotal()-1; i >= 0;i--){
         if (OrderSelect(i,SELECT_BY_POS)){
            int pairs_count = StringSplit(OrderComment(),StringGetCharacter("#",0),support);
            if (pairs_count > 1){
               if (StringFind(support[0],"from") != -1 && StrToInteger(support[1]) == trTicket){
                  val = OrderTicket();
                  if (trEnableLog)
                     TM.Log(  
                           HEAD_TO_STRING+
                           "New ticket after partial close: "+
                           TM.ToString(val)+", "+
                           TM.ToString(reason)+", "+
                           ToString()
                           );
                  break;
               }   
            }
         }   
      }     
      
      if (trEnableLog)
         TM.Log(
            HEAD_TO_STRING+
            TM.ToString(val)+", "+
            TM.ToString(reason)+", "+
            ToString()
            );
            
      return val; 
   }
   
   bool CloseMarketTrade(string reason, double lot = 0, color clr = clrLightBlue){
      bool     val   = false;
      
      ResetLastError();
      double   lots  = lot <= 0 || lot > trLot ? trLot : lot;
      
      if (trEnableLog)
         TM.Log(
            HEAD_TO_STRING+
            TM.ToString(lots,2)+", "+
            TM.ToString(lot,2)+", "+
            TM.ToString(reason)+", "+
            ToString()
            );
      
      if (OrderSelect(trTicket,SELECT_BY_TICKET)){
         if (!OrderClose(trTicket,lots,OrderClosePrice(),10*TM.FractFactor(trSymbol),clr)){
            trLastError = GetLastError();
            if (trEnableLog)
               TM.Log(
                  HEAD_TO_STRING+
                  "Error while closing market trade "+
                  TM.ToString(trLastError)+" || "+
                  TM.ToString(ErrorDescription(trLastError))+" || "+
                  ToString()
                  );
         }       
         else{
            val   = true;
            
            Initialize(trTicket,SELECT_BY_TICKET);
            if (trEnableLog)
               TM.Log(
                  HEAD_TO_STRING+
                  ToString()
                  );
         }
      }
      else{
         trLastError   = GetLastError();
         if (trEnableLog)
            TM.Log(
               HEAD_TO_STRING+
               "Error while Select market trade "+
               TM.ToString(trLastError)+" || "+
               TM.ToString(ErrorDescription(trLastError))+" || "+
               ToString()
               );
      }
      
      return   val;
   }
   
   int ModeStopLevel(){
      return   (int)MarketInfo(trSymbol,MODE_STOPLEVEL);
   }
   
   
   bool DestroyTrade(string reason, color clr = clrLightBlue){
      bool  val   = false;
      
      if (trType < 2){
         val   = CloseMarketTrade(reason,0,clr);
      }
      else{
         val   = DeletePendingOrder(reason,clr);
      }
      
      if (trEnableLog)
         TM.Log(
            HEAD_TO_STRING+
            TM.ToString(val)+", "+
            TM.ToString(reason)+" || "+
            ToString()
            );
            
      return   val;      
   }
};


*/