//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

#include <ChartObjects\\ChartObjectsTxtControls.mqh>
#include <ChartObjects\\ChartObjectsShapes.mqh>


class Zone{
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
   StructPoint_TF    trStructPoint_TF_Point1;   //Level
   StructPoint_TF    trStructPoint_TF_Point2;   //Extrem
   
   
   string ToString(){
      string   val   = StringFormat(" | Zone: tN:%s, iF?:%s, { p1:%s, p2:%s, pf:%s } | ",
                              trName
                              
                              , TM.ToString(trIsFinished)
                              
                              , trStructPoint_TF_Point1.ToString()
                              , trStructPoint_TF_Point2.ToString()
                              , trStructPoint_TF_Finished.ToString()
                              );
      return   val;                        
   }
   
   
   
   Zone(){
   
   }
   
   Zone(
               int               shift,
               
               int               index,
               ENUM_TIMEFRAMES   tf,
               
               SignalType        signal,
               datetime          time,
               double            level,
               double            extr,
               
               string            reason
               )
   {
      trIndex              = index;
      trTimeframe          = tf;
      
      trSignalType         = signal;
      
      datetime time2       = iTime(_Symbol, _Period, shift);
      
      trStructPoint_TF_Point1.Initialize(trTimeframe, time, level, shift);
      trStructPoint_TF_Point2.Initialize(trTimeframe, time2, extr, shift);
      
      trName               = 
                              "Z_"+
                              TM.ToString(trTimeframe)+"_"+
                              EnumToString(trSignalType)+"_"+
                              TM.ToString(time)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + "Z_"+TM.ToString(trTimeframe) + "_" + TM.ToString(time);                     
                              
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
   
   ~Zone(){
   }
   
   void OnTick(int shift){
      if (trIsFinished) return;
      
      TryToInvalidate(shift);
      
      ActionDrawing(shift);
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
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(trIsEnableDrawn)+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      
      }
   }
   
   
   
   
   void ActionDrawing(int shift){
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(trIsEnableDrawn)+", "+
                  ToString()
                  ,shift);
      }
   
      if (!trIsEnableDrawn) return;
      //if (!trIsReal) return;
   
      if (true){
      
         string   obName   = trObjBaseName+"_"+"Rect";
         
         double   price1   = trStructPoint_TF_Point1.trPrice;
         double   price2   = trStructPoint_TF_Point2.trPrice;
         
         datetime time1    = trStructPoint_TF_Point1.trTime;
         datetime time2    = trStructPoint_TF_Point2.trTime;// + PeriodSeconds(trStructPoint_TF_Point2.trTF);
         
         if (true){
            string   obNamel   = obName+ "_L";
            CChartObjectTrend line;
            if (!line.Create(0, obNamel, 0, time1, price1, time1, price2))
               line.Attach(0, obNamel, 0, 2);
            
            ResetLastError();
            
            color clr   = trSignalType == BUY ? glArray_divergence_zone_color_buy[trIndex] : glArray_divergence_zone_color_sell[trIndex];   
            line.Price(1, price2);
            line.Time(1, time2);
            line.Color(clr);
            line.RayRight(false);
            line.RayLeft(false);
            line.Width(time1 == time2 ? 5 : 1);
            line.Description("DZ_"+TM.ToString(trTimeframe));
            line.Tooltip(obName);
            line.Detach();
         }
         if (true){
            CChartObjectRectangle line;
            if (!line.Create(0, obName, 0, time1, price1, time2, price2))
               line.Attach(0, obName, 0, 2);
            
            ResetLastError();
            
            color clr   = trSignalType == BUY ? glArray_divergence_zone_color_buy[trIndex] : glArray_divergence_zone_color_sell[trIndex];   
            line.Price(1, price2);
            line.Time(1, time2);
            line.Color(clr);
            line.Width(time1 == time2 ? 5 : glArray_divergence_zone_width[trIndex]);
            line.Description("DZ_"+TM.ToString(trTimeframe));
            line.Tooltip(obName);
            line.Detach();
         }
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(GetLastError())+", "+
                     ToString()
                     ,shift);
         }
      }
   }
   
   void TryToInvalidate(int shift){
      TryToInvalidate_ByCrossingStartLevel(shift);
   }
   
   void TryToInvalidate_ByCrossingStartLevel(int shift){
   
      datetime timeBase = iTime(_Symbol, _Period, shift);
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
      
      //only closed candles
      //         bar      = MathMax(bar, 1);
      
      datetime time     = iTime(_Symbol, trTimeframe, bar);
      
      if (timeBase <= trStructPoint_TF_Point1.trTime) return;
      //trTimeLast        = time;
      
      double   high  = iHigh(_Symbol, _Period, shift);
      double   low   = iLow(_Symbol, _Period, shift);
      double   level = trStructPoint_TF_Point1.trPrice;
      
      double   price = trSignalType == BUY ? low : high;
      
      bool     isCrossed   = trSignalType == BUY ? price < level : price > level;
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(timeBase)+", "+
                  TM.ToString(time)+", "+
                  TM.ToString(bar)+", "+
                  ToString()
                  ,shift);
                  
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(isCrossed)+", "+
                  TM.ToString(price)+", "+
                  TM.ToString(level)+", "+
                  ToString()
                  ,shift);
      }
      
      if (isCrossed){
         double   priceBase   = trStructPoint_TF_Point2.trPrice;
         double   priceNew    = trSignalType == BUY ? MathMin(price, priceBase) : MathMax(price, priceBase);
         
         trStructPoint_TF_Point2.Initialize(trTimeframe, timeBase, priceNew, shift);
      }
      else{
         Update_trIsFinished(shift, true, HEAD_TO_STRING);        
      }
      
      IFLOG{
         TM.Log(
                  HEAD_TO_STRING+
                  ToString()
                  ,shift);
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
