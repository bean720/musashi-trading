//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

#include "Zone.mqh"
#include "ZoneHandler.mqh"

#include <ChartObjects\\ChartObjectsTxtControls.mqh>


class DivergenceZone{
   public:
   string            trName;
   string            trObjBaseName;
   
   int               trIndex;
   ENUM_TIMEFRAMES   trTimeframe;
   
   bool              trIsFinished;
   bool              trIsDrawn;
   bool              trIsEnableDrawn;
   
   SignalType        trSignalType;
   
   StructPoint_TF    trStructPoint_TF_Finished;
   StructPoint_TF    trStructPoint_TF_IndStart;
   StructPoint_TF    trStructPoint_TF_PriceStart;
   
   ZoneHandler*      trZoneHandler;
   
   string ToString(){
      string   val   = StringFormat(" | DivZone: tN:%s, iF?:%s, arr:%s, { pCL:%s, tCR:%s, pCR:%s } | ",
                              trName,
                              
                              TM.ToString(trIsFinished)
                              
                              , TM.ToString(ArraySize(trZoneHandler.trArray_Zone))
                              
                              , trStructPoint_TF_IndStart.ToString()
                              , trStructPoint_TF_PriceStart.ToString()
                              , trStructPoint_TF_Finished.ToString()
                              );
      return   val;                        
   }
   
   SignalType GetCurrentSignal(int shift){
      SignalType res = NO;
      
      Zone* zone  = trZoneHandler.GetLast();
      
      if (IS_NOT_NULL(zone)){
         if (!zone.trIsFinished){
            res   = zone.trSignalType;
         }
      }
      
      return   res;
   }
   
  
   SignalType GetCurrentSignal_3BarRule(int shift, string &msg){
      double   price = trStructPoint_TF_PriceStart.trPrice;
      double   extr  = -1;
      
      for (int i = shift; i < shift + 3; i++){
         double   high     = iHigh(_Symbol,_Period,i);
         double   low      = iLow(_Symbol,_Period,i);
         
         double   extr_i   = trSignalType == BUY ? low : high;
         
         if (extr < 0){
            extr  = extr_i;
         }
         
         extr  = trSignalType == BUY ? MathMin(extr, extr_i) : MathMax(extr, extr_i);
      }
      
      bool  isCrossed   = trSignalType == BUY ? extr <= price : extr >= price;
      
      SignalType  res   = NO;
      
      if (isCrossed){
         res   = trSignalType;
      }
      
      msg = 
               EnumToString(res)+", "+
               TM.ToString(extr)+", "+
               TM.ToString(price)
               ;
      
      return   res;
   }
   
   DivergenceZone(
               int               shift,
               
               int               index,
               ENUM_TIMEFRAMES   tf,
               
               SignalType        signal,
               datetime          time,
               double            price,
               
               string            reason
               )
   {
      trIndex              = index;
      trTimeframe          = tf;
      
      trSignalType         = signal;
      
      trZoneHandler        = new ZoneHandler(trIndex, trIsDrawn);
      
      trStructPoint_TF_IndStart.Initialize(trTimeframe, time, price, shift);
      
      FindCandleStart(shift);
      
      //int      bar   = shift;
      //datetime time  = iTime(_Symbol, trTimeframe, shift);
      
      trName               = 
                              "DZ_"+
                              TM.ToString(trTimeframe)+"_"+
                              EnumToString(trSignalType)+"_"+
                              TM.ToString(time)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + "DZ_"+TM.ToString(trTimeframe) + "_" + TM.ToString(time);                     
                              
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               //TM.ToString(bar)+", "+
               TM.ToString(shift)+", "+
               TM.ToString(signal_bar)+" | "+
               TM.ToString(reason)+" | "+
               ToString()
               ,shift);
                              
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString("created.")+" | "+
               TM.ToString(reason)+" | "+
               ToString()
               ,shift);
   }
   
   void FindCandleStart(int shift){
      int      barStart = trStructPoint_TF_IndStart.GetBarShift();
      int      bars     = iBars(_Symbol,trTimeframe);
      int      limit    = 3;
      int      count    = 0;
      
      datetime extrTime    = 0;
      double   extrPrice   = 0;
      
      for (int i = barStart; i < bars; i++){
         if (count == limit) break;
         count++;
         
         double   high  = iHigh(_Symbol, trTimeframe, i);
         double   low   = iLow(_Symbol, trTimeframe, i);
         double   price = trSignalType == BUY ? low : high;
         datetime time  = iTime(_Symbol, trTimeframe, i);
         
         if (extrTime == 0){
            extrTime    = time;
            extrPrice   = price;
         }
         
         if (trSignalType == BUY ? price < extrPrice : price > extrPrice){
            extrTime    = time;
            extrPrice   = price;
         }
      }
      
      trStructPoint_TF_PriceStart.Initialize(trTimeframe, extrTime, extrPrice, shift);
      
   }
   
   ~DivergenceZone(){
      delete trZoneHandler;
   }
   
   void OnTick(int shift){
      if (trIsFinished) return;
      
      TryToFindZones(shift);
      TryToInvalidate(shift);
      
      ActionDrawing(shift);
   }
   
   
   void TryToFindZones(int shift){
      if (trIsFinished) return;
      
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      //only closed candles
               bar      = MathMax(bar, 1);
      
      double   level = trStructPoint_TF_PriceStart.trPrice;
      datetime time  = iTime(_Symbol, trTimeframe, bar);
      
      
      Zone* last  = trZoneHandler.GetLast();
      
      bool  isNotNull   = IS_NOT_NULL(last);
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(time)+", "+
                  TM.ToString(timeBase)+", "+
                  TM.ToString(bar)+", "+
                  TM.ToString(shift)+", "+
                  ToString()
                  ,shift);
      }
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isNotNull)+", "+
                  ToString()
                  ,shift);
      }
      
      if (isNotNull && !last.trIsFinished){
         last.OnTick(shift);
         return;
      }
      
      //double   high  = iHigh(_Symbol, trTimeframe, bar);
      //double   low   = iLow(_Symbol, trTimeframe, bar);
      double   high  = iHigh(_Symbol, _Period, shift);
      double   low   = iLow(_Symbol, _Period, shift);
      
      double   price = trSignalType == BUY ? low : high;
      
      bool     isCrossed   = trSignalType == BUY ? price < level : price > level;
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isCrossed)+", "+
                  TM.ToString(price)+", "+
                  TM.ToString(level)+", "+
                  ToString()
                  ,shift);
      }
      
      if (isCrossed){
         trZoneHandler.AddInstance(new Zone(
            shift
            , trIndex
            , trTimeframe
            , trSignalType
            , timeBase
            , level
            , price
            , HEAD_TO_STRING
            )
            , shift
            , HEAD_TO_STRING
         );   
      }
   }
   
   void UpdateIsEnableDrawn(int shift, bool val, string reason){
      if (trIsEnableDrawn != val){
         trIsEnableDrawn   = val;
         
         if (!trIsEnableDrawn)
            ObjectsDeleteAll(0, trObjBaseName);
         else{
            //ActionDrawing(reason+"::"+HEAD_TO_STRING);
            ActionDrawing(shift);
         }      
         
         trZoneHandler.UpdateIsEnableDrawn(shift, val, reason+"::"+HEAD_TO_STRING);
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     TM.ToString(trIsEnableDrawn)+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      
      }
   }
   
   
   
   void ActionDrawing(int shift){
      //return;
      if (!trIsEnableDrawn) return;
      //if (!trIsReal) return;
   
      if (true){
      
         string   obName   = trObjBaseName+"_"+"Up";
         
         double   price1   = trStructPoint_TF_PriceStart.trPrice;
         double   price2   = trStructPoint_TF_PriceStart.trPrice;
         
         datetime time1    = trStructPoint_TF_PriceStart.trTime;
         datetime time2    = trStructPoint_TF_Finished.trIsInitialized ? trStructPoint_TF_Finished.trTime : iTime(_Symbol,_Period,shift);
         
         CChartObjectTrend line;
         if (!line.Create(0, obName, 0, time1, price1, time2, price2))
            line.Attach(0, obName, 0, 2);
         
         color clr   = trSignalType == BUY ? glArray_divergence_zone_color_buy[trIndex] : glArray_divergence_zone_color_sell[trIndex];  
         line.Price(1, price2);
         line.Time(1, time2);
         line.Color(clr);
         line.Width(glArray_divergence_zone_width[trIndex]);
         line.Description("DZ_"+TM.ToString(trTimeframe));
         line.Tooltip(obName);
         line.RayRight(false);
         line.Detach();
         
      }
      if (true){
      
         string   obName   = trObjBaseName+"_"+"Dn";
         
         double   price1   = trStructPoint_TF_IndStart.trPrice;
         double   price2   = trStructPoint_TF_IndStart.trPrice;
         
         datetime time1    = trStructPoint_TF_IndStart.trTime;
         datetime time2    = trStructPoint_TF_Finished.trIsInitialized ? trStructPoint_TF_Finished.trTime : iTime(_Symbol,_Period,shift);
         
         CChartObjectTrend line;
         if (!line.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, time2, price2))
            line.Attach(0, obName, TM.GetIndicatorSubWindow(), 2);
         
         color clr   = trSignalType == BUY ? glArray_divergence_zone_color_buy[trIndex] : glArray_divergence_zone_color_sell[trIndex];  
         line.Price(1, price2);
         line.Time(1, time2);
         line.Color(clr);
         line.Width(glArray_divergence_zone_width[trIndex]);
         line.Description("DZ_"+TM.ToString(trTimeframe));
         line.Tooltip(obName);
         line.RayRight(false);
         line.Detach();
         
      }
   }
   
   
   
   void TryToInvalidate(int shift){
      TryToInvalidate_ByCrossingStartLevel(shift);
      TryToInvalidate_ByNewColorChange(shift);
   }
   
   void TryToInvalidate_ByCrossingStartLevel(int shift){
   
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      //only closed candles
               bar      = MathMax(bar, 1);
      
      datetime time     = iTime(_Symbol, trTimeframe, bar + 1);
      
      if (time <= trStructPoint_TF_IndStart.trTime) return;
      //trTimeLast        = time;
      
      double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,bar);
      double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,bar+1);
      
      
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
                  TM.ToString(yellow0)+", "+
                  TM.ToString(yellow1)+", "+
                  ToString()
                  ,shift);
      }
      
      bool  isCrossed_Dn   = yellow0 <= trStructPoint_TF_IndStart.trPrice;
      bool  isCrossed_Up   = yellow0 >= trStructPoint_TF_IndStart.trPrice;
      
      bool  isFinished     = trSignalType == BUY ? isCrossed_Dn : isCrossed_Up;
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isFinished)+", "+
                  TM.ToString(isCrossed_Dn)+", "+
                  TM.ToString(isCrossed_Up)+", "+
                  TM.ToString(yellow0)+", "+
                  TM.ToString(trStructPoint_TF_IndStart.trPrice)+", "+
                  ToString()
                  ,shift);
      }       
      
      Update_trIsFinished(shift, isFinished, HEAD_TO_STRING);        
   }
      
   void TryToInvalidate_ByNewColorChange(int shift){
   
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      //only closed candles
               bar      = MathMax(bar, 1);
      
      datetime time     = iTime(_Symbol, trTimeframe, bar + 1);
      
      if (time <= trStructPoint_TF_IndStart.trTime) return;
      //trTimeLast        = time;
      
      double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,bar);
      double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,bar+1);
      
      double   green0   = TM.GetIndicator_Mdfx(trIndex,1,bar);
      double   green1   = TM.GetIndicator_Mdfx(trIndex,1,bar+1);
      
      double   red0     = TM.GetIndicator_Mdfx(trIndex,2,bar);
      double   red1     = TM.GetIndicator_Mdfx(trIndex,2,bar+1);
      
      bool     isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
      bool     isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
      
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
         SignalType  signal   = isBuy ? BUY : SELL;
         
         bool  isFinished  = trSignalType == signal;
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(isFinished)+", "+
                     TM.ToString(isBuy)+", "+
                     TM.ToString(isSell)+", "+
                     ToString()
                     ,shift);
         }       
         
         Update_trIsFinished(shift, isFinished, HEAD_TO_STRING);        
      }
   }
   
   
   
   void Update_trIsFinished(int shift, bool val, string reason){
      if (trIsFinished != val){
         trIsFinished   = val;
         
         if (trIsFinished){
            trStructPoint_TF_Finished.Initialize(trTimeframe, iTime(_Symbol,_Period,shift), 0, shift);
         }
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     TM.ToString(trIsFinished)+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      }
   }
   
};
