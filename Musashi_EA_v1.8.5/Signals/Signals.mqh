//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "..\MQH\Enums.mqh"
#include "SignalBase.mqh"
#include "..\MQH\TradingManager.mqh"
#include "..\MQH\Structs.mqh"


class EntryIndicatorArrowSignal : public Signal{
   public:
   
   EntryIndicatorArrowSignal(){
      name = "EntryIndicatorArrowSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal     = NO;
      
      int      bar      = signal_bar;
      double   up_0     = TM.GetIndicator_Entry(0,bar);
      double   dn_1     = TM.GetIndicator_Entry(1,bar);
      double   up_2     = TM.GetIndicator_Entry(2,bar);
      double   dn_3     = TM.GetIndicator_Entry(3,bar);
      
      bool     isBuy    = up_0 != EMPTY_VALUE || up_2 != EMPTY_VALUE;
      bool     isSell   = dn_1 != EMPTY_VALUE || dn_3 != EMPTY_VALUE;
      
      if (isBuy)
         openSignal = BUY;
      if (isSell)
         openSignal = (openSignal == NO) ? SELL : BOTH;
      
      if (enable_log){
         ArrayResize(openStringVals,0);
      
         TM.AddInArray(openStringVals,TM.ToString(isBuy));
         TM.AddInArray(openStringVals,TM.ToString(isSell));
         
         TM.AddInArray(openStringVals,TM.ToString(SEP));
         TM.AddInArray(openStringVals,TM.ToString(up_0));
         TM.AddInArray(openStringVals,TM.ToString(dn_1));
         TM.AddInArray(openStringVals,TM.ToString(up_2));
         TM.AddInArray(openStringVals,TM.ToString(dn_3));
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal    = NO;
   }
};


//
//class ExitIndicatorArrowSignalsss : public Signal{
//   public:
//   
//   ExitIndicatorArrowSignalsss(){
//      name = "ExitIndicatorArrowSignalsss";
//   }
//   
//   void CalculateOpenSignal(){
//      openSignal     = NO;
//   }
//   
//   void CalculateCloseSignal(){
//      closeSignal    = NO;
//      
//      int      bar      = signal_bar;
//      double   up_0     = TM.GetIndicator_Exit(0,bar);
//      double   dn_1     = TM.GetIndicator_Exit(1,bar);
//      double   up_2     = TM.GetIndicator_Exit(2,bar);
//      double   dn_3     = TM.GetIndicator_Exit(3,bar);
//      
//      bool     isBuy    = up_0 != EMPTY_VALUE || up_2 != EMPTY_VALUE;
//      bool     isSell   = dn_1 != EMPTY_VALUE || dn_3 != EMPTY_VALUE;
//      
//      if (isBuy)
//         closeSignal = BUY;
//      if (isSell)
//         closeSignal = (closeSignal == NO) ? SELL : BOTH;
//      
//      if (enable_log){
//         ArrayResize(closeStringVals,0);
//      
//         TM.AddInArray(closeStringVals,TM.ToString(isBuy));
//         TM.AddInArray(closeStringVals,TM.ToString(isSell));
//         
//         TM.AddInArray(closeStringVals,TM.ToString(SEP));
//         TM.AddInArray(closeStringVals,TM.ToString(up_0));
//         TM.AddInArray(closeStringVals,TM.ToString(dn_1));
//         TM.AddInArray(closeStringVals,TM.ToString(up_2));
//         TM.AddInArray(closeStringVals,TM.ToString(dn_3));
//      }
//      
//   }
//};

/*
class FilterColorMbfxIndicatorSignal : public Signal{
   public:
   int   sTimeFrame;
   int   sIndex;
   
   FilterColorMbfxIndicatorSignal(string pref, int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterColorMbfxIndicatorSignal::"+TM.ToString(pref);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      double   yellow0  = TM.GetMdfx(sIndex,0,signal_bar);
      double   yellow1  = TM.GetMdfx(sIndex,0,signal_bar+1);
      
      double   green0   = TM.GetMdfx(sIndex,1,signal_bar);
      double   green1   = TM.GetMdfx(sIndex,1,signal_bar+1);
      
      double   red0     = TM.GetMdfx(sIndex,2,signal_bar);
      double   red1     = TM.GetMdfx(sIndex,2,signal_bar+1);
      
      
      bool  isFlat   = 
                        (red0 != EMPTY_VALUE && red1 == EMPTY_VALUE) ||
                        (green0 != EMPTY_VALUE && green1 == EMPTY_VALUE) ||
                        (red0 == EMPTY_VALUE && green1 == EMPTY_VALUE)
                        ;
                        
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(openStringVals,TM.ToString(isFlat));
      
      TM.AddInArray(openVals,yellow0);
      TM.AddInArray(openVals,yellow1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,green0);
      TM.AddInArray(openVals,green1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,red0);
      TM.AddInArray(openVals,red1);
      
      if (isFlat)
         openSignal = BOTH;
      else if (green0 != EMPTY_VALUE)
         openSignal = BUY;
      else if (red0 != EMPTY_VALUE)
         openSignal = SELL;
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

class FilterColorAtrIndicatorSignal : public Signal{
   public:
   int   sTimeFrame;
   int   sIndex;
   
   FilterColorAtrIndicatorSignal(string pref, int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterColorAtrIndicatorSignal::"+TM.ToString(pref);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      double   atr            = TM.GetAtr(sIndex,signal_bar);
      
      int      highestIndex   = -1;
      int      lowestIndex    = -1;
      
      double   highestValue   = 0;
      double   lowestValue    = 0;
      
      int      maxCandles     = atr_look_back_X_bar[sIndex];
      
      TM.PrepairExtremAtrIndex(maxCandles,sIndex,highestIndex,highestValue,lowestIndex,lowestValue);
      
      double   triggerLevel      = atr_trigger_level[sIndex];
      
      
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,atr);
      TM.AddInArray(openVals,triggerLevel);
      TM.AddInArray(openVals,highestIndex);
      TM.AddInArray(openVals,highestValue);
      TM.AddInArray(openVals,lowestIndex);
      TM.AddInArray(openVals,lowestValue);
      TM.AddInArray(openVals,maxCandles);
      
      
      if (highestIndex != -1 && lowestIndex != -1){
         
         double   dist  = highestValue - lowestValue;
         double   perc  = dist / 100 * triggerLevel;
         
         double   triggerLevelValue = lowestValue + perc;
      
         
         double   percent        = triggerLevelValue / 100 * atr_percent;
         double   lowLevel       = triggerLevelValue - percent;
         
         bool     isFlat   = 
                              atr >= lowLevel && atr < triggerLevelValue
                              ;
                           
                           
         TM.AddInArray(openStringVals,TM.ToString(SEP));
         TM.AddInArray(openStringVals,"CA:"+TM.ToString(atr));
         TM.AddInArray(openStringVals,"TL:"+TM.ToString(triggerLevelValue));
         TM.AddInArray(openStringVals,"D:"+TM.ToString(dist));
         TM.AddInArray(openStringVals,"%:"+TM.ToString(perc));
         TM.AddInArray(openStringVals,TM.ToString(isFlat));
                           
         TM.AddInArray(openVals,SEP);
         TM.AddInArray(openVals,atr);
         TM.AddInArray(openVals,triggerLevelValue);
         TM.AddInArray(openVals,lowLevel);
         TM.AddInArray(openVals,percent);
         TM.AddInArray(openVals,atr_percent);
         
         if (atr != EMPTY_VALUE){
            if (isFlat)
               openSignal = BOTH;
            else if (atr >= triggerLevelValue)
               openSignal = BUY;
            else if (atr < lowLevel)
               openSignal = SELL;
         }
         
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};


class FilterAccFreeMarginMaxLevelSignal : public Signal{
   public:
   
   FilterAccFreeMarginMaxLevelSignal(){
      name = "FilterAccFreeMarginMaxLevelSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      double   val   = AccountFreeMargin();
      
      TM.AddInArray(openVals,val);
      TM.AddInArray(openVals,acc_free_margin_max_level);
      
      TM.AddInArray(openStringVals,TM.ToString(AccountFreeMarginMode()));
      
      if (val < acc_free_margin_max_level)
         openSignal = BOTH;

   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
   
};

class FilterAccFreeMarginMinLevelSignal : public Signal{
   public:
   
   FilterAccFreeMarginMinLevelSignal(){
      name = "FilterAccFreeMarginMinLevelSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      double   val   = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
      
      TM.AddInArray(openVals,val);
      TM.AddInArray(openVals,acc_free_margin_min_level);
      
      //TM.AddInArray(openStringVals,TM.ToString(AccountFreeMarginMode()));
      
      if (val == 0){
         openSignal = BOTH;
      }
      else if (val > acc_free_margin_min_level)
         openSignal = BOTH;

   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
   
};

class CalculateCurrentRiskSignal : public Signal{
   public:
   double   current_risk;
   
   CalculateCurrentRiskSignal(){
      name = "CalculateCurrentRiskSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = BOTH;
      ArrayResize(openVals,1);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openStringVals,0);
      
      current_risk  = 0;
      
      for (int i = OrdersTotal() - 1; i >= 0; i--){
         if (OrderSelect(i,SELECT_BY_POS)){
            int      or_ticket   = OrderTicket();
            string   or_symbol   = OrderSymbol();
            int      or_type     = OrderType();
            double   or_op       = OrderOpenPrice();
            double   or_sl       = OrderStopLoss();
            double   or_lot      = OrderLots();
   
            double   sl_pips     = or_type == OP_BUY ? (or_op - or_sl) / TM.Pip(or_symbol) : (or_sl - or_op) / TM.Pip(or_symbol);
            
            TM.AddInArray(openVals,SEP);
            TM.AddInArray(openVals,or_ticket);
            TM.AddInArray(openVals,or_op);
            TM.AddInArray(openVals,or_sl);
            TM.AddInArray(openVals,or_lot);
            TM.AddInArray(openVals,sl_pips);
            
            if (sl_pips > 0 && or_sl){
               
               double   risk_amount       = SymbolInfoDouble(or_symbol,SYMBOL_TRADE_TICK_VALUE) * sl_pips * TM.FractFactor(or_symbol) * or_lot;
               double   cur_risk_percent  = (risk_amount / AccountBalance()) * 100;
               
               TM.AddInArray(openVals,cur_risk_percent);
               
               current_risk         += cur_risk_percent;
               
            }
         }
      }
      
      openVals[0] = current_risk;
      
      string   debug = 
                        name+" : "+
                        "OS = "+TM.ToString(EnumToString(openSignal))+", "+
                        "CR = "+TM.ToString(current_risk)
                        ;
      TM.LogCommentDebug(debug);                     
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
   
};
CalculateCurrentRiskSignal* calculateCurrentRiskSignal;




class FilterExitTimeSessionSignal : public Signal{
   public:
   datetime sTimeCur;
   
   datetime sArray_TimeStart[];
   datetime sArray_TimeEnd[];
   
   void CalculateTimeSession(string session){
      sTimeCur    = TimeCurrent();
      ArrayResize(sArray_TimeStart, 0);
      ArrayResize(sArray_TimeEnd, 0);
   
      string   sessions[]; 
      StringSplit(session,StringGetCharacter(";",0),sessions);
      
      for (int i = 0; i < ArraySize(sessions); i++){
         //string   support[]; 
         //StringSplit(sessions[i], StringGetCharacter("/",0), support);
         
         datetime sTimeStart  = TM.StrToTimeModified("00:00");
         datetime sTimeEnd    = TM.StrToTimeModified(sessions[i]);
         
         if (sTimeStart >= sTimeEnd){
            if (sTimeEnd > sTimeCur){
               sTimeStart -= 24 * 60 * 60;
            }
            else{
               sTimeEnd += 24 * 60 * 60;
            }
         }
         
         TM.AddInArray(sArray_TimeStart, sTimeStart);
         TM.AddInArray(sArray_TimeEnd, sTimeEnd);
      }
   }
   
   
   FilterExitTimeSessionSignal(){
      name = "FilterExitTimeSessionSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      CalculateTimeSession(close_time);

      bool  isBoth   = false;
      
      int   sizeS    = ArraySize(sArray_TimeStart);
      int   sizeE    = ArraySize(sArray_TimeEnd);
      
      if (enable_log){
         ArrayResize(openStringVals,0);
         
         TM.AddInArray(openStringVals,TM.ToString(sizeS));
         TM.AddInArray(openStringVals,TM.ToString(sizeE));
         TM.AddInArray(openStringVals,TM.ToString(sTimeCur));
         TM.AddInArray(openStringVals,TM.ToString(close_time));
      }
      
      
      if (sizeS == sizeE && sizeS > 0){
         for (int i = 0; i < sizeE; i++){
         
            datetime sTimeStart  = sArray_TimeStart[i];
            datetime sTimeEnd    = sArray_TimeEnd[i];
            
            bool     isInside    = sTimeCur >= sTimeStart && sTimeCur < sTimeEnd;
            
            if (isInside){
               isBoth   = true;
            }
            
            if (enable_log){
               TM.AddInArray(openStringVals,TM.ToString(SEP));
               TM.AddInArray(openStringVals,TM.ToString(isInside));
               TM.AddInArray(openStringVals,TM.ToString(i));
               TM.AddInArray(openStringVals,TM.ToString(sTimeStart));
               TM.AddInArray(openStringVals,TM.ToString(sTimeEnd));
            }
         }
      }

      if (isBoth)
         openSignal = BOTH;
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      
      bool  isBoth   = openSignal == NO;
      
      if (isBoth)
         closeSignal = BOTH;
         
      if (enable_log){
         ArrayResize(closeStringVals,0);
         
         TM.AddInArray(closeStringVals, TM.ToString(isBoth));
         TM.AddInArray(closeStringVals, EnumToString(openSignal));
      } 
   }
   
};



class FilterMaxMarketTradesSignal : public Signal{
   public:
   int   trTrades;
   
   FilterMaxMarketTradesSignal(){
      name                 = "FilterMaxMarketTradesSignal";
      trIsReadyForSkipping = false;
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int      total = trTrades;
      int      limit = number_of_trades;
      
      TM.AddInArray(openVals,total);
      TM.AddInArray(openVals,limit);

      if (total < limit)
         openSignal = BOTH;
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
FilterMaxMarketTradesSignal* glFilterMaxMarketTradesSignal;

/*
class FilterIchimokuSignal : public Signal{
   public:
   
   FilterIchimokuSignal(){
      name = "FilterIchimokuSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int      bar         = signal_bar;
      
      double   price       = iClose(_Symbol,ichi_timeframe,bar);
      
      double   TENKANSEN   = TM.GetIchimoku(MODE_TENKANSEN,bar);
      double   KIJUNSEN    = TM.GetIchimoku(MODE_KIJUNSEN,bar);
      double   SENKOUSPANA = TM.GetIchimoku(MODE_SENKOUSPANA,bar);
      double   SENKOUSPANB = TM.GetIchimoku(MODE_SENKOUSPANB,bar);
      double   CHIKOUSPAN  = TM.GetIchimoku(MODE_CHIKOUSPAN,bar);
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,price);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,TENKANSEN);
      TM.AddInArray(openVals,KIJUNSEN);
      TM.AddInArray(openVals,SENKOUSPANA);
      TM.AddInArray(openVals,SENKOUSPANB);
      TM.AddInArray(openVals,CHIKOUSPAN);

      if (price > SENKOUSPANA && price > SENKOUSPANB)
         openSignal = BUY;
      if (price < SENKOUSPANA && price < SENKOUSPANB)
         openSignal = openSignal == NO ? SELL : BOTH;
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
*/
/*
class EntryMa1CrossSignal : public Signal{
   public:
   SignalType  sLastSignal;
   
   EntryMa1CrossSignal(){
      name        = "EntryMa1CrossSignal";
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma1_timeframe;
      int               bars  = iBars(_Symbol,tf);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,bars);
      TM.AddInArray(openVals,SEP);
      
      if (sLastSignal == NO){
         TM.AddInArray(openStringVals,"firstInit");
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      
         for (int i = bar + 1; i < bars; i++){
            double   ma    = TM.GetMa1(i);
            double   price = iClose(_Symbol,tf,i);
            price = NormalizeDouble(price,_Digits);
            
            if (ma != EMPTY_VALUE && ma){
               if (ma != price){
                  sLastSignal = price > ma ? BUY : SELL;
                  
                  TM.AddInArray(openStringVals,TM.ToString(i));
                  TM.AddInArray(openStringVals,TM.ToString(ma));
                  TM.AddInArray(openStringVals,TM.ToString(price));
                  TM.AddInArray(openStringVals,"|");
                  
                  break;
               }
            }
         }
      
      }
      
      if (sLastSignal != NO){
      
         double            ma    = TM.GetMa1(bar);
         double            price = iClose(_Symbol,tf,bar);
         price = NormalizeDouble(price,_Digits);
         
         TM.AddInArray(openVals,price);
         TM.AddInArray(openVals,ma);
   
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
         
         if (ma != EMPTY_VALUE && ma){
            
            EnumPriceAboveMa  type  = price_above_ma1;
            
            bool  isAbove  = price > ma;
            bool  isBelow  = price < ma;
            
            bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
            bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
            
            TM.AddInArray(openStringVals,EnumToString(type));
            
            TM.AddInArray(openStringVals,TM.ToString(isBuy));
            TM.AddInArray(openStringVals,TM.ToString(isSell));
            TM.AddInArray(openStringVals,TM.ToString(isAbove));
            TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
            if (isBuy && sLastSignal != BUY){
               sLastSignal = BUY;
               openSignal  = BUY;
            }   
            if (isSell && sLastSignal != SELL){
               sLastSignal = SELL;
               openSignal  = SELL;
            }   
         }   
         
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      }   
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class EntryMa2CrossSignal : public Signal{
   public:
   SignalType  sLastSignal;
   
   EntryMa2CrossSignal(){
      name        = "EntryMa2CrossSignal";
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma2_timeframe;
      int               bars  = iBars(_Symbol,tf);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,bars);
      TM.AddInArray(openVals,SEP);
      
      if (sLastSignal == NO){
         TM.AddInArray(openStringVals,"firstInit");
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      
         for (int i = bar + 1; i < bars; i++){
            double   ma    = TM.GetMa2(i);
            double   price = iClose(_Symbol,tf,i);
            price = NormalizeDouble(price,_Digits);
            
            if (ma != EMPTY_VALUE && ma){
               if (ma != price){
                  sLastSignal = price > ma ? BUY : SELL;
                  
                  TM.AddInArray(openStringVals,TM.ToString(i));
                  TM.AddInArray(openStringVals,TM.ToString(ma));
                  TM.AddInArray(openStringVals,TM.ToString(price));
                  TM.AddInArray(openStringVals,"|");
                  
                  break;
               }
            }
         }
      
      }
      
      if (sLastSignal != NO){
      
         double            ma    = TM.GetMa2(bar);
         double            price = iClose(_Symbol,tf,bar);
         price = NormalizeDouble(price,_Digits);
         
         TM.AddInArray(openVals,price);
         TM.AddInArray(openVals,ma);
   
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
         if (ma != EMPTY_VALUE && ma){
            EnumPriceAboveMa  type  = price_above_ma2;
            
            bool  isAbove  = price > ma;
            bool  isBelow  = price < ma;
            
            bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
            bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
            
            TM.AddInArray(openStringVals,EnumToString(type));
            
            TM.AddInArray(openStringVals,TM.ToString(isBuy));
            TM.AddInArray(openStringVals,TM.ToString(isSell));
            TM.AddInArray(openStringVals,TM.ToString(isAbove));
            TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
            if (isBuy && sLastSignal != BUY){
               sLastSignal = BUY;
               openSignal  = BUY;
            }   
            if (isSell && sLastSignal != SELL){
               sLastSignal = SELL;
               openSignal  = SELL;
            }   
         }   
         
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      }   
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class EntryMa3CrossSignal : public Signal{
   public:
   SignalType  sLastSignal;
   
   EntryMa3CrossSignal(){
      name        = "EntryMa3CrossSignal";
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma3_timeframe;
      int               bars  = iBars(_Symbol,tf);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,bars);
      TM.AddInArray(openVals,SEP);
      
      if (sLastSignal == NO){
         TM.AddInArray(openStringVals,"firstInit");
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      
         for (int i = bar + 1; i < bars; i++){
            double   ma    = TM.GetMa3(i);
            double   price = iClose(_Symbol,tf,i);
            price = NormalizeDouble(price,_Digits);
            
            if (ma != EMPTY_VALUE && ma){
               if (ma != price){
                  sLastSignal = price > ma ? BUY : SELL;
                  
                  TM.AddInArray(openStringVals,TM.ToString(i));
                  TM.AddInArray(openStringVals,TM.ToString(ma));
                  TM.AddInArray(openStringVals,TM.ToString(price));
                  TM.AddInArray(openStringVals,"|");
                  
                  break;
               }
            }
         }
      
      }
      
      if (sLastSignal != NO){
      
         double            ma    = TM.GetMa3(bar);
         double            price = iClose(_Symbol,tf,bar);
         price = NormalizeDouble(price,_Digits);
         
         TM.AddInArray(openVals,price);
         TM.AddInArray(openVals,ma);
   
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
         if (ma != EMPTY_VALUE && ma){
            EnumPriceAboveMa  type  = price_above_ma3;
            
            bool  isAbove  = price > ma;
            bool  isBelow  = price < ma;
            
            bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
            bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
            
            TM.AddInArray(openStringVals,EnumToString(type));
            
            TM.AddInArray(openStringVals,TM.ToString(isBuy));
            TM.AddInArray(openStringVals,TM.ToString(isSell));
            TM.AddInArray(openStringVals,TM.ToString(isAbove));
            TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
            if (isBuy && sLastSignal != BUY){
               sLastSignal = BUY;
               openSignal  = BUY;
            }   
            if (isSell && sLastSignal != SELL){
               sLastSignal = SELL;
               openSignal  = SELL;
            }   
         }   
         
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      }   
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class EntryMa4CrossSignal : public Signal{
   public:
   SignalType  sLastSignal;
   
   EntryMa4CrossSignal(){
      name        = "EntryMa4CrossSignal";
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma4_timeframe;
      int               bars  = iBars(_Symbol,tf);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,bars);
      TM.AddInArray(openVals,SEP);
      
      if (sLastSignal == NO){
         TM.AddInArray(openStringVals,"firstInit");
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      
         for (int i = bar + 1; i < bars; i++){
            double   ma    = TM.GetMa4(i);
            double   price = iClose(_Symbol,tf,i);
            price = NormalizeDouble(price,_Digits);
            
            if (ma != EMPTY_VALUE && ma){
               if (ma != price){
                  sLastSignal = price > ma ? BUY : SELL;
                  
                  TM.AddInArray(openStringVals,TM.ToString(i));
                  TM.AddInArray(openStringVals,TM.ToString(ma));
                  TM.AddInArray(openStringVals,TM.ToString(price));
                  TM.AddInArray(openStringVals,"|");
                  
                  break;
               }
            }
         }
      
      }
      
      if (sLastSignal != NO){
      
         double            ma    = TM.GetMa4(bar);
         double            price = iClose(_Symbol,tf,bar);
         price = NormalizeDouble(price,_Digits);
         
         TM.AddInArray(openVals,price);
         TM.AddInArray(openVals,ma);
   
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
         if (ma != EMPTY_VALUE && ma){
            EnumPriceAboveMa  type  = price_above_ma4;
            
            bool  isAbove  = price > ma;
            bool  isBelow  = price < ma;
            
            bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
            bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
            
            TM.AddInArray(openStringVals,EnumToString(type));
            
            TM.AddInArray(openStringVals,TM.ToString(isBuy));
            TM.AddInArray(openStringVals,TM.ToString(isSell));
            TM.AddInArray(openStringVals,TM.ToString(isAbove));
            TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
            if (isBuy && sLastSignal != BUY){
               sLastSignal = BUY;
               openSignal  = BUY;
            }   
            if (isSell && sLastSignal != SELL){
               sLastSignal = SELL;
               openSignal  = SELL;
            }   
         }   
         
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      }   
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class EntryMa5CrossSignal : public Signal{
   public:
   SignalType  sLastSignal;
   
   EntryMa5CrossSignal(){
      name        = "EntryMa5CrossSignal";
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma5_timeframe;
      int               bars  = iBars(_Symbol,tf);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,bars);
      TM.AddInArray(openVals,SEP);
      
      if (sLastSignal == NO){
         TM.AddInArray(openStringVals,"firstInit");
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      
         for (int i = bar + 1; i < bars; i++){
            double   ma    = TM.GetMa5(i);
            double   price = iClose(_Symbol,tf,i);
            price = NormalizeDouble(price,_Digits);
            
            if (ma != EMPTY_VALUE && ma){
               if (ma != price){
                  sLastSignal = price > ma ? BUY : SELL;
                  
                  TM.AddInArray(openStringVals,TM.ToString(i));
                  TM.AddInArray(openStringVals,TM.ToString(ma));
                  TM.AddInArray(openStringVals,TM.ToString(price));
                  TM.AddInArray(openStringVals,"|");
                  
                  break;
               }
            }
         }
      
      }
      
      if (sLastSignal != NO){
      
         double            ma    = TM.GetMa5(bar);
         double            price = iClose(_Symbol,tf,bar);
         price = NormalizeDouble(price,_Digits);
         
         TM.AddInArray(openVals,price);
         TM.AddInArray(openVals,ma);
   
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
         if (ma != EMPTY_VALUE && ma){
            EnumPriceAboveMa  type  = price_above_ma5;
            
            bool  isAbove  = price > ma;
            bool  isBelow  = price < ma;
            
            bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
            bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
            
            TM.AddInArray(openStringVals,EnumToString(type));
            
            TM.AddInArray(openStringVals,TM.ToString(isBuy));
            TM.AddInArray(openStringVals,TM.ToString(isSell));
            TM.AddInArray(openStringVals,TM.ToString(isAbove));
            TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
            if (isBuy && sLastSignal != BUY){
               sLastSignal = BUY;
               openSignal  = BUY;
            }   
            if (isSell && sLastSignal != SELL){
               sLastSignal = SELL;
               openSignal  = SELL;
            }   
         }   
         
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      }   
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class EntryMa6CrossSignal : public Signal{
   public:
   SignalType  sLastSignal;
   
   EntryMa6CrossSignal(){
      name        = "EntryMa6CrossSignal";
      sLastSignal = NO;
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma6_timeframe;
      int               bars  = iBars(_Symbol,tf);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,bars);
      TM.AddInArray(openVals,SEP);
      
      if (sLastSignal == NO){
         TM.AddInArray(openStringVals,"firstInit");
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      
         for (int i = bar + 1; i < bars; i++){
            double   ma    = TM.GetMa6(i);
            double   price = iClose(_Symbol,tf,i);
            price = NormalizeDouble(price,_Digits);
            
            if (ma != EMPTY_VALUE && ma){
               if (ma != price){
                  sLastSignal = price > ma ? BUY : SELL;
                  
                  TM.AddInArray(openStringVals,TM.ToString(i));
                  TM.AddInArray(openStringVals,TM.ToString(ma));
                  TM.AddInArray(openStringVals,TM.ToString(price));
                  TM.AddInArray(openStringVals,"|");
                  
                  break;
               }
            }
         }
      
      }
      
      if (sLastSignal != NO){
      
         double            ma    = TM.GetMa6(bar);
         double            price = iClose(_Symbol,tf,bar);
         price = NormalizeDouble(price,_Digits);
         
         TM.AddInArray(openVals,price);
         TM.AddInArray(openVals,ma);
   
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
         if (ma != EMPTY_VALUE && ma){
            EnumPriceAboveMa  type  = price_above_ma6;
            
            bool  isAbove  = price > ma;
            bool  isBelow  = price < ma;
            
            bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
            bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
            
            TM.AddInArray(openStringVals,EnumToString(type));
            
            TM.AddInArray(openStringVals,TM.ToString(isBuy));
            TM.AddInArray(openStringVals,TM.ToString(isSell));
            TM.AddInArray(openStringVals,TM.ToString(isAbove));
            TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
            if (isBuy && sLastSignal != BUY){
               sLastSignal = BUY;
               openSignal  = BUY;
            }   
            if (isSell && sLastSignal != SELL){
               sLastSignal = SELL;
               openSignal  = SELL;
            }   
         }   
         
         TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      }   
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class FilterMasInRowSignal : public Signal{
   public:
   
   FilterMasInRowSignal(){
      name = "FilterMasInRowSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int      bar   = signal_bar;

      double   ma1   = TM.GetMa1(bar);
      double   ma2   = TM.GetMa2(bar);
      double   ma3   = TM.GetMa3(bar);
      double   ma4   = TM.GetMa4(bar);
      double   ma5   = TM.GetMa5(bar);
      double   ma6   = TM.GetMa6(bar);
      
      double   maArr[];
      
      if (enable_entry_ma1_filter)
         TM.AddInArray(maArr,ma1);
      if (enable_entry_ma2_filter)
         TM.AddInArray(maArr,ma2);
      if (enable_entry_ma3_filter)
         TM.AddInArray(maArr,ma3);
      if (enable_entry_ma4_filter)
         TM.AddInArray(maArr,ma4);
      if (enable_entry_ma5_filter)
         TM.AddInArray(maArr,ma5);
      if (enable_entry_ma6_filter)
         TM.AddInArray(maArr,ma6);
         
      int   size        = ArraySize(maArr);
      int   buyCount    = 0;
      int   sellCount   = 0;
      
      for (int i = 0; i < size - 1; i++){
         for (int y = i + 1; y < size; y++){
            double   val1  = maArr[i];
            double   val2  = maArr[y];
            
            if (val1 >= val2)
               buyCount++;
            if (val1 <= val2)
               sellCount++;
            
            break;   
         }
      }   
      
      int   pairs    = size - 1;
      bool  isBuy    = buyCount >= pairs;
      bool  isSell   = sellCount >= pairs;
      
      TM.AddInArray(openStringVals,TM.ToString(isBuy));
      TM.AddInArray(openStringVals,TM.ToString(isSell));
      
      TM.AddInArray(openStringVals,TM.ToString(SEP));
      TM.AddInArray(openStringVals,TM.ToString(pairs));
      TM.AddInArray(openStringVals,TM.ToString(buyCount));
      TM.AddInArray(openStringVals,TM.ToString(sellCount));
      
      TM.AddInArray(openStringVals,TM.ToString(SEP));
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_ma1_filter));
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_ma2_filter));
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_ma3_filter));
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_ma4_filter));
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_ma5_filter));
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_ma6_filter));
      
      TM.AddInArray(openStringVals,TM.ToString(SEP));
      TM.AddInArray(openStringVals,TM.ToString(TM.ArraySaveString(maArr,":")));

      if (isBuy)
         openSignal = BUY;
      if (isSell)
         openSignal = openSignal == NO ? SELL : BOTH;
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class ExitPriceAboveMaSignal : public Signal{
   public:
   int   sIndex;
   
   ExitPriceAboveMaSignal(int index){
      sIndex      = index;
      name        = "ExitPriceAboveMaSignal_"+TM.ToString(sIndex+1);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      openSignal  = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     inProfit    = enable_exit_in_profit_ma[sIndex];
      bool     bar         = signal_bar;
      
      ENUM_TIMEFRAMES   tf    = ma_timeframe[sIndex];
      double            ma    = TM.GetMaByIndex(sIndex,bar);
      
      double            price = iClose(_Symbol,tf,bar);
      
      TM.AddInArray(closeStringVals,EnumToString(tf));
      
      TM.AddInArray(closeVals,bar);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,price);
      TM.AddInArray(closeVals,ma);

      if (ma != EMPTY_VALUE && ma){
         EnumPriceAboveMa  type  = price_above_ma1;
         
         bool  isAbove  = price > ma;
         bool  isBelow  = price < ma;
         
         bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
         bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
         
         TM.AddInArray(closeStringVals,EnumToString(type));
         
         TM.AddInArray(closeStringVals,TM.ToString(isBuy));
         TM.AddInArray(closeStringVals,TM.ToString(isSell));
         TM.AddInArray(closeStringVals,TM.ToString(isAbove));
         TM.AddInArray(closeStringVals,TM.ToString(isBelow));
         
         if (isBuy)
            closeSignal = BUY;
         if (isSell)
            closeSignal = closeSignal == NO ? SELL : BOTH;
            
         int   open     = closeSignal == NO ? NO : closeSignal == BOTH ? -1 : closeSignal == BUY ? SELL : BUY;
         int   trades   = TM.GetMarketTrades(open);
         
         TM.AddInArray(closeStringVals,TM.ToString(SEP));
         TM.AddInArray(closeStringVals,EnumToString((SignalType)open));
         TM.AddInArray(closeStringVals,TM.ToString(inProfit));
         TM.AddInArray(closeStringVals,TM.ToString(trades));
         TM.AddInArray(closeStringVals,TM.ToString(SEP));
         
         if (closeSignal != NO && trades && !inProfit){
            TM.SetInProfit(false,HEAD_TO_STRING+TM.ToString(inProfit)+", "+TM.ToString(trades));
         }
            
      }   
   }
};


class FilterMa1Signal : public Signal{
   public:
   
   FilterMa1Signal(){
      name = "FilterMa1Signal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma1_timeframe;
      double            ma    = TM.GetMa1(bar);
      
      double            price = iClose(_Symbol,tf,bar);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,price);
      TM.AddInArray(openVals,ma);

      if (ma != EMPTY_VALUE && ma){
         EnumPriceAboveMa  type  = price_above_ma1;
         
         bool  isAbove  = price > ma;
         bool  isBelow  = price < ma;
         
         bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
         bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
         
         TM.AddInArray(openStringVals,EnumToString(type));
         
         TM.AddInArray(openStringVals,TM.ToString(isBuy));
         TM.AddInArray(openStringVals,TM.ToString(isSell));
         TM.AddInArray(openStringVals,TM.ToString(isAbove));
         TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
         if (isBuy)
            openSignal = BUY;
         if (isSell)
            openSignal = openSignal == NO ? SELL : BOTH;
      }   
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class FilterMa2Signal : public Signal{
   public:
   
   FilterMa2Signal(){
      name = "FilterMa2Signal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma2_timeframe;
      double            ma    = TM.GetMa2(bar);
      
      double            price = iClose(_Symbol,tf,bar);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,price);
      TM.AddInArray(openVals,ma);

      if (ma != EMPTY_VALUE && ma){
         EnumPriceAboveMa  type  = price_above_ma2;
         
         bool  isAbove  = price > ma;
         bool  isBelow  = price < ma;
         
         bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
         bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
         
         TM.AddInArray(openStringVals,EnumToString(type));
         
         TM.AddInArray(openStringVals,TM.ToString(isBuy));
         TM.AddInArray(openStringVals,TM.ToString(isSell));
         TM.AddInArray(openStringVals,TM.ToString(isAbove));
         TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
         if (isBuy)
            openSignal = BUY;
         if (isSell)
            openSignal = openSignal == NO ? SELL : BOTH;
      }   
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class FilterMa3Signal : public Signal{
   public:
   
   FilterMa3Signal(){
      name = "FilterMa3Signal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma3_timeframe;
      double            ma    = TM.GetMa3(bar);
      
      double            price = iClose(_Symbol,tf,bar);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,price);
      TM.AddInArray(openVals,ma);

      if (ma != EMPTY_VALUE && ma){
         EnumPriceAboveMa  type  = price_above_ma3;
         
         bool  isAbove  = price > ma;
         bool  isBelow  = price < ma;
         
         bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
         bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
         
         TM.AddInArray(openStringVals,EnumToString(type));
         
         TM.AddInArray(openStringVals,TM.ToString(isBuy));
         TM.AddInArray(openStringVals,TM.ToString(isSell));
         TM.AddInArray(openStringVals,TM.ToString(isAbove));
         TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
         if (isBuy)
            openSignal = BUY;
         if (isSell)
            openSignal = openSignal == NO ? SELL : BOTH;
      }   
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class FilterMa4Signal : public Signal{
   public:
   
   FilterMa4Signal(){
      name = "FilterMa4Signal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma4_timeframe;
      double            ma    = TM.GetMa4(bar);
      
      double            price = iClose(_Symbol,tf,bar);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,price);
      TM.AddInArray(openVals,ma);

      if (ma != EMPTY_VALUE && ma){
         EnumPriceAboveMa  type  = price_above_ma4;
         
         bool  isAbove  = price > ma;
         bool  isBelow  = price < ma;
         
         bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
         bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
         
         TM.AddInArray(openStringVals,EnumToString(type));
         
         TM.AddInArray(openStringVals,TM.ToString(isBuy));
         TM.AddInArray(openStringVals,TM.ToString(isSell));
         TM.AddInArray(openStringVals,TM.ToString(isAbove));
         TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
         if (isBuy)
            openSignal = BUY;
         if (isSell)
            openSignal = openSignal == NO ? SELL : BOTH;
      }   
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class FilterMa5Signal : public Signal{
   public:
   
   FilterMa5Signal(){
      name = "FilterMa5Signal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma5_timeframe;
      double            ma    = TM.GetMa5(bar);
      
      double            price = iClose(_Symbol,tf,bar);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,price);
      TM.AddInArray(openVals,ma);

      if (ma != EMPTY_VALUE && ma){
         EnumPriceAboveMa  type  = price_above_ma5;
         
         bool  isAbove  = price > ma;
         bool  isBelow  = price < ma;
         
         bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
         bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
         
         TM.AddInArray(openStringVals,EnumToString(type));
         
         TM.AddInArray(openStringVals,TM.ToString(isBuy));
         TM.AddInArray(openStringVals,TM.ToString(isSell));
         TM.AddInArray(openStringVals,TM.ToString(isAbove));
         TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
         if (isBuy)
            openSignal = BUY;
         if (isSell)
            openSignal = openSignal == NO ? SELL : BOTH;
      }   
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class FilterMa6Signal : public Signal{
   public:
   
   FilterMa6Signal(){
      name = "FilterMa6Signal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int               bar   = signal_bar;
      ENUM_TIMEFRAMES   tf    = ma6_timeframe;
      double            ma    = TM.GetMa6(bar);
      
      double            price = iClose(_Symbol,tf,bar);
      
      TM.AddInArray(openStringVals,EnumToString(tf));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,price);
      TM.AddInArray(openVals,ma);

      if (ma != EMPTY_VALUE && ma){
         EnumPriceAboveMa  type  = price_above_ma6;
         
         bool  isAbove  = price > ma;
         bool  isBelow  = price < ma;
         
         bool  isBuy    = type == PriceAboveMaBuy ? isAbove : isBelow;
         bool  isSell   = type == PriceAboveMaBuy ? isBelow : isAbove;
         
         TM.AddInArray(openStringVals,EnumToString(type));
         
         TM.AddInArray(openStringVals,TM.ToString(isBuy));
         TM.AddInArray(openStringVals,TM.ToString(isSell));
         TM.AddInArray(openStringVals,TM.ToString(isAbove));
         TM.AddInArray(openStringVals,TM.ToString(isBelow));
         
         if (isBuy)
            openSignal = BUY;
         if (isSell)
            openSignal = openSignal == NO ? SELL : BOTH;
      }   
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
*/


/*
class FilterLowestIndexSignal : public Signal{
   public:
   int   sLowestIndex;
   
   FilterLowestIndexSignal(){
      name = "FilterLowestIndexSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,1);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      sLowestIndex   = -1;
      
      int   size  = ArraySize(panel.mainLines);
      
      TM.AddInArray(openStringVals,TM.ToString(size));
      TM.AddInArray(openStringVals," | ");
      
      for (int i = 0; i < size; i++){
         
         ColCeil *col    = panel.mainLines[i].columns[0];
         string   clName      = col.clName;
         bool     isEnabled   = col.CheckIsEnabled();
         int      index       = col.clIndex;
         int      tf          = col.clTimeframe;
      
         TM.AddInArray(openStringVals,TM.ToString(clName+" : "+TM.ToString(isEnabled) + " : " + TM.ToString(EnumToString(ENUM_TIMEFRAMES(tf)))));
         
         if (sLowestIndex == -1 && isEnabled){
            sLowestIndex   = index;
         }
      }
      
      openStringVals[0] = TM.ToString(sLowestIndex);
      
      if (sLowestIndex != -1)
         openSignal = BOTH;
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
   
};
FilterLowestIndexSignal *filterLowestIndexSignal;
*/
/*
class FilterLowestIndexNewBarSignal : public Signal{
   public:
   int   sLowestIndex;
   
   FilterLowestIndexNewBarSignal(){
      name = "FilterLowestIndexNewBarSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      sLowestIndex   = filterLowestIndexSignal.sLowestIndex;
      
      TM.AddInArray(openStringVals,TM.ToString(sLowestIndex));
      
      if (sLowestIndex != -1){
         bool  newBar   = TM.new_bars[sLowestIndex];
         TM.AddInArray(openStringVals,TM.ToString(newBar));
         
         if (newBar){
            openSignal  = BOTH;
         }
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
   
};

class FilterNewBarLowestIndexSignal : public Signal{
   public:
   
   FilterNewBarLowestIndexSignal(){
      name        = "FilterNewBarLowestIndexSignal::";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      
      TM.AddInArray(openVals,index);
      
      if (index != -1){
         bool  newBar   = TM.new_bars[index];
         
         if (newBar)
            openSignal  = BOTH;
      
      }
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class Entry_MbfxPyr_1_ColorChangedCrossingMbfxIndicatorSignal : public Signal{
   public:
   int         sTimeFrame;
   
   Entry_MbfxPyr_1_ColorChangedCrossingMbfxIndicatorSignal(int timeFrame){
      sTimeFrame  = timeFrame;
      name        = "Entry_MbfxPyr_1_ColorChangedCrossingMbfxIndicatorSignal::"+EnumToString((ENUM_TIMEFRAMES)sTimeFrame);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);

      int      bar      = signal_bar;
      
      double   yellow0  = TM.GetMdfxPyr1(sTimeFrame,0,bar);
      double   yellow1  = TM.GetMdfxPyr1(sTimeFrame,0,bar+1);
      
      double   green0   = TM.GetMdfxPyr1(sTimeFrame,1,bar);
      double   green1   = TM.GetMdfxPyr1(sTimeFrame,1,bar+1);
      
      double   red0     = TM.GetMdfxPyr1(sTimeFrame,2,bar);
      double   red1     = TM.GetMdfxPyr1(sTimeFrame,2,bar+1);
      
      
      bool     redToYellow    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     greenToYellow  = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      //bool     clrChange      = enable_entry_clr_change[sIndex];
      
      double   buyEntryLevelUp  = mbfx_pyr_buy_level_up_1;
      double   buyEntryLevelDn  = mbfx_pyr_buy_level_dn_1;
      
      double   sellEntryLevelUp = mbfx_pyr_sell_level_up_1;
      double   sellEntryLevelDn = mbfx_pyr_sell_level_dn_1;
      
      //TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(openStringVals,TM.ToString(redToYellow));
      TM.AddInArray(openStringVals,TM.ToString(greenToYellow));
      //TM.AddInArray(openStringVals,TM.ToString(clrChange));
      
      TM.AddInArray(openVals,buyEntryLevelUp);
      TM.AddInArray(openVals,buyEntryLevelDn);
      TM.AddInArray(openVals,sellEntryLevelUp);
      TM.AddInArray(openVals,sellEntryLevelDn);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,yellow0);
      TM.AddInArray(openVals,yellow1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,green0);
      TM.AddInArray(openVals,green1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,red0);
      TM.AddInArray(openVals,red1);
      
      string   reason   = "";
      
      if (redToYellow && yellow0 >= buyEntryLevelDn && yellow0 <= buyEntryLevelUp){
         openSignal  = BUY;
         reason   += "redToYellow | ";
      }
         
      if (greenToYellow && yellow0 <= sellEntryLevelUp && yellow0 >= sellEntryLevelDn){
         openSignal  = SELL;
         reason   += "greenToYellow | ";
      }   
        
      TM.AddInArray(openStringVals,TM.ToString(reason));
         
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/
/*
class Filter_MbfxPyr_2_ColorAboveMbfxIndicatorSignal : public Signal{
   public:
   int         sTimeFrame;
   
   Filter_MbfxPyr_2_ColorAboveMbfxIndicatorSignal(int tf){
      sTimeFrame  = tf;
      name        = "Filter_MbfxPyr_2_ColorAboveMbfxIndicatorSignal::"+EnumToString((ENUM_TIMEFRAMES)sTimeFrame);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      
      int      bar      = 1;
      double   yellow0  = TM.GetMdfxPyr2(sTimeFrame,0,bar);
      double   yellow1  = TM.GetMdfxPyr2(sTimeFrame,0,bar+1);
      
      double   green0   = TM.GetMdfxPyr2(sTimeFrame,1,bar);
      double   green1   = TM.GetMdfxPyr2(sTimeFrame,1,bar+1);
      
      double   red0     = TM.GetMdfxPyr2(sTimeFrame,2,bar);
      double   red1     = TM.GetMdfxPyr2(sTimeFrame,2,bar+1);
      
      bool     isIgnore = mbfx_pyr_ignore_color_2;
      double   buy0     = isIgnore ? yellow0 : green0;
      double   buy1     = isIgnore ? yellow1 : green1;
      double   sell0    = isIgnore ? yellow0 : red0;
      double   sell1    = isIgnore ? yellow1 : red1;
      
      
      double   buyEntryLevelUp   = mbfx_pyr_buy_level_up_2;
      double   buyEntryLevelDn   = mbfx_pyr_buy_level_dn_2;
      double   sellEntryLevelUp  = mbfx_pyr_sell_level_up_2;
      double   sellEntryLevelDn  = mbfx_pyr_sell_level_dn_2;
      
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,buyEntryLevelUp);
      TM.AddInArray(openVals,buyEntryLevelDn);
      TM.AddInArray(openVals,sellEntryLevelUp);
      TM.AddInArray(openVals,sellEntryLevelDn);
      
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,buy0);
      TM.AddInArray(openVals,buy1);
      TM.AddInArray(openVals,sell0);
      TM.AddInArray(openVals,sell1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,yellow0);
      TM.AddInArray(openVals,yellow1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,green0);
      TM.AddInArray(openVals,green1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,red0);
      TM.AddInArray(openVals,red1);
      
      if (buy0 != EMPTY_VALUE && buy1 != EMPTY_VALUE && buy0 > buyEntryLevelDn && buy0 < buyEntryLevelUp){
         openSignal  = BUY;
      }
         
      if (sell0 != EMPTY_VALUE && sell1 != EMPTY_VALUE && sell0 < sellEntryLevelUp && sell0 > sellEntryLevelDn){
         openSignal  = openSignal == NO ? SELL : BOTH;
      } 
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
*/
/*
//Filter_MbfxPyr_2_ColorAboveMbfxIndicatorSignal
class Filter_MbfxPyr_MaxTradesSignal : public Signal{
   public:
   
   Filter_MbfxPyr_MaxTradesSignal(){
      name = "Filter_MbfxPyr_MaxTradesSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int   market   = TM.GetMarketTrades();
      int   pending  = TM.GetPendingTrades();
      int   total    = market + pending;
      int   max      = mbfx_pyr_max_pyramid_trades;
      
      TM.AddInArray(openVals,total);
      TM.AddInArray(openVals,max);
      
      TM.AddInArray(openVals,market);
      TM.AddInArray(openVals,pending);

      if (total && total < max)
         openSignal = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
*/

/*
class Filter_MbfxPyr_LastTradeInDirectionSignal : public Signal{
   public:
   
   Filter_MbfxPyr_LastTradeInDirectionSignal(){
      name = "Filter_MbfxPyr_LastTradeInDirectionSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int      lastTicket  = TM.GetLastTicketByType(-1);
      double   limit       = mbfx_pyr_equity_grown;
      
      TM.AddInArray(openStringVals,TM.ToString(lastTicket));
      TM.AddInArray(openStringVals,TM.ToString(limit));
      TM.AddInArray(openStringVals,TM.ToString(SEP));
      
      if (lastTicket > 0){
         StructOrder or;
         or.Initialize(lastTicket);
         int      type     = or.trType;
         double   profit   = or.GetProfitTotal();
         
         bool     isReady  = profit >= limit;
         
         TM.AddInArray(openStringVals,TM.ToString(isReady));
         TM.AddInArray(openStringVals,TM.ToString(profit));
         TM.AddInArray(openStringVals,TM.ToString(limit));
         TM.AddInArray(openStringVals,TM.ToString(or.ToString()));
         
         if (isReady){
            openSignal = SignalType(type % 2);
         }
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
*/








/*
class EntryColorChangedCrossingMbfxIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   EntryColorChangedCrossingMbfxIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "EntryColorChangedCrossingMbfxIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      
      if (!isLowestIndex && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      double   yellow0  = TM.GetMdfx(sIndex,0,signal_bar);
      double   yellow1  = TM.GetMdfx(sIndex,0,signal_bar+1);
      
      double   green0   = TM.GetMdfx(sIndex,1,signal_bar);
      double   green1   = TM.GetMdfx(sIndex,1,signal_bar+1);
      
      double   red0     = TM.GetMdfx(sIndex,2,signal_bar);
      double   red1     = TM.GetMdfx(sIndex,2,signal_bar+1);
      
      
      bool     redToYellow    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     greenToYellow  = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      //bool     clrChange      = enable_entry_clr_change[sIndex];
      
      double   buyEntryLevelUp  = mbfx_entry_buy_level_up[sIndex];
      double   buyEntryLevelDn  = mbfx_entry_buy_level_dn[sIndex];
      
      double   sellEntryLevelUp = mbfx_entry_sell_level_up[sIndex];
      double   sellEntryLevelDn = mbfx_entry_sell_level_dn[sIndex];
      
      //TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(openStringVals,TM.ToString(redToYellow));
      TM.AddInArray(openStringVals,TM.ToString(greenToYellow));
      //TM.AddInArray(openStringVals,TM.ToString(clrChange));
      
      TM.AddInArray(openVals,buyEntryLevelUp);
      TM.AddInArray(openVals,buyEntryLevelDn);
      TM.AddInArray(openVals,sellEntryLevelUp);
      TM.AddInArray(openVals,sellEntryLevelDn);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,yellow0);
      TM.AddInArray(openVals,yellow1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,green0);
      TM.AddInArray(openVals,green1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,red0);
      TM.AddInArray(openVals,red1);
      
      string   reason   = "";
      
      if (redToYellow && yellow0 >= buyEntryLevelDn && yellow0 <= buyEntryLevelUp){
         openSignal  = BUY;
         reason   += "redToYellow | ";
      }
         
      if (greenToYellow && yellow0 <= sellEntryLevelUp && yellow0 >= sellEntryLevelDn){
         openSignal  = SELL;
         reason   += "greenToYellow | ";
      }   
        
      TM.AddInArray(openStringVals,TM.ToString(reason));
         
         
      if (!isLowestIndex)
         openSignal = BOTH;
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class EntryColorChangedTrendDirForceIndexIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   EntryColorChangedTrendDirForceIndexIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "EntryColorChangedTrendDirForceIndexIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      
      if (!isLowestIndex && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      double   blue0    = TM.GetTrendDirForceIndex(sIndex,3,signal_bar);
      double   blue1    = TM.GetTrendDirForceIndex(sIndex,3,signal_bar+1);
      
      double   pink0    = TM.GetTrendDirForceIndex(sIndex,5,signal_bar);
      double   pink1    = TM.GetTrendDirForceIndex(sIndex,5,signal_bar+1);
      
      
      bool     noToBlue = blue1 == EMPTY_VALUE && blue0 != EMPTY_VALUE;
      bool     noToPink = pink1 == EMPTY_VALUE && pink0 != EMPTY_VALUE;
      
      
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(openStringVals,TM.ToString(noToBlue));
      TM.AddInArray(openStringVals,TM.ToString(noToPink));
      
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,blue0);
      TM.AddInArray(openVals,blue1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,pink0);
      TM.AddInArray(openVals,pink1);
      
      string   reason   = "";
      
      if (noToBlue){
         openSignal  = BUY;
         reason   += "noToBlue | ";
      }
         
      if (noToPink){
         openSignal  = SELL;
         reason   += "noToPink | ";
      }   
        
      TM.AddInArray(openStringVals,TM.ToString(reason));
         
         
      if (!isLowestIndex)
         openSignal = BOTH;
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
EntryColorChangedTrendDirForceIndexIndicatorSignal* glEntryColorChangedTrendDirForceIndexIndicatorSignal[9];
*/

/*
class FilterColorTrendDirForceIndexIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   FilterColorTrendDirForceIndexIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterColorTrendDirForceIndexIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;
      bool     isEnabled      = panel.CheckIsEntryEnabledByIndex(sIndex);
      
      TM.AddInArray(openStringVals,TM.ToString(isEnabled));
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,TM.ToString(trend_direction_force_on_first_candle_enable));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      if (!isEnabled){
         openSignal = BOTH;
         return;
      }   
      
      string   reason   = "";
      
      if (isLowestIndex && trend_direction_force_on_first_candle_enable){
         SignalType  signal   = glEntryColorChangedTrendDirForceIndexIndicatorSignal[sIndex].GetOpenSignal();
         
         TM.AddInArray(openStringVals,EnumToString(signal));
         
         if (signal != NO){
            reason   += "entry != NO | ";
            TM.AddInArray(openStringVals,TM.ToString(reason));
            
            openSignal  = signal;
            return;
         }
      }
      
      double   blue0    = TM.GetTrendDirForceIndex(sIndex,3,signal_bar);
      double   blue1    = TM.GetTrendDirForceIndex(sIndex,3,signal_bar+1);
      
      double   pink0    = TM.GetTrendDirForceIndex(sIndex,5,signal_bar);
      double   pink1    = TM.GetTrendDirForceIndex(sIndex,5,signal_bar+1);
      
      
      bool     blue     = blue1 != EMPTY_VALUE && blue0 != EMPTY_VALUE;
      bool     pink     = pink1 != EMPTY_VALUE && pink0 != EMPTY_VALUE;
      
      
      TM.AddInArray(openStringVals,TM.ToString(blue));
      TM.AddInArray(openStringVals,TM.ToString(pink));
      
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,blue0);
      TM.AddInArray(openVals,blue1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,pink0);
      TM.AddInArray(openVals,pink1);
      
      
      if (blue){
         openSignal  = BUY;
         reason   += "blue | ";
      }
         
      if (pink){
         openSignal  = SELL;
         reason   += "pink | ";
      }   
        
      TM.AddInArray(openStringVals,TM.ToString(reason));
         
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class EntryOsMAIndicatorCrossLevelSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   EntryOsMAIndicatorCrossLevelSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "EntryOsMAIndicatorCrossLevelSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      
      if (!isLowestIndex && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      double   buf0           = TM.GetOsMA(sIndex,0,signal_bar);
      double   buf1           = TM.GetOsMA(sIndex,0,signal_bar+1);
      
      bool     isJpy          = StringFind(_Symbol,"JPY") != -1;
      double   coef           = isJpy ? 100 : 1;
      
      double   levelLong1     = osma_level_long_1 * coef;
      double   levelLong2     = osma_level_long_2 * coef;
      double   levelLong3     = osma_level_long_3 * coef;
      double   levelLong4     = osma_level_long_4 * coef;
      double   levelLong5     = osma_level_long_5 * coef;
      double   levelLong6     = osma_level_long_6 * coef;
      double   levelLong7     = osma_level_long_7 * coef;
      
      double   levelShort1     = osma_level_short_1 * coef;
      double   levelShort2     = osma_level_short_2 * coef;
      double   levelShort3     = osma_level_short_3 * coef;
      double   levelShort4     = osma_level_short_4 * coef;
      double   levelShort5     = osma_level_short_5 * coef;
      double   levelShort6     = osma_level_short_6 * coef;
      double   levelShort7     = osma_level_short_7 * coef;
      
      bool     crossBuy1      = buf0 >= levelLong1 && buf1 < levelLong1;
      bool     crossBuy2      = buf0 >= levelLong2 && buf1 < levelLong2;
      bool     crossBuy3      = buf0 >= levelLong3 && buf1 < levelLong3;
      bool     crossBuy4      = buf0 >= levelLong4 && buf1 < levelLong4;
      bool     crossBuy5      = buf0 >= levelLong5 && buf1 < levelLong5;
      bool     crossBuy6      = buf0 >= levelLong6 && buf1 < levelLong6;
      bool     crossBuy7      = buf0 >= levelLong7 && buf1 < levelLong7;
      
      bool     crossSell1     = buf0 <= levelShort1 && buf1 > levelShort1;
      bool     crossSell2     = buf0 <= levelShort2 && buf1 > levelShort2;
      bool     crossSell3     = buf0 <= levelShort3 && buf1 > levelShort3;
      bool     crossSell4     = buf0 <= levelShort4 && buf1 > levelShort4;
      bool     crossSell5     = buf0 <= levelShort5 && buf1 > levelShort5;
      bool     crossSell6     = buf0 <= levelShort6 && buf1 > levelShort6;
      bool     crossSell7     = buf0 <= levelShort7 && buf1 > levelShort7;
      
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(openStringVals,TM.ToString(isJpy));
      TM.AddInArray(openStringVals,TM.ToString(coef));
      TM.AddInArray(openStringVals,TM.ToString(SEP));

      TM.AddInArray(openStringVals,TM.ToString(crossBuy1));
      TM.AddInArray(openStringVals,TM.ToString(crossBuy2));
      TM.AddInArray(openStringVals,TM.ToString(crossBuy3));
      TM.AddInArray(openStringVals,TM.ToString(crossBuy4));
      TM.AddInArray(openStringVals,TM.ToString(crossBuy5));
      TM.AddInArray(openStringVals,TM.ToString(crossBuy6));
      TM.AddInArray(openStringVals,TM.ToString(crossBuy7));
      TM.AddInArray(openStringVals,TM.ToString(SEP));
      
      TM.AddInArray(openStringVals,TM.ToString(crossSell1));
      TM.AddInArray(openStringVals,TM.ToString(crossSell2));
      TM.AddInArray(openStringVals,TM.ToString(crossSell3));
      TM.AddInArray(openStringVals,TM.ToString(crossSell4));
      TM.AddInArray(openStringVals,TM.ToString(crossSell5));
      TM.AddInArray(openStringVals,TM.ToString(crossSell6));
      TM.AddInArray(openStringVals,TM.ToString(crossSell7));
      TM.AddInArray(openStringVals,TM.ToString(SEP));
      
      TM.AddInArray(openVals,buf0);
      TM.AddInArray(openVals,buf1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,levelLong1);
      TM.AddInArray(openVals,levelLong2);
      TM.AddInArray(openVals,levelLong3);
      TM.AddInArray(openVals,levelLong4);
      TM.AddInArray(openVals,levelLong5);
      TM.AddInArray(openVals,levelLong6);
      TM.AddInArray(openVals,levelLong7);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,levelShort1);
      TM.AddInArray(openVals,levelShort2);
      TM.AddInArray(openVals,levelShort3);
      TM.AddInArray(openVals,levelShort4);
      TM.AddInArray(openVals,levelShort5);
      TM.AddInArray(openVals,levelShort6);
      TM.AddInArray(openVals,levelShort7);
      
      string   reason   = "";
      
      if ((crossBuy1 + crossBuy2 + crossBuy3 + crossBuy4 + crossBuy5 + crossBuy6 + crossBuy7) > 0){
         openSignal  = BUY;
         reason   += "crossBuy |";
      }
         
      if ((crossSell1 + crossSell2 + crossSell3 + crossSell4 + crossSell5 + crossSell6 + crossSell7) > 0){
         openSignal  = SELL;
         reason   += "crossSell |";
      }   
        
      TM.AddInArray(openStringVals,TM.ToString(reason));
         
         
      if (!isLowestIndex)
         openSignal = BOTH;
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class ExitOsMaLevelSignal : public Signal{
   public:
   
   ExitOsMaLevelSignal(){
      name        = "ExitOsMaLevelSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      openSignal  = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     inProfit       = osma_enable_exit_in_profit;
      
      bool     closedBar      = signal_bar;
      
      double   buf0           = TM.GetExitOsMA(0,closedBar);
      double   buf1           = TM.GetExitOsMA(0,closedBar+1);
      
      
      bool     isJpy          = StringFind(_Symbol,"JPY") != -1;
      double   coef           = isJpy ? 100 : 1;
      
      ENUM_TIMEFRAMES   tf    = osma_exit_timeframe == PERIOD_CURRENT ? (ENUM_TIMEFRAMES)_Period : osma_exit_timeframe;
      int      tfPos          = TM.FindInArray(tf,timeframes_array);
      
      bool     newBar         = tfPos != -1 ? TM.new_bars[tfPos] : false;
      bool     isChaikin      = chaikin_osma_exit_enable[tfPos];
      
      double   chaikin0          = TM.GetMaChaikin(tfPos,1,closedBar);     //ma
      double   chaikin1          = TM.GetMaChaikin(tfPos,1,closedBar+1);   //ma
      bool     chaikinIsRising   = chaikin0 > chaikin1;
      bool     chaikinIsFalling  = chaikin0 < chaikin1;
      
      TM.AddInArray(closeStringVals,TM.ToString(tfPos));
      TM.AddInArray(closeStringVals,TM.ToString(newBar));
      TM.AddInArray(closeStringVals,TM.ToString(inProfit));
      TM.AddInArray(closeStringVals,EnumToString(ENUM_TIMEFRAMES(osma_exit_timeframe)));
      TM.AddInArray(closeStringVals,TM.ToString(isJpy));
      TM.AddInArray(closeStringVals,TM.ToString(coef));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      TM.AddInArray(closeStringVals,TM.ToString(isChaikin));
      TM.AddInArray(closeStringVals,TM.ToString(chaikinIsRising));
      TM.AddInArray(closeStringVals,TM.ToString(chaikinIsFalling));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      
      
      
      double   long_level1         = osma_exit_long_level_1 * coef;
      double   long_level2         = osma_exit_long_level_2 * coef;
      double   long_level3         = osma_exit_long_level_3 * coef;
      double   long_level4         = osma_exit_long_level_4 * coef;
      double   long_level5         = osma_exit_long_level_5 * coef;
      double   long_level6         = osma_exit_long_level_6 * coef;
      double   long_level7         = osma_exit_long_level_7 * coef;
      
      double   short_level1         = osma_exit_short_level_1 * coef;
      double   short_level2         = osma_exit_short_level_2 * coef;
      double   short_level3         = osma_exit_short_level_3 * coef;
      double   short_level4         = osma_exit_short_level_4 * coef;
      double   short_level5         = osma_exit_short_level_5 * coef;
      double   short_level6         = osma_exit_short_level_6 * coef;
      double   short_level7         = osma_exit_short_level_7 * coef;
      
      bool     crossBuy1      = buf0 <= long_level1 && buf1 > long_level1;
      bool     crossBuy2      = buf0 <= long_level2 && buf1 > long_level2;
      bool     crossBuy3      = buf0 <= long_level3 && buf1 > long_level3;
      bool     crossBuy4      = buf0 <= long_level4 && buf1 > long_level4;
      bool     crossBuy5      = buf0 <= long_level5 && buf1 > long_level5;
      bool     crossBuy6      = buf0 <= long_level6 && buf1 > long_level6;
      bool     crossBuy7      = buf0 <= long_level7 && buf1 > long_level7;
      
      bool     crossSell1     = buf0 >= short_level1 && buf1 < short_level1;
      bool     crossSell2     = buf0 >= short_level2 && buf1 < short_level2;
      bool     crossSell3     = buf0 >= short_level3 && buf1 < short_level3;
      bool     crossSell4     = buf0 >= short_level4 && buf1 < short_level4;
      bool     crossSell5     = buf0 >= short_level5 && buf1 < short_level5;
      bool     crossSell6     = buf0 >= short_level6 && buf1 < short_level6;
      bool     crossSell7     = buf0 >= short_level7 && buf1 < short_level7;
      

      TM.AddInArray(closeStringVals,TM.ToString(crossBuy1));
      TM.AddInArray(closeStringVals,TM.ToString(crossBuy2));
      TM.AddInArray(closeStringVals,TM.ToString(crossBuy3));
      TM.AddInArray(closeStringVals,TM.ToString(crossBuy4));
      TM.AddInArray(closeStringVals,TM.ToString(crossBuy5));
      TM.AddInArray(closeStringVals,TM.ToString(crossBuy6));
      TM.AddInArray(closeStringVals,TM.ToString(crossBuy7));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      
      TM.AddInArray(closeStringVals,TM.ToString(crossSell1));
      TM.AddInArray(closeStringVals,TM.ToString(crossSell2));
      TM.AddInArray(closeStringVals,TM.ToString(crossSell3));
      TM.AddInArray(closeStringVals,TM.ToString(crossSell4));
      TM.AddInArray(closeStringVals,TM.ToString(crossSell5));
      TM.AddInArray(closeStringVals,TM.ToString(crossSell6));
      TM.AddInArray(closeStringVals,TM.ToString(crossSell7));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      
      TM.AddInArray(closeVals,buf0);
      TM.AddInArray(closeVals,buf1);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,long_level1);
      TM.AddInArray(closeVals,long_level2);
      TM.AddInArray(closeVals,long_level3);
      TM.AddInArray(closeVals,long_level4);
      TM.AddInArray(closeVals,long_level5);
      TM.AddInArray(closeVals,long_level6);
      TM.AddInArray(closeVals,long_level7);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,short_level1);
      TM.AddInArray(closeVals,short_level2);
      TM.AddInArray(closeVals,short_level3);
      TM.AddInArray(closeVals,short_level4);
      TM.AddInArray(closeVals,short_level5);
      TM.AddInArray(closeVals,short_level6);
      TM.AddInArray(closeVals,short_level7);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,chaikin0);
      TM.AddInArray(closeVals,chaikin1);
      
      string   reason   = "";
      
      if (newBar){
         if ((crossSell1 + crossSell2 + crossSell3 + crossSell4 + crossSell5 + crossSell6 + crossSell7) > 0 && (isChaikin ? chaikinIsRising : true)){
            closeSignal  = BUY;
            reason   += "crossSell |";
         }
            
         if ((crossBuy1 + crossBuy2 + crossBuy3 + crossBuy4 + crossBuy5 + crossBuy6 + crossBuy7) > 0 && (isChaikin ? chaikinIsFalling : true)){
            closeSignal  = SELL;
            reason   += "crossBuy |";
         }   
      }
        
      TM.AddInArray(closeStringVals,TM.ToString(reason));
      
      int   open     = closeSignal == NO ? NO : closeSignal == BOTH ? -1 : closeSignal == BUY ? SELL : BUY;
      int   trades   = TM.GetMarketTrades(open);
      
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      TM.AddInArray(closeStringVals,EnumToString((SignalType)open));
      TM.AddInArray(closeStringVals,TM.ToString(trades));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      
      if (closeSignal != NO && trades && !inProfit){
         TM.SetInProfit(false,HEAD_TO_STRING+TM.ToString(inProfit)+", "+TM.ToString(trades));
      }
   }
};
*/

/*
class ExitOsMaLevelSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   ExitOsMaLevelSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitOsMaLevelSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      openSignal  = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      //bool     isLowestIndex  = sIndex == index;

      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      
      if (!isEnabled && TM.IsTestMode()){
         return;
      }   
      
      bool     closedBar      = signal_bar;
      
      double   buf0           = TM.GetOsMA(sIndex,0,closedBar);
      double   buf1           = TM.GetOsMA(sIndex,0,closedBar+1);
      double   highLevel      = osma_high_level[sIndex];
      double   lowLevel       = osma_low_level[sIndex];
      
      bool     highCrossBuy   = buf0 >= highLevel && buf1 < highLevel;
      bool     lowCrossBuy    = buf0 >= lowLevel && buf1 < lowLevel;
      
      bool     highCrossSell  = buf0 <= highLevel && buf1 > highLevel;
      bool     lowCrossSell   = buf0 <= lowLevel && buf1 > lowLevel;
      
      TM.AddInArray(closeStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(closeStringVals,TM.ToString(highCrossBuy));
      TM.AddInArray(closeStringVals,TM.ToString(lowCrossBuy));
      TM.AddInArray(closeStringVals,TM.ToString(highCrossSell));
      TM.AddInArray(closeStringVals,TM.ToString(lowCrossSell));
      
      TM.AddInArray(closeVals,buf0);
      TM.AddInArray(closeVals,buf1);
      TM.AddInArray(closeVals,highLevel);
      TM.AddInArray(closeVals,lowLevel);
      
      string   reason   = "";
      
      if (highCrossBuy || lowCrossBuy){
         closeSignal  = BUY;
         reason   += highCrossBuy ? "highCrossBuy | " : "lowCrossBuy |";
      }
         
      if (highCrossSell || lowCrossSell){
         closeSignal  = SELL;
         reason   += highCrossSell ? "highCrossSell | " : "lowCrossSell |";
      }   
        
      TM.AddInArray(closeStringVals,TM.ToString(reason));
               
      
   }
};
*/

/*
class EntryOsMAIndicatorRisingSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   EntryOsMAIndicatorRisingSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "EntryOsMAIndicatorRisingSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      
      if (!isLowestIndex && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      double   buf0           = TM.GetOsMA(sIndex,0,signal_bar);
      double   buf1           = TM.GetOsMA(sIndex,0,signal_bar+1);
      
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      bool     rising         = buf0 > buf1;
      bool     declining      = buf0 < buf1;
      
      TM.AddInArray(openStringVals,TM.ToString(rising));
      TM.AddInArray(openStringVals,TM.ToString(declining));
      
      TM.AddInArray(openVals,buf0);
      TM.AddInArray(openVals,buf1);
      
      string   reason   = "";
      
      if (rising){
         openSignal  = BUY;
         reason   += "rising";
      }
         
      if (declining){
         openSignal  = SELL;
         reason   += "declining";
      }   
        
      TM.AddInArray(openStringVals,TM.ToString(reason));
         
         
      if (!isLowestIndex)
         openSignal = BOTH;
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class FilterOneTradePerLowestTfCandleSignal : public Signal{
   public:
   
   FilterOneTradePerLowestTfCandleSignal(){
      name        = "FilterOneTradePerLowestTfCandleSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      TM.AddInArray(openStringVals,TM.ToString(index));
      
      if (index != -1){
         int      tf       = timeframes_array[index];
      
         int      ticket   = TM.GetLastClosedMarketTicketByType();
         datetime opTime   = TM.GetOrderOpenTime(ticket);
         int      bar      = iBarShift(_Symbol,tf,opTime);
      
         if (bar != 0){
            openSignal  = BOTH;
         }
      
         TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(tf)));
         TM.AddInArray(openStringVals,TM.ToString(bar));
         TM.AddInArray(openStringVals,TM.ToStringOrder(ticket));
      }
      else{
         openSignal  = BOTH;
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class FilterColorAboveMbfxIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   FilterColorAboveMbfxIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterColorAboveMbfxIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;

      bool     isEnabled      = panel.CheckIsEntryEnabledByIndex(sIndex);
      TM.AddInArray(openStringVals,TM.ToString(isEnabled));
      
      if ((!isEnabled || isLowestIndex) && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      bool     closedBar   = signal_on_closed_bar[sIndex];
      
      int      bar      = closedBar ? 1 : 0;
      double   yellow0  = TM.GetMdfx(sIndex,0,bar);
      double   yellow1  = TM.GetMdfx(sIndex,0,bar+1);
      
      double   green0   = TM.GetMdfx(sIndex,1,bar);
      double   green1   = TM.GetMdfx(sIndex,1,bar+1);
      
      double   red0     = TM.GetMdfx(sIndex,2,bar);
      double   red1     = TM.GetMdfx(sIndex,2,bar+1);
      
      bool     isIgnore = enable_ignore_color_mbfx[sIndex];;
      double   buy0     = isIgnore ? yellow0 : green0;
      double   buy1     = isIgnore ? yellow1 : green1;
      double   sell0    = isIgnore ? yellow0 : red0;
      double   sell1    = isIgnore ? yellow1 : red1;
      
      
      double   buyEntryLevelUp   = mbfx_entry_buy_level_up[sIndex];
      double   buyEntryLevelDn   = mbfx_entry_buy_level_dn[sIndex];
      double   sellEntryLevelUp  = mbfx_entry_sell_level_up[sIndex];
      double   sellEntryLevelDn  = mbfx_entry_sell_level_dn[sIndex];
      
      TM.AddInArray(openStringVals,TM.ToString(closedBar));
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,buyEntryLevelUp);
      TM.AddInArray(openVals,buyEntryLevelDn);
      TM.AddInArray(openVals,sellEntryLevelUp);
      TM.AddInArray(openVals,sellEntryLevelDn);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,yellow0);
      TM.AddInArray(openVals,yellow1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,green0);
      TM.AddInArray(openVals,green1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,red0);
      TM.AddInArray(openVals,red1);
      
      if (isEnabled){
         if (buy0 != EMPTY_VALUE && buy1 != EMPTY_VALUE && buy0 > buyEntryLevelDn && buy0 < buyEntryLevelUp){
            openSignal  = BUY;
         }
            
         if (sell0 != EMPTY_VALUE && sell1 != EMPTY_VALUE && sell0 < sellEntryLevelUp && sell0 > sellEntryLevelDn){
            openSignal  = SELL;
         } 
            
         if (isLowestIndex)
            openSignal = BOTH;
      }
      else{
         openSignal = BOTH;
      }   
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class FilterLevelChaikinIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   FilterLevelChaikinIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterLevelChaikinIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;

      bool     isEnabled      = panel.CheckIsEntryEnabledByIndex(sIndex);
      TM.AddInArray(openStringVals,TM.ToString(isEnabled));
      
      if (!isEnabled){// && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      bool     closedBar   = signal_on_closed_bar[sIndex] || isLowestIndex;
      
      int      bar      = closedBar ? 1 : 0;
      //double   chaikin  = TM.GetMaChaikin(sIndex,0,bar);
      double   ma0      = TM.GetMaChaikin(sIndex,1,bar);    
      double   ma1      = TM.GetMaChaikin(sIndex,1,bar+1);
      double   osMa     = TM.GetOsMA(sIndex,0,bar);
      
      double   buyEntryLevelUp   = chaikin_entry_buy_level_up[sIndex];
      double   buyEntryLevelDn   = chaikin_entry_buy_level_dn[sIndex];
      double   sellEntryLevelUp  = chaikin_entry_sell_level_up[sIndex];
      double   sellEntryLevelDn  = chaikin_entry_sell_level_dn[sIndex];
      
      bool     enable_entry_levels  = chaikin_enable_entry_levels[sIndex];
      bool     enable_entry_ab      = chaikin_enable_entry_ab[sIndex];
      bool     maRising             = ma0 > ma1;
      bool     maFiling             = ma0 < ma1;
      
      TM.AddInArray(openStringVals,TM.ToString(closedBar));
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_levels));
      TM.AddInArray(openStringVals,TM.ToString(enable_entry_ab));
      TM.AddInArray(openStringVals,TM.ToString(maRising));
      TM.AddInArray(openStringVals,TM.ToString(maFiling));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,buyEntryLevelUp);
      TM.AddInArray(openVals,buyEntryLevelDn);
      TM.AddInArray(openVals,sellEntryLevelUp);
      TM.AddInArray(openVals,sellEntryLevelDn);
      TM.AddInArray(openVals,SEP);
      //TM.AddInArray(openVals,chaikin);
      TM.AddInArray(openVals,ma0);
      TM.AddInArray(openVals,ma1);
      TM.AddInArray(openVals,osMa);

      string   str   = "";
      if (isEnabled){
         if (enable_entry_levels){
            if (ma0 > buyEntryLevelUp){
               openSignal = BUY;
               str += "chaikin > buyEntryLevelUp |";
            }   
            if (ma0 < sellEntryLevelDn){
               openSignal = openSignal == NO ? SELL : BOTH;
               str += "chaikin < sellEntryLevelDn |";
            }   
         }
         
         if (enable_entry_ab){
            bool  betweenBuy  = (ma0 - buyEntryLevelUp) * (ma0 - buyEntryLevelDn) <= 0;
            bool  betweenSell = (ma0 - sellEntryLevelUp) * (ma0 - sellEntryLevelDn) <= 0;
            
            TM.AddInArray(openStringVals,TM.ToString(SEP));
            TM.AddInArray(openStringVals,TM.ToString(betweenBuy));
            TM.AddInArray(openStringVals,TM.ToString(betweenSell));
         
            if (betweenBuy && maRising && osMa >= 0){
               openSignal = openSignal == NO || openSignal == BUY ? BUY : BOTH;
               str += "betweenBuy && maRising && osMa >= 0 |";
            }
            if (betweenSell && maFiling && osMa <= 0){
               openSignal = openSignal == NO || openSignal == SELL ? SELL : BOTH;
               str += "betweenSell && maFiling && osMa <= 0 |";
            }
         }
      }
      else{
         openSignal = BOTH;
      }   
      
      TM.AddInArray(openStringVals,TM.ToString(str));
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class FilterRisingChaikinIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   FilterRisingChaikinIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterRisingChaikinIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;

      bool     isEnabled      = panel.CheckIsEntryEnabledByIndex(sIndex);
      TM.AddInArray(openStringVals,TM.ToString(isEnabled));
      
      if (!isEnabled){// && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      bool     closedBar   = signal_on_closed_bar[sIndex] || isLowestIndex;
      
      int      bar         = closedBar ? 1 : 0;
      double   chaikin0    = TM.GetMaChaikin(sIndex,1,bar);    //ma
      double   chaikin1    = TM.GetMaChaikin(sIndex,1,bar+1);  //ma
      
      double   buyEntryLevelUp   = chaikin_entry_buy_level_up[sIndex];
      double   buyEntryLevelDn   = chaikin_entry_buy_level_dn[sIndex];
      double   sellEntryLevelUp  = chaikin_entry_sell_level_up[sIndex];
      double   sellEntryLevelDn  = chaikin_entry_sell_level_dn[sIndex];
      
      bool     chaikinRising     = chaikin0 > chaikin1;
      bool     chaikinFaling     = chaikin0 < chaikin1;
      
      TM.AddInArray(openStringVals,TM.ToString(closedBar));
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(openStringVals,TM.ToString(chaikinRising));
      TM.AddInArray(openStringVals,TM.ToString(chaikinFaling));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,buyEntryLevelUp);
      TM.AddInArray(openVals,buyEntryLevelDn);
      TM.AddInArray(openVals,sellEntryLevelUp);
      TM.AddInArray(openVals,sellEntryLevelDn);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,chaikin0);
      TM.AddInArray(openVals,chaikin1);

      string   str   = "";
      if (isEnabled){
         if (chaikinRising){
            if (chaikin0 > buyEntryLevelDn){
               openSignal = BUY;
               str += "chaikin0 > buyEntryLevelDn |";
            }   
         }
         if (chaikinFaling){   
            if (chaikin0 < sellEntryLevelUp){
               openSignal = openSignal == NO ? SELL : BOTH;
               str += "chaikin0 < sellEntryLevelUp |";
            }   
         }
         
      }
      else{
         openSignal = BOTH;
      }   
      
      TM.AddInArray(openStringVals,TM.ToString(str));
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class FilterStrictRisingChaikinIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   FilterStrictRisingChaikinIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterStrictRisingChaikinIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      bool     isLowestIndex  = sIndex == index;

      bool     isEnabled      = panel.CheckIsEntryEnabledByIndex(sIndex);
      TM.AddInArray(openStringVals,TM.ToString(isEnabled));
      
      if (!isEnabled){// && TM.IsTestMode()){
         openSignal = BOTH;
         return;
      }   
      
      bool     closedBar   = signal_on_closed_bar[sIndex] || isLowestIndex;
      
      int      bar         = closedBar ? 1 : 0;
      double   chaikin0    = TM.GetMaChaikin(sIndex,1,bar);    //ma
      double   chaikin1    = TM.GetMaChaikin(sIndex,1,bar+1);  //ma
      
      double   buyEntryLevelUp   = chaikin_entry_buy_level_up[sIndex];
      double   buyEntryLevelDn   = chaikin_entry_buy_level_dn[sIndex];
      double   sellEntryLevelUp  = chaikin_entry_sell_level_up[sIndex];
      double   sellEntryLevelDn  = chaikin_entry_sell_level_dn[sIndex];
      
      bool     chaikinRising     = chaikin0 > chaikin1;
      bool     chaikinFaling     = chaikin0 < chaikin1;
      
      TM.AddInArray(openStringVals,TM.ToString(closedBar));
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(openStringVals,TM.ToString(chaikinRising));
      TM.AddInArray(openStringVals,TM.ToString(chaikinFaling));
      
      TM.AddInArray(openVals,bar);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,buyEntryLevelUp);
      TM.AddInArray(openVals,buyEntryLevelDn);
      TM.AddInArray(openVals,sellEntryLevelUp);
      TM.AddInArray(openVals,sellEntryLevelDn);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,chaikin0);
      TM.AddInArray(openVals,chaikin1);

      string   str   = "";
      if (isEnabled){
         if (chaikinRising){
            if (chaikin0 > buyEntryLevelUp){
               openSignal = BUY;
               str += "chaikin0 > buyEntryLevelUp |";
            }   
         }
         if (chaikinFaling){   
            if (chaikin0 < sellEntryLevelDn){
               openSignal = openSignal == NO ? SELL : BOTH;
               str += "chaikin0 < sellEntryLevelDn |";
            }   
         }
         
      }
      else{
         openSignal = BOTH;
      }   
      
      TM.AddInArray(openStringVals,TM.ToString(str));
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class FilterColorChangedMbfxIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   SignalType  sLastSignal;
   
   FilterColorChangedMbfxIndicatorSignal(int index){
      sLastSignal = NO;
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterColorChangedMbfxIndicatorSignal::"+TM.ToString(sIndex);
      
      double   yellow0  = TM.GetMdfx(sIndex,0,signal_bar+1);
      double   yellow1  = TM.GetMdfx(sIndex,0,signal_bar+2);
      
      double   green0   = TM.GetMdfx(sIndex,1,signal_bar+1);
      double   green1   = TM.GetMdfx(sIndex,1,signal_bar+2);
      
      double   red0     = TM.GetMdfx(sIndex,2,signal_bar+1);
      double   red1     = TM.GetMdfx(sIndex,2,signal_bar+2);
      
      bool  isFlat   = 
                        (red0 != EMPTY_VALUE && red1 == EMPTY_VALUE) ||
                        (green0 != EMPTY_VALUE && green1 == EMPTY_VALUE) ||
                        (red0 == EMPTY_VALUE && green1 == EMPTY_VALUE)
                        ;
      
      
      if (isFlat)
         sLastSignal = NO;
      else if (green0 != EMPTY_VALUE)
         sLastSignal = BUY;
      else if (red0 != EMPTY_VALUE)
         sLastSignal = SELL;
         
         
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(name)+", "+
               TM.ToString(EnumToString(ENUM_TIMEFRAMES(sTimeFrame)))+", "+
               TM.ToString(EnumToString(sLastSignal))+" : "+
               TM.ToString(isFlat)+", "+
               TM.ToString(yellow0)+", "+
               TM.ToString(yellow1)+", "+
               TM.ToString(green0)+", "+
               TM.ToString(green1)+", "+
               TM.ToString(red0)+", "+
               TM.ToString(red1)
               );   
      
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int      index = filterLowestIndexSignal.sLowestIndex;
      
      double   yellow0  = TM.GetMdfx(sIndex,0,signal_bar);
      double   yellow1  = TM.GetMdfx(sIndex,0,signal_bar+1);
      
      double   green0   = TM.GetMdfx(sIndex,1,signal_bar);
      double   green1   = TM.GetMdfx(sIndex,1,signal_bar+1);
      
      double   red0     = TM.GetMdfx(sIndex,2,signal_bar);
      double   red1     = TM.GetMdfx(sIndex,2,signal_bar+1);
      
      bool  isLowestIndex  = sIndex == index;
      
      bool  isFlat   = 
                        (red0 != EMPTY_VALUE && red1 == EMPTY_VALUE) ||
                        (green0 != EMPTY_VALUE && green1 == EMPTY_VALUE) ||
                        (red0 == EMPTY_VALUE && green1 == EMPTY_VALUE)
                        ;
      TM.AddInArray(openStringVals,TM.ToString(isLowestIndex));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(openStringVals,TM.ToString(isFlat));
      
      TM.AddInArray(openVals,yellow0);
      TM.AddInArray(openVals,yellow1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,green0);
      TM.AddInArray(openVals,green1);
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,red0);
      TM.AddInArray(openVals,red1);
      
      SignalType  curSignal   = NO;
      
      if (isFlat)
         curSignal = NO;
      else if (green0 != EMPTY_VALUE)
         curSignal = BUY;
      else if (red0 != EMPTY_VALUE)
         curSignal = SELL;
         
      TM.AddInArray(openStringVals,EnumToString(curSignal));
      TM.AddInArray(openStringVals,EnumToString(sLastSignal));
         
      if (curSignal == BUY && sLastSignal != BUY){
         sLastSignal = curSignal;
         openSignal  = curSignal;
      }   
      if (curSignal == SELL && sLastSignal != SELL){
         sLastSignal = curSignal;
         openSignal  = curSignal;
      }   
      if (curSignal  == NO){
         sLastSignal = curSignal;
         openSignal  = curSignal;
      }
      
      TM.AddInArray(openStringVals,EnumToString(sLastSignal));
      
      if (!isLowestIndex)
         openSignal = BOTH;
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};*/
/*
class FilterAtrIndicatorSignal : public Signal{
   public:
   int   sTimeFrame;
   int   sIndex;
   
   FilterAtrIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterAtrIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      bool     isEnabled      = panel.CheckIsEntryEnabledByIndex(sIndex);
      
      TM.AddInArray(openStringVals,TM.ToString(isEnabled));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      if (!isEnabled && TM.IsTestMode()){
         openSignal  = BOTH;
         return;
      }
      
      double   atr            = TM.GetAtr(sIndex,signal_bar);
      
      int      highestIndex   = -1;
      int      lowestIndex    = -1;
      
      double   highestValue   = 0;
      double   lowestValue    = 0;
      
      int      maxCandles     = atr_look_back_X_bar[sIndex];
      
      TM.PrepairExtremAtrIndex(maxCandles,sIndex,highestIndex,highestValue,lowestIndex,lowestValue);
      
      double   triggerLevel   = atr_trigger_level[sIndex];
      
                        
      
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,atr);
      TM.AddInArray(openVals,triggerLevel);
      TM.AddInArray(openVals,highestIndex);
      TM.AddInArray(openVals,highestValue);
      TM.AddInArray(openVals,lowestIndex);
      TM.AddInArray(openVals,lowestValue);
      TM.AddInArray(openVals,maxCandles);
      
      if (isEnabled){
      
         if (highestIndex != -1 && lowestIndex != -1){
            
            double   dist  = highestValue - lowestValue;
            double   perc  = dist / 100 * triggerLevel;
            
            double   triggerLevelValue = lowestValue + perc;
         
            TM.AddInArray(openStringVals,TM.ToString(SEP));
            TM.AddInArray(openStringVals,TM.ToString(atr));
            TM.AddInArray(openStringVals,TM.ToString(triggerLevelValue));
            TM.AddInArray(openStringVals,TM.ToString(dist));
            TM.AddInArray(openStringVals,TM.ToString(perc));
         
            if (atr != EMPTY_VALUE){
               if (atr > triggerLevelValue)
                  openSignal = BOTH;
            }
         }
      
      }
      else{
         openSignal = BOTH;
      }   
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/
/*
class ExitAtrIndicatorSignal : public Signal{
   public:
   int   sTimeFrame;
   int   sIndex;
   
   ExitAtrIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitAtrIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      if (!isEnabled && TM.IsTestMode()){
         return;
      }
      
      double   atr            = TM.GetAtr(sIndex,signal_bar);
      
      int      highestIndex   = -1;
      int      lowestIndex    = -1;
      
      double   highestValue   = 0;
      double   lowestValue    = 0;
      
      int      maxCandles     = atr_look_back_X_bar[sIndex];
      
      TM.PrepairExtremAtrIndex(maxCandles,sIndex,highestIndex,highestValue,lowestIndex,lowestValue);
      
      double   triggerLevel   = atr_trigger_level[sIndex];
      
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,atr);
      TM.AddInArray(closeVals,triggerLevel);
      TM.AddInArray(closeVals,highestIndex);
      TM.AddInArray(closeVals,highestValue);
      TM.AddInArray(closeVals,lowestIndex);
      TM.AddInArray(closeVals,lowestValue);
      TM.AddInArray(closeVals,maxCandles);
      
      if (isEnabled){
      
         if (highestIndex != -1 && lowestIndex != -1){
            
            double   dist  = highestValue - lowestValue;
            double   perc  = dist / 100 * triggerLevel;
            
            double   triggerLevelValue = lowestValue + perc;
         
            TM.AddInArray(closeStringVals,TM.ToString(SEP));
            TM.AddInArray(closeStringVals,TM.ToString(atr));
            TM.AddInArray(closeStringVals,TM.ToString(triggerLevelValue));
            TM.AddInArray(closeStringVals,TM.ToString(dist));
            TM.AddInArray(closeStringVals,TM.ToString(perc));
         
            if (atr != EMPTY_VALUE && atr != 0){
               if (atr <= triggerLevelValue)
                  closeSignal = BOTH;
            }
         }
      }
   }
};
*/
/*
class ExitChaikinCrossZeroSignal : public Signal{
   public:
   int   sTimeFrame;
   int   sIndex;
   
   ExitChaikinCrossZeroSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitChaikinCrossZeroSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      if (!isEnabled){
         return;
      }
   
      //TM.Log(
      //         HEAD_TO_STRING+
      //         TM.ToString(name)
      //         );
      double   chaikin        = TM.GetMaChaikin(sIndex,1,signal_bar);   //ma
      //TM.Log(
      //         HEAD_TO_STRING+
      //         TM.ToString(name)
      //         );
      
      TM.AddInArray(closeVals,chaikin);
      
      if (isEnabled){
      
            if (chaikin != EMPTY_VALUE){
               if (chaikin > 0)
                  closeSignal = BUY;
               if (chaikin < 0)
                  closeSignal = SELL;
            }
      }
   }
};
*/
/*
class FilterAtrIndicatorDirSignal : public Signal{
   public:
   int   sTimeFrame;
   int   sIndex;
   
   FilterAtrIndicatorDirSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "FilterAtrIndicatorDirSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      bool     isEnabled      = panel.CheckIsEntryEnabledByIndex(sIndex);
      
      TM.AddInArray(openStringVals,TM.ToString(isEnabled));
      TM.AddInArray(openStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      if (!isEnabled){
         openSignal  = BOTH;
         return;
      }
      
      double   atr0  = TM.GetAtr(sIndex,signal_bar);
      double   atr1  = TM.GetAtr(sIndex,signal_bar+1);
                        
      
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,atr0);
      TM.AddInArray(openVals,atr1);
      
      if (atr0 > atr1){
         openSignal  = BOTH;
      }
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
};
*/

/*
class FilterMaxSpreadSignal : public Signal{
   public:
   
   FilterMaxSpreadSignal(){
      name = "FilterMaxSpreadSignal";
   }
      
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals,2);
      openVals[0] = MarketInfo(Symbol(),MODE_SPREAD);
      openVals[1] = max_spread_pips * TM.FractFactor();
      if (openVals[0] <= openVals[1]){
         openSignal = BOTH;
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
*/

/*
class ExitYellowCloseMbfxIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   ExitYellowCloseMbfxIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitYellowCloseMbfxIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      if (!isEnabled && TM.IsTestMode()){
         closeSignal  = NO;
         return;
      }
      
      double   yellow0  = TM.GetMdfx(sIndex,0,signal_bar);
      double   yellow1  = TM.GetMdfx(sIndex,0,signal_bar+1);
      
      double   green0   = TM.GetMdfx(sIndex,1,signal_bar);
      double   green1   = TM.GetMdfx(sIndex,1,signal_bar+1);
      
      double   red0     = TM.GetMdfx(sIndex,2,signal_bar);
      double   red1     = TM.GetMdfx(sIndex,2,signal_bar+1);
      
      
      bool     isNewBar       = TM.new_bars[sIndex];
      
      bool  isFlat   = 
                        (red0 != EMPTY_VALUE && red1 == EMPTY_VALUE) ||
                        (green0 != EMPTY_VALUE && green1 == EMPTY_VALUE) ||
                        (red0 == EMPTY_VALUE && green1 == EMPTY_VALUE)
                        ;
                        
                        
      TM.AddInArray(closeStringVals,TM.ToString(isNewBar));
      TM.AddInArray(closeStringVals,TM.ToString(isFlat));  
      TM.AddInArray(closeStringVals,TM.ToString(" | "));     
      TM.AddInArray(closeStringVals,TM.ToString(yellow0));     
      TM.AddInArray(closeStringVals,TM.ToString(yellow1));     
      TM.AddInArray(closeStringVals,TM.ToString(" | "));     
      TM.AddInArray(closeStringVals,TM.ToString(green0));     
      TM.AddInArray(closeStringVals,TM.ToString(green1));     
      TM.AddInArray(closeStringVals,TM.ToString(" | "));     
      TM.AddInArray(closeStringVals,TM.ToString(red0));     
      TM.AddInArray(closeStringVals,TM.ToString(red1));    
      
      if (isNewBar && isFlat && isEnabled)
         closeSignal = BOTH; 
      
   }
};
*/
/*
class ExitAtrIndicatorSignal : public Signal{
   public:
   int   sTimeFrame;
   int   sIndex;
   
   ExitAtrIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitAtrIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      double   atr            = TM.GetAtr(sIndex,signal_bar);
      double   triggerLevel   = atr_trigger_level[sIndex];
      
      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      bool     isNewBar       = TM.new_bars[sIndex];
                        
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,TM.ToString(isNewBar));
      TM.AddInArray(closeStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(closeVals,atr);
      TM.AddInArray(closeVals,triggerLevel);
      
      if (isEnabled && isNewBar){
         if (atr != EMPTY_VALUE){
            if (atr < triggerLevel)
               closeSignal = BOTH;
         }
      }
      else{
         closeSignal = NO;
      }   
      
   }
};

*/

/*
class ExitColorChangedMbfxIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   ExitColorChangedMbfxIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitColorChangedMbfxIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      openSignal = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      bool     inProfit       = enable_mbfx_in_profit[sIndex];
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,TM.ToString(inProfit));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      if (!isEnabled && TM.IsTestMode()){
         closeSignal  = NO;
         return;
      }
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      
      int      bar      = 1;
      
      double   yellow0  = TM.GetMdfx(sIndex,0,bar);
      double   yellow1  = TM.GetMdfx(sIndex,0,bar+1);
      
      double   green0   = TM.GetMdfx(sIndex,1,bar);
      double   green1   = TM.GetMdfx(sIndex,1,bar+1);
      
      double   red0     = TM.GetMdfx(sIndex,2,bar);
      double   red1     = TM.GetMdfx(sIndex,2,bar+1);
      
      //bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      bool     isNewBar       = TM.new_bars[sIndex];
      
      bool     greenToYellow  = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      bool     yellowToRed    = green1 == EMPTY_VALUE && red1 == EMPTY_VALUE && red0 != EMPTY_VALUE;
      
      bool     redToYellow    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     yellowToGreen  = green1 == EMPTY_VALUE && red1 == EMPTY_VALUE && green0 != EMPTY_VALUE;
      
      double   buyExitLevel  = mbfx_exit_buy_level[sIndex];
      double   sellExitLevel = mbfx_exit_sell_level[sIndex];
      
      //TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,TM.ToString(isNewBar));
      TM.AddInArray(closeStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      TM.AddInArray(closeStringVals,TM.ToString(greenToYellow));
      TM.AddInArray(closeStringVals,TM.ToString(yellowToRed));
      TM.AddInArray(closeStringVals,TM.ToString(redToYellow));
      TM.AddInArray(closeStringVals,TM.ToString(yellowToGreen));
      
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,buyExitLevel);
      TM.AddInArray(closeVals,sellExitLevel);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,yellow0);
      TM.AddInArray(closeVals,yellow1);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,green0);
      TM.AddInArray(closeVals,green1);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,red0);
      TM.AddInArray(closeVals,red1);
      
      if (isNewBar && isEnabled){
         if ((redToYellow || yellowToGreen) && yellow0 < sellExitLevel){
            closeSignal  = BUY;
         }
         if ((greenToYellow || yellowToRed) && yellow0 > buyExitLevel){
            closeSignal  = closeSignal == NO ? SELL : BOTH;
         }
      }      
      
      int   open     = closeSignal == NO ? NO : closeSignal == BOTH ? -1 : closeSignal == BUY ? SELL : BUY;
      int   trades   = TM.GetMarketTrades(open);
      
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      TM.AddInArray(closeStringVals,EnumToString((SignalType)open));
      TM.AddInArray(closeStringVals,TM.ToString(trades));
      
      if (closeSignal != NO && trades && !inProfit){
         TM.SetInProfit(false,TM.ToString(inProfit)+", "+TM.ToString(sIndex)+", "+TM.ToString(trades));
      }
         
   }
};
*/
/*
class ExitCrossBelowMbfxIndicatorSignal : public Signal{
   public:
   int         sIndex;
   int         sTimeFrame;
   
   ExitCrossBelowMbfxIndicatorSignal(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitCrossBelowMbfxIndicatorSignal::"+TM.ToString(sIndex);
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      openSignal = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      bool     inProfit       = enable_mbfx_in_profit[sIndex];
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,TM.ToString(inProfit));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      if (!isEnabled && TM.IsTestMode()){
         closeSignal  = NO;
         return;
      }
      
      int      index    = filterLowestIndexSignal.sLowestIndex;
      int      bar      = 1;
      
      double   yellow0  = TM.GetMdfx(sIndex,0,bar);
      double   yellow1  = TM.GetMdfx(sIndex,0,bar+1);
      
      double   green0   = TM.GetMdfx(sIndex,1,bar);
      double   green1   = TM.GetMdfx(sIndex,1,bar+1);
      
      double   red0     = TM.GetMdfx(sIndex,2,bar);
      double   red1     = TM.GetMdfx(sIndex,2,bar+1);
      
      //bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      bool     isNewBar       = TM.new_bars[sIndex];
      
      double   buyExitLevel  = mbfx_exit_buy_level[sIndex];
      double   sellExitLevel = mbfx_exit_sell_level[sIndex];
      
      //TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,TM.ToString(isNewBar));
      TM.AddInArray(closeStringVals,EnumToString(ENUM_TIMEFRAMES(sTimeFrame)));
      
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,buyExitLevel);
      TM.AddInArray(closeVals,sellExitLevel);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,yellow0);
      TM.AddInArray(closeVals,yellow1);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,green0);
      TM.AddInArray(closeVals,green1);
      TM.AddInArray(closeVals,SEP);
      TM.AddInArray(closeVals,red0);
      TM.AddInArray(closeVals,red1);
      
      if (isNewBar && isEnabled){
         if (yellow0 > sellExitLevel && yellow1 <= sellExitLevel){
            closeSignal  = BUY;
         }
         if (yellow0 < buyExitLevel && yellow1 >= buyExitLevel){
            closeSignal  = closeSignal == NO ? SELL : BOTH;
         }
      }  
      
      int   open     = closeSignal == NO ? NO : closeSignal == BOTH ? -1 : closeSignal == BUY ? SELL : BUY;
      int   trades   = TM.GetMarketTrades(open);
      
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      TM.AddInArray(closeStringVals,EnumToString((SignalType)open));
      TM.AddInArray(closeStringVals,TM.ToString(trades));
      
      if (closeSignal != NO && trades && !inProfit){
         TM.SetInProfit(false,TM.ToString(inProfit)+", "+TM.ToString(sIndex)+", "+TM.ToString(trades));
      }
   }
};
*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

/*
class FilterScaleMaxTradesSignal : public Signal{
   public:
   
   FilterScaleMaxTradesSignal(){
      name = "FilterScaleMaxTradesSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int   market   = TM.GetMarketTrades();
      int   pending  = TM.GetPendingTrades();
      int   total    = market + pending;
      
      TM.AddInArray(openVals,total);
      TM.AddInArray(openVals,max_pyramid_trades);
      
      TM.AddInArray(openVals,market);
      TM.AddInArray(openVals,pending);

      if (total && total < max_pyramid_trades)
         openSignal = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};
*/
class FilterLossRecMaxTradesSignal : public Signal{
   public:
   
   FilterLossRecMaxTradesSignal(){
      name = "FilterLossRecMaxTradesSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      int   market   = TM.GetMarketTrades();
      int   pending  = TM.GetPendingTrades();
      int   total    = market + pending;
      
      int   lrmMarket   = TM.GetMarketTradesByComment(LOSS_REC);
      
      TM.AddInArray(openVals,total);
      TM.AddInArray(openVals,lrmMarket);
      TM.AddInArray(openVals,lrm_max_trades);
      
      TM.AddInArray(openVals,SEP);
      TM.AddInArray(openVals,market);
      TM.AddInArray(openVals,pending);

      if (total && lrmMarket < lrm_max_trades)
         openSignal = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
   }
};

class ExitLossRecCrossBaseOpenPriceSignal : public Signal{
   public:
   
   ExitLossRecCrossBaseOpenPriceSignal(){
      name = "ExitLossRecCrossBaseOpenPriceSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      openSignal = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeVals, 0);
      ArrayResize(closeDatetimeVals, 0);
      ArrayResize(closeStringVals, 0);
      
      int   lrmMarket   = TM.GetMarketTradesByComment(LOSS_REC);
      int   baseTicket  = TM.GetFirstMarketTradeByComment(MAIN);
      
      RefreshRates();
      double   ask   = Ask;
      double   bid   = Bid;

      TM.AddInArray(closeStringVals,TM.ToString(lrmMarket));
      TM.AddInArray(closeStringVals,TM.ToString(baseTicket));

      if (lrmMarket && baseTicket){
         
         double   openPrice   = TM.GetOrderOpenPrice(baseTicket);
         int      type        = TM.GetOrderType(baseTicket);
         
         double   curPrice    = type % 2 == 0 ? bid : ask;
         bool     check       = type % 2 == 0 ? curPrice >= openPrice : curPrice <= openPrice;
         
         TM.AddInArray(closeStringVals,TM.ToString(check));
         TM.AddInArray(closeStringVals,TM.ToString(curPrice));
         TM.AddInArray(closeStringVals,TM.ToString(openPrice));
         
         if (check){
            closeSignal = type % 2 == 0 ? SELL : BUY;
         }
      }
      
      TM.AddInArray(closeStringVals,TM.ToString("|"));
      TM.AddInArray(closeStringVals,TM.ToString(baseTicket));
   }
};

class ExitLossRecCrossBeAverPriceSignal : public Signal{
   public:
   
   ExitLossRecCrossBeAverPriceSignal(){
      name = "ExitLossRecCrossBeAverPriceSignal";
   }
   
   ~ExitLossRecCrossBeAverPriceSignal(){
      DeleteObject();
   }   
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openVals, 0);
      ArrayResize(openDatetimeVals, 0);
      ArrayResize(openStringVals, 0);
      
      double   lotsTotal   = 0;
      double   aver        = TM.GetAveragePrice(lotsTotal);
      
      TM.AddInArray(openVals,aver);
      TM.AddInArray(openVals,lotsTotal);
      
      openSignal = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeVals, 0);
      ArrayResize(closeDatetimeVals, 0);
      ArrayResize(closeStringVals, 0);
      
      int      lrmMarket   = TM.GetMarketTradesByComment(LOSS_REC);
      int      mainMarket  = TM.GetMarketTradesByComment(MAIN);
      int      baseTicket  = TM.GetLastTicketByType();
      
      RefreshRates();
      double   ask   = Ask;
      double   bid   = Bid;

      TM.AddInArray(closeStringVals,TM.ToString(lrmMarket));
      TM.AddInArray(closeStringVals,TM.ToString(baseTicket));

      if (lrmMarket){
         
         double   mainLot        = TM.GetOrderLots(mainMarket);
         double   lotsTotal      = 0;
         double   averagePrice   = TM.GetAveragePrice(lotsTotal);
         double   lotCoef        = lotsTotal / mainLot;
         double   averBeProfit   = lrm_aver_be_profit / lotCoef;
         
         int      type           = TM.GetOrderType(baseTicket);
         int      coef           = type % 2 == 0 ? 1 : -1;
         double   levelPrice     = averagePrice + coef * averBeProfit * TM.Pip();
         
         double   curPrice    = type % 2 == 0 ? bid : ask;
         bool     check       = type % 2 == 0 ? curPrice >= levelPrice : curPrice <= levelPrice;
         
         TM.AddInArray(closeStringVals,TM.ToString(check));
         TM.AddInArray(closeStringVals,TM.ToString(curPrice));
         TM.AddInArray(closeStringVals,TM.ToString(levelPrice));
         TM.AddInArray(closeStringVals,TM.ToString(averagePrice));
         TM.AddInArray(closeStringVals,TM.ToString(averBeProfit));
         TM.AddInArray(closeStringVals,TM.ToString(SEP));
         TM.AddInArray(closeStringVals,TM.ToString(mainMarket));
         TM.AddInArray(closeStringVals,TM.ToString(mainLot));
         TM.AddInArray(closeStringVals,TM.ToString(lotsTotal));
         TM.AddInArray(closeStringVals,TM.ToString(lotCoef));
         TM.AddInArray(closeStringVals,TM.ToString(averBeProfit));
         TM.AddInArray(closeStringVals,TM.ToString(lrm_aver_be_profit));
         
         if (check){
            closeSignal = type % 2 == 0 ? SELL : BUY;
         }
         
         DrawObject(levelPrice);
      }
      else{
         DeleteObject();
      }
      
      TM.AddInArray(closeStringVals,TM.ToString("|"));
      TM.AddInArray(closeStringVals,TM.ToString(baseTicket));
   }
   
   void DrawObject(double price){
      if (!lrm_enable_debug_lines) return;
      color clr   = lrm_aver_be_color;
      TM.HLineCreate(name,price,clr);
   }
   
   void DeleteObject(){
      ObjectDelete(0,name);
   }
};


class FilterScaleLastTradeSignal : public Signal{
   public:
   
   FilterScaleLastTradeSignal(){
      name = "FilterScaleLastTradeSignal";
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int   ticket   = TM.GetLastTicketByType();
      TM.AddInArray(openVals,ticket);
      
      if (ticket){
         int   type  = TM.GetOrderType(ticket);
         TM.AddInArray(openVals,type);
         
         if (type % 2 == 0)
            openSignal  = BUY;
         else
            openSignal  = SELL;
      }
      
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
   
};

/*
class FilterCloseAboveBelowLevelSignal : public Signal{
   public:
   double   sLevel;
   
   FilterCloseAboveBelowLevelSignal(){
      name = "FilterCloseAboveBelowLevelSignal";
   }
   
   void UpdateLevel(){
      sLevel   = iClose(_Symbol,atr_trail_tf,signal_bar);
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(sLevel)
               );
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      double   close = iClose(_Symbol,atr_trail_tf,signal_bar);
      TM.AddInArray(openVals,close);
      TM.AddInArray(openVals,sLevel);
      
      if (sLevel){
         if (close > sLevel)
            openSignal  = BUY;
         if (close < sLevel)
            openSignal  = SELL;
      }
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
   
};
FilterCloseAboveBelowLevelSignal *sFilterCloseAboveBelowLevelSignal;
*/

class FilterScaleLossDirectionSignal : public Signal{
   public:
   double   sNextLot;
   double   sNextSl;
   
   FilterScaleLossDirectionSignal(){
      name = "FilterScaleLossDirectionSignal";
   }
   
   ~FilterScaleLossDirectionSignal(){
      DeleteObject();
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      int   baseTicket  = TM.GetLastTicketByType();
      
      TM.AddInArray(openStringVals,TM.ToString(baseTicket));
      
      RefreshRates();
      double   ask   = Ask;
      double   bid   = Bid;
      sNextLot = 0;
      sNextSl  = 0;
      
      if (baseTicket > 0){
         int      orType      = TM.GetOrderType(baseTicket);
         
         int      mainTicket  = TM.GetFirstMarketTradeByComment(MAIN,orType);
         double   mainOpPrice = TM.GetOrderOpenPrice(mainTicket);
         double   mainSlPrice = TM.GetOrderStopLoss(mainTicket);
         double   mainLot     = TM.GetOrderLots(mainTicket);
         
         TM.AddInArray(openStringVals,"|main:");
         TM.AddInArray(openStringVals,TM.ToString(mainTicket));
         TM.AddInArray(openStringVals,TM.ToString(mainOpPrice));
         TM.AddInArray(openStringVals,TM.ToString(mainSlPrice));
         TM.AddInArray(openStringVals,TM.ToString(mainLot));
         TM.AddInArray(openStringVals,"|last:");
         
         SignalType  type  = orType % 2 == 0 ? BUY : SELL;
         
         int      ticket      = TM.GetLastLossestTicketByType(type);
         double   orPrice     = TM.GetOrderOpenPrice(ticket);
         //double   orStopLoss  = TM.GetOrderStopLoss(ticket);
         double   orLot       = TM.GetOrderLots(ticket);
         sNextLot = mainLot * lrm_lot_mult;
         sNextSl  = mainSlPrice;
         
         double   curPrice    = type == BUY ? ask : bid;
         int      coef        = type == BUY ? 1 : -1;
         //double   level    = orPrice - coef * pyramid_loss_direction_dist_pips * TM.Pip();
         double   level       = 0;
         string   msg         = "";
         
         bool     isFirst        = mainTicket == ticket;
         double   realLrmTrigger = isFirst ? lrm_trigger_start : lrm_trigger;
         
         if (lrm_type == LossRecoveryTypePips){
            level = orPrice - coef * realLrmTrigger * TM.Pip();
            msg   += "lrm_type == LossRecoveryTypePips";
         }
         else{
            double   dist  = MathAbs(mainOpPrice - mainSlPrice);
            double   perc  = dist / 100 * realLrmTrigger;
            level    = orPrice - coef * perc;
            msg   += "lrm_type == LossRecoveryTypePerc,";
            msg   += TM.ToString(dist)+",";
            msg   += TM.ToString(perc);
         }
         
         TM.AddInArray(openStringVals,TM.ToString(ticket));
         TM.AddInArray(openStringVals,TM.ToString(curPrice));
         TM.AddInArray(openStringVals,TM.ToString(level));
         TM.AddInArray(openStringVals,TM.ToString(ask));
         TM.AddInArray(openStringVals,TM.ToString(bid));
         TM.AddInArray(openStringVals,"|");
         TM.AddInArray(openStringVals,TM.ToString(isFirst));
         TM.AddInArray(openStringVals,TM.ToString(realLrmTrigger));
         TM.AddInArray(openStringVals,"|");
         TM.AddInArray(openStringVals,TM.ToString(sNextSl));
         TM.AddInArray(openStringVals,TM.ToString(sNextLot));
         TM.AddInArray(openStringVals,TM.ToString(lrm_lot_mult));
         TM.AddInArray(openStringVals,"|");
         TM.AddInArray(openStringVals,TM.ToString(msg));
         TM.AddInArray(openStringVals,TM.ToStringOrder(ticket));
         
         if (type == BUY ? curPrice <= level : curPrice >= level)
            openSignal = type;
            
         DrawObject(level);   
      }
      else{
         DeleteObject();
      }
   }
   
   void DrawObject(double price){
      if (!lrm_enable_debug_lines) return;
      color clr   = lrm_trigger_color;
      TM.HLineCreate(name,price,clr);
   }
   
   void DeleteObject(){
      ObjectDelete(0,name);
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
   }
   
};
FilterScaleLossDirectionSignal *glFilterScaleLossDirectionSignal;

class CalculateTimeForCloseXBarsSignal : public Signal{
   public:
   datetime   sTime;
   
   CalculateTimeForCloseXBarsSignal(){
      name = "CalculateTimeForCloseXBarsSignal";
   }
   
   void UpdateLevel(){
      sTime   = TimeCurrent();
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(sTime)
               );
   }
   
   void ResetLevel(){
      sTime   = 0;
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(sTime)
               );
   }
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
      TM.AddInArray(openStringVals,TM.ToString(sTime));
      
      openSignal  = BOTH;
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      TM.AddInArray(closeStringVals,TM.ToString(sTime));
      
   }
   
};
CalculateTimeForCloseXBarsSignal *glCalculateTimeForCloseXBarsSignal;

/*
class ExitByXCandelsInProfit : public Signal{
   public:
   datetime    sTime;
   int         sIndex;
   int         sTimeFrame;
   
   ExitByXCandelsInProfit(int index){
      sIndex      = index;
      sTimeFrame  = timeframes_array[sIndex];
      name        = "ExitByXCandelsInProfit::"+TM.ToString(sIndex);
   }   
   
   void CalculateOpenSignal(){
      openSignal = NO;
      ArrayResize(openStringVals,0);
      ArrayResize(openDatetimeVals,0);
      ArrayResize(openVals,0);
      
   }
   
   void CalculateCloseSignal(){
      closeSignal = NO;
      ArrayResize(closeStringVals,0);
      ArrayResize(closeDatetimeVals,0);
      ArrayResize(closeVals,0);
      
      bool     isEnabled      = panel.CheckIsExitEnabledByIndex(sIndex);
      TM.AddInArray(closeStringVals,TM.ToString(isEnabled));
      TM.AddInArray(closeStringVals,TM.ToString(SEP));
      
      if (!isEnabled && TM.IsTestMode()){
         closeSignal  = NO;
         return;
      }
      
      datetime startTime   = glCalculateTimeForCloseXBarsSignal.sTime;
      int      xBars       = close_after_x_bars[sIndex];
      int      main        = TM.GetMarketTradesByComment(MAIN);
      
      TM.AddInArray(closeStringVals,TM.ToString(startTime));
      TM.AddInArray(closeStringVals,TM.ToString(main));
      TM.AddInArray(closeStringVals,TM.ToString(xBars));
      
      if (startTime > 0 && main){
         int      ticketMain     = TM.GetFirstMarketTradeByComment(MAIN);
         int      typeMain       = TM.GetOrderType(ticketMain);
      
         int      bar            = iBarShift(_Symbol,sTimeFrame,startTime);
         double   baseBuyClose   = TM.GetOrderOpenPrice(ticketMain);
         double   baseSellClose  = baseBuyClose;
         
         int      buyCount    = 0;
         int      sellCount   = 0;
         
         TM.AddInArray(closeVals,SEP);
         TM.AddInArray(closeVals,bar);
         TM.AddInArray(closeVals,baseBuyClose);
         TM.AddInArray(closeVals,ticketMain);
         TM.AddInArray(closeVals,typeMain);
         
         string   buyMsg   = "";
         string   sellMsg  = "";
         
         for (int i = bar - 1; i >= signal_bar; i--){
            double   close = iClose(_Symbol,sTimeFrame,i);

            if (close > baseBuyClose && typeMain == BUY){
               buyCount++;
               buyMsg   += TM.ToString(i)+","+TM.ToString(close)+","+TM.ToString(baseBuyClose)+"|";
               baseBuyClose   = close;
            }
            if (close < baseSellClose && typeMain == SELL){
               sellCount++;
               baseSellClose  = close;
               sellMsg  += TM.ToString(i)+","+TM.ToString(close)+","+TM.ToString(baseBuyClose)+"|";
            }
            
            if (buyCount >= xBars && sellCount >= xBars)
               break;
            
         }
         
         TM.AddInArray(closeStringVals,TM.ToString(buyMsg));
         TM.AddInArray(closeStringVals,TM.ToString(sellMsg));
         TM.AddInArray(closeStringVals,TM.ToString(sellCount));
         TM.AddInArray(closeStringVals,TM.ToString(buyCount));
         
         if (sellCount >= xBars)
            closeSignal = BUY;
         if (buyCount >= xBars)
            closeSignal = closeSignal == NO ? SELL : BOTH;
      
      }
   }
   
};
*/
