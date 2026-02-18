//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "Divergence.mqh"
#include "DivergenceForming.mqh"
#include "..\\Structs.mqh"


class DivergenceHandler {
public:
   string               trName;

   int                  trIndex;
   ENUM_TIMEFRAMES      trTimeframe;

   Divergence*          trArray_Divergence[];
   DivergenceForming*   trDivergence_Forming;
   
   StructDivergence     trStructDivergence;
   
   datetime             trTimeLast;
   
   bool                 trIsForming;
   bool                 trIsDrawn;

   DivergenceHandler(int index, bool isDrawn, bool isForming) {
      trIsForming = isForming;
      trIndex     = index;
      trTimeframe = glArray_Timeframes[trIndex];
      trName      = "DV_" + TM.ToString(trIsForming)+ "_" + TM.ToString(trTimeframe);
      
      UpdateIsDrawn(isDrawn, HEAD_TO_STRING);
      
      IFLOG
         TM.Log(
            HEAD_TO_STRING +
            TM.ToString(trName) + " " +
            TM.ToString("created.") + " | " +
            ToString()
      );
   }

   ~DivergenceHandler() {
      for (int i = 0;i < ArrayRange(trArray_Divergence,0);i++){
         delete trArray_Divergence[i];
      }
      delete trDivergence_Forming;
      
      IFLOG
         TM.Log(
            HEAD_TO_STRING +
            TM.ToString(trName) + " " +
            TM.ToString("deleted.") + " | " +
            ToString()
      );
   }
   
   void UpdateIsDrawn(bool val, string reason){
      if (trIsDrawn != val){
         trIsDrawn   = val;
         
         IFLOG
            TM.Log(
               HEAD_TO_STRING +
               TM.ToString(trName) + " " +
               TM.ToString(trIsDrawn) + " | " +
               ToString()
         );
         
         if (CheckPointer(trDivergence_Forming) != POINTER_INVALID){
            trDivergence_Forming.UpdateIsDrawn(trIsDrawn, reason + "::" +HEAD_TO_STRING);
         }
      
         for (int i = 0;i < ArrayRange(trArray_Divergence,0);i++){
            if (CheckPointer(trArray_Divergence[i]) != POINTER_INVALID){
               trArray_Divergence[i].UpdateIsDrawn(trIsDrawn, reason + "::" +HEAD_TO_STRING);
            }
         }
      }
   }

   string ToString() {
      string   val   = StringFormat(" | tr:%s, SD:%s | ",
                                    trName,
                                    
                                    trStructDivergence.ToString()
                                   );
      return   val;
   }


   void OnTick(int shift) {
      if (!divergence_all_timeframes && !glArray_divergence_enable[trIndex]) return;
      if (!glArray_mbfx_enable[trIndex]) return;
   
      ZeroMemory(trStructDivergence);
      
      if (trIsForming){
         FindPriceSubwRight_Forming(shift);
      }
      else{
         FindPriceSubwRight(shift);
      }
      
      if (!trStructDivergence.trIsInitialized){
         delete   trDivergence_Forming;
      }
   }
   
   void FindPriceSubwRight_Forming(int shift){
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      datetime time     = iTime(_Symbol, trTimeframe, bar + 1);
      
      double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,bar);
      double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,bar+1);
      
      double   green0   = TM.GetIndicator_Mdfx(trIndex,1,bar);
      double   green1   = TM.GetIndicator_Mdfx(trIndex,1,bar+1);
      
      double   red0     = TM.GetIndicator_Mdfx(trIndex,2,bar);
      double   red1     = TM.GetIndicator_Mdfx(trIndex,2,bar+1);
      
      bool     isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      
      if (false)
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(time)+", "+
                     TM.ToString(bar)+", "+
                     TM.ToString(timeBase)+", "+
                     ToString()
                     ,shift);
                     
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(isBuy)+", "+
                     TM.ToString(isSell)+", "+
                     TM.ToString(green0)+", "+
                     TM.ToString(green1)+", "+
                     TM.ToString(red0)+", "+
                     TM.ToString(red1)+", "+
                     ToString()
                     ,shift);
         }
      
      if (isBuy || isSell){
         trStructDivergence.trSignalType        = isBuy ? BUY : SELL;
         trStructDivergence.trSubw_PriceRight   = yellow1;
         trStructDivergence.trSubw_TimeRight    = time;
         
         CheckDiverAboveBelowLevelRight(shift, bar, HEAD_TO_STRING);
      }
   }
   
   void FindPriceSubwRight(int shift){
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      //only closed candles
               bar      = MathMax(bar, 1);
      
      datetime time     = iTime(_Symbol, trTimeframe, bar + 1);
      
      if (time <= trTimeLast) return;
      trTimeLast        = time;
      
      double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,bar);
      double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,bar+1);
      
      double   green0   = TM.GetIndicator_Mdfx(trIndex,1,bar);
      double   green1   = TM.GetIndicator_Mdfx(trIndex,1,bar+1);
      
      double   red0     = TM.GetIndicator_Mdfx(trIndex,2,bar);
      double   red1     = TM.GetIndicator_Mdfx(trIndex,2,bar+1);
      
      bool     isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      
      if (!trIsForming)
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(time)+", "+
                     TM.ToString(bar)+", "+
                     TM.ToString(timeBase)+", "+
                     ToString()
                     ,shift);
                     
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(isBuy)+", "+
                     TM.ToString(isSell)+", "+
                     TM.ToString(green0)+", "+
                     TM.ToString(green1)+", "+
                     TM.ToString(red0)+", "+
                     TM.ToString(red1)+", "+
                     ToString()
                     ,shift);
         }
      
      if (isBuy || isSell){
         trStructDivergence.trSignalType        = isBuy ? BUY : SELL;
         trStructDivergence.trSubw_PriceRight   = yellow1;
         trStructDivergence.trSubw_TimeRight    = time;
         
         CheckDiverAboveBelowLevelRight(shift, bar, HEAD_TO_STRING);
      }
   }
   
   void CheckDiverAboveBelowLevelRight(int shift, int bar, string reason){
      double      levelBuy    = diver_level_buy;
      double      levelSell   = diver_level_sell;
      SignalType  signal      = trStructDivergence.trSignalType;
      double      level       = signal == BUY ? levelBuy : levelSell;
      
      double      indVal      = trStructDivergence.trSubw_PriceRight;
      bool        isBoth      = signal == BUY ? indVal < level : indVal > level;
      
      if (!trIsForming)
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(isBoth)+", "+
                     TM.ToString(indVal)+", "+
                     TM.ToString(level)+", "+
                     ToString()
                     ,shift);
         }               
      
      if (isBoth){
      
         FindPriceSubwLeft(shift, bar, HEAD_TO_STRING);
      }
   }
   
   void FindPriceSubwLeft(int shift, int bar, string reason){
      int   barRightStart  = bar + 1;
      int   bars           = iBars(_Symbol, trTimeframe);
      
      if (!trIsForming)
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(bar)+", "+
                     TM.ToString(barRightStart)+", "+
                     TM.ToString(bars)+", "+
                     ToString()
                     ,shift);
         }               
      
      
      SignalType  signal   = trStructDivergence.trSignalType;
      
      
      for (int i = barRightStart; i < bars - 1; i++){
         datetime time     = iTime(_Symbol, trTimeframe, i + 1);
         
         if (!trIsForming)
            IFLOG{
               TM.Log(
                        HEAD_TO_STRING+
                        TM.ToString(i)+", "+
                        TM.ToString(time)+", "+
                        ToString()
                        ,shift);
            }               
            
         double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,i);
         double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,i+1);
         
         double   green0   = TM.GetIndicator_Mdfx(trIndex,1,i);
         double   green1   = TM.GetIndicator_Mdfx(trIndex,1,i+1);
         
         double   red0     = TM.GetIndicator_Mdfx(trIndex,2,i);
         double   red1     = TM.GetIndicator_Mdfx(trIndex,2,i+1);
      
         bool     isNotNull   = yellow0 != EMPTY_VALUE;
         
         if (!isNotNull) break;
         
         bool        isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
         bool        isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
         SignalType  curSig   = isBuy ? BUY : isSell ? SELL : NO;
         
         bool        isReady  = curSig == signal;
         
         if (!trIsForming)
            IFLOG{
               TM.Log(
                        HEAD_TO_STRING+
                        TM.ToString(i)+", "+
                        TM.ToString(isReady)+", "+
                        EnumToString(curSig)+", "+
                        EnumToString(signal)+", "+
                        TM.ToString(isBuy)+", "+
                        TM.ToString(isSell)+", "+
                        ToString()
                        ,shift);
            }               
         
         if (isReady){
            trStructDivergence.trSubw_PriceLeft = yellow1;
            trStructDivergence.trSubw_TimeLeft  = time;
            
            CheckDiverAboveBelowLevelLeft(shift, HEAD_TO_STRING);
            
            break;
         }
      }
      
   }
   
   void CheckDiverAboveBelowLevelLeft(int shift, string reason){
      double      levelBuy    = diver_level_buy;
      double      levelSell   = diver_level_sell;
      SignalType  signal      = trStructDivergence.trSignalType;
      double      level       = signal == BUY ? levelBuy : levelSell;
      
      double      indVal      = trStructDivergence.trSubw_PriceLeft;
      bool        isBoth      = signal == BUY ? indVal < level : indVal > level;
      
      if (isBoth){
      
         CheckDiverSubwDirection(shift, HEAD_TO_STRING);
      }
   }
   
   void CheckDiverSubwDirection(int shift, string reason){
      double      priceRight  = trStructDivergence.trSubw_PriceRight;
      double      priceLeft   = trStructDivergence.trSubw_PriceLeft;
      SignalType  signal      = trStructDivergence.trSignalType;
      
      bool        isBoth      = signal == BUY ? priceRight > priceLeft : priceRight < priceLeft;
      
      if (isBoth){
      
         FindPriceChartRight(shift, HEAD_TO_STRING);
         FindPriceChartLeft(shift, HEAD_TO_STRING);
         CheckDiverChartDirection(shift, HEAD_TO_STRING);
      }
   }
   
   void FindPriceChartRight(int shift, string reason){
      SignalType  signal   = trStructDivergence.trSignalType;
      
      if (trTimeframe == _Period){
         datetime    time     = trStructDivergence.trSubw_TimeRight;
         int         bar      = iBarShift(_Symbol, trTimeframe, time);
         double      high     = iHigh(_Symbol, trTimeframe, bar);
         double      low      = iLow(_Symbol, trTimeframe, bar);
         double      price    = signal % 2 == 0 ? low : high;//iClose(_Symbol, trTimeframe, bar);
         
         trStructDivergence.trChart_TimeRight   = time;
         trStructDivergence.trChart_PriceRight  = price;
      
      }
      else{
         datetime    timeLeft    = trStructDivergence.trSubw_TimeRight;
         int         barLeft     = iBarShift(_Symbol, _Period, timeLeft);
         datetime    timeRight   = timeLeft + PeriodSeconds(trTimeframe) - 1;
         int         barRight    = iBarShift(_Symbol, _Period, timeRight); 
         
         int         difr        = barLeft - barRight;
         
         int         highestBar  = iHighest(_Symbol, _Period, MODE_HIGH, difr + 1, barRight);
         int         lowestBar   = iLowest(_Symbol, _Period, MODE_LOW, difr + 1, barRight);
         
         datetime    highestTime = iTime(_Symbol, _Period, highestBar);
         datetime    lowestTime  = iTime(_Symbol, _Period, lowestBar);
         
         double      high        = iHigh(_Symbol, _Period, highestBar);
         double      low         = iLow(_Symbol, _Period, lowestBar);
         
         double      price       = signal % 2 == 0 ? low : high;//iClose(_Symbol, trTimeframe, bar);
         datetime    time        = signal % 2 == 0 ? lowestTime : highestTime;
         
         trStructDivergence.trChart_TimeRight   = time;
         trStructDivergence.trChart_PriceRight  = price;
      
      }
   }

   void FindPriceChartLeft(int shift, string reason){
      SignalType  signal   = trStructDivergence.trSignalType;
      
      //datetime    time     = trStructDivergence.trSubw_TimeLeft;
      
      //SignalType  signal   = trStructDivergence.trSignalType;
      
      if (trTimeframe == _Period){
         datetime    time     = trStructDivergence.trSubw_TimeLeft;
         int         bar      = iBarShift(_Symbol, trTimeframe, time);
         double      high     = iHigh(_Symbol, trTimeframe, bar);
         double      low      = iLow(_Symbol, trTimeframe, bar);
         double      price    = signal % 2 == 0 ? low : high;//iClose(_Symbol, trTimeframe, bar);
         
         trStructDivergence.trChart_TimeLeft   = time;
         trStructDivergence.trChart_PriceLeft  = price;
      
      }
      else{
         datetime    timeLeft    = trStructDivergence.trSubw_TimeLeft;
         int         barLeft     = iBarShift(_Symbol, _Period, timeLeft);
         datetime    timeRight   = timeLeft + PeriodSeconds(trTimeframe) - 1;
         int         barRight    = iBarShift(_Symbol, _Period, timeRight); 
         
         int         difr        = barLeft - barRight;
         
         int         highestBar  = iHighest(_Symbol, _Period, MODE_HIGH, difr + 1, barRight);
         int         lowestBar   = iLowest(_Symbol, _Period, MODE_LOW, difr + 1, barRight);
         
         datetime    highestTime = iTime(_Symbol, _Period, highestBar);
         datetime    lowestTime  = iTime(_Symbol, _Period, lowestBar);
         
         double      high        = iHigh(_Symbol, _Period, highestBar);
         double      low         = iLow(_Symbol, _Period, lowestBar);
         
         double      price       = signal % 2 == 0 ? low : high;//iClose(_Symbol, trTimeframe, bar);
         datetime    time        = signal % 2 == 0 ? lowestTime : highestTime;
         
         trStructDivergence.trChart_TimeLeft   = time;
         trStructDivergence.trChart_PriceLeft  = price;
      
      }      
   }
   
   void CheckDiverChartDirection(int shift, string reason){
      double      priceRight  = trStructDivergence.trChart_PriceRight;
      double      priceLeft   = trStructDivergence.trChart_PriceLeft;
      SignalType  signal      = trStructDivergence.trSignalType;
      
      bool        isBoth      = signal == BUY ? priceRight < priceLeft : priceRight > priceLeft;
      
      if (isBoth){
         trStructDivergence.trIsInitialized  = true;
         
         if (trIsForming){
            if (CheckPointer(trDivergence_Forming) != POINTER_INVALID){
               if (trDivergence_Forming.trSubw_TimeRight == trStructDivergence.trSubw_TimeRight){
                  
                  trDivergence_Forming.trChart_PriceRight   = trStructDivergence.trChart_PriceRight; 
                  trDivergence_Forming.trSubw_PriceRight    = trStructDivergence.trSubw_PriceRight; 
                  
                  trDivergence_Forming.OnTick(shift);
               }
               else{
                  delete   trDivergence_Forming;
                  trDivergence_Forming = new DivergenceForming(shift, trIndex, trTimeframe, trStructDivergence, trIsDrawn, HEAD_TO_STRING);
                  trDivergence_Forming.OnTick(shift);
               }
            }
            else{
               trDivergence_Forming = new DivergenceForming(shift, trIndex, trTimeframe, trStructDivergence, trIsDrawn, HEAD_TO_STRING);
               trDivergence_Forming.OnTick(shift);
            }
         }
         else{
            TM.Log("",shift);
            AddDivergence(new Divergence(shift, trIndex, trTimeframe, trStructDivergence, true, trIsDrawn, HEAD_TO_STRING), HEAD_TO_STRING);
         }
      }
   }
   
   void ActionFlashing(int shift){
      if (CheckPointer(trDivergence_Forming) != POINTER_INVALID)
         trDivergence_Forming.ActionFlashing(shift);
   }

   void AddDivergence(Divergence *val, string reason){
      val.ActionDrawing(reason+"::"+HEAD_TO_STRING);
      
      ArrayResize(trArray_Divergence, ArrayRange(trArray_Divergence,0) + 1);
      trArray_Divergence[ArrayRange(trArray_Divergence, 0) - 1] = GetPointer(val);
   }
   
   Divergence* GetLastDivergence(SignalType type){
      Divergence* val   = NULL;
      
      for (int i = ArraySize(trArray_Divergence) - 1; i >= 0; i--){
         if (CheckPointer(trArray_Divergence[i]) != POINTER_INVALID){
            if (trArray_Divergence[i].trSignalType == type || type == BOTH){
               val   = trArray_Divergence[i];
               break;
            }
         }
      }
      
      return   val;
   }

};
DivergenceHandler* glArray_DivergenceHandler[];
DivergenceHandler* glArray_DivergenceHandler_Forming[];
//+------------------------------------------------------------------+
