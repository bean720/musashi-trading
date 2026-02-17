//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

class Divergence{
   public:
   string            trName;
   string            trObjBaseName;
   
   int               trIndex;
   ENUM_TIMEFRAMES   trTimeframe;
   
   bool              trIsDrawn;
   bool              trIsReal;
   
   SignalType        trSignalType;
   
   double            trChart_PriceLeft;
   double            trChart_PriceRight;
   datetime          trChart_TimeLeft;
   datetime          trChart_TimeRight;
   
   double            trSubw_PriceLeft;
   double            trSubw_PriceRight;
   datetime          trSubw_TimeLeft;
   datetime          trSubw_TimeRight;
   
   CChartObjectTrend trCChartObjectTrend_Subwindow;
   CChartObjectTrend trCChartObjectTrend_Chart;
   
   Divergence(
               int               shift,
               
               int               index,
               ENUM_TIMEFRAMES   tf,
               
               StructDivergence& diver,
               bool              isReal,
               
               bool              isDrawn,
               
               string            reason
               )
   {
      trIndex              = index;
      trTimeframe          = tf;
      trIsReal             = isReal;
      
      trSignalType         = diver.trSignalType;
      
      trChart_PriceLeft    = diver.trChart_PriceLeft;
      trChart_PriceRight   = diver.trChart_PriceRight;
      trChart_TimeLeft     = diver.trChart_TimeLeft;
      trChart_TimeRight    = diver.trChart_TimeRight;
      
      trSubw_PriceLeft     = diver.trSubw_PriceLeft;
      trSubw_PriceRight    = diver.trSubw_PriceRight;
      trSubw_TimeLeft      = diver.trSubw_TimeLeft;
      trSubw_TimeRight     = diver.trSubw_TimeRight;
      
      trName               = 
                              "DV"+"_"+
                              TM.ToString(trTimeframe)+"_"+
                              EnumToString(trSignalType)+"_"+
                              TM.ToString(trSubw_TimeRight)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + TM.ToString(trTimeframe) + "_" + TM.ToString(trSubw_TimeRight); 
      
      ENUM_TIMEFRAMES   lowestTf = TM.GetLowestTimeframe();
      bool     isLowestTf  = lowestTf == trTimeframe;
                              
      int      bar         = iBarShift(_Symbol, trTimeframe, trSubw_TimeRight);
      
      StructAlert_Last  alertLast   = trSignalType == BUY ? glStructAlert_Last_Buy : glStructAlert_Last_Sell;
      
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(bar)+", "+
               TM.ToString(isLowestTf)+", "+
               alertLast.ToString()+", "+
               ToString()
               ,shift);
                              
      
      if (alertLast.trIsInitialized && isLowestTf){
         datetime alertLastTime  = alertLast.trTimeLast;
         
         bool     isArrowInside  = alertLastTime >= trChart_TimeLeft && alertLastTime <= trChart_TimeRight;
         
         IFLOG
            TM.Log(  
                  HEAD_TO_STRING+
                  TM.ToString(isArrowInside)+", "+
                  TM.ToString(alertLastTime)+", "+
                  TM.ToString(trChart_TimeLeft)+", "+
                  TM.ToString(trChart_TimeRight)+", "+
                  ToString()
                  ,shift);
         
         IFLOG
            TM.Log(  
                  HEAD_TO_STRING+
                  TM.ToString(isReal)+", "+
                  TM.ToString(alert_divergence_enabled)+", "+
                  TM.ToString(shift)+", "+
                  TM.ToString(isArrowInside)+", "+
                  ToString()
                  ,shift);
                  
         IFLOG
            TM.Log(  
                  HEAD_TO_STRING+
                  TM.ToString(isReal)+", "+
                  TM.ToString(alert_divergence_enabled)+", "+
                  TM.ToString(isArrowInside)+", "+
                  ToString()
                  ,shift);
                  
                  
                  
         if (isReal && alert_divergence_enabled && isArrowInside){
         
            bool  isTdfiDiver = true;         
            if (v9_filter_enable_tdfi_diver){
               
               SignalType  signal   = glCv9TdfiDiver.GetFinalSignal();
               
               isTdfiDiver = signal == trSignalType || signal == BOTH;
               
               IFLOG
                  TM.Log(  
                        HEAD_TO_STRING+
                        TM.ToString(isTdfiDiver)+", "+
                        EnumToString(signal)+", "+
                        EnumToString(trSignalType)+", "+
                        glCv9TdfiDiver.ToString()+", "+
                        ToString()
                        ,shift);
                  
               if (isTdfiDiver){
                  glCv9TdfiDiver.UpdateCounter(shift, HEAD_TO_STRING);
               }
            }
         
            if (isTdfiDiver){
            
               SignalType  lastSignal  = NO;
               
               IFLOG
                  TM.Log(  
                        HEAD_TO_STRING+
                        TM.ToString(bar)+", "+
                        TM.ToString(shift)+", "+
                        TM.ToString(signal_bar)+" | "+
                        TM.ToString("DIVERGENCE_SIGNAL")+" | "+
                        diver.ToString()+", "+
                        TM.ToString(reason)+", "+
                        ToString()
                        ,shift);
                     
               if (trSignalType == BUY){
                  //DrawSignal_Arrow(OP_BUY,glBuffer_UpArr,shift);
                  
                  if (glCv9TdfiDiver.trCounter > 1){
                     DrawSignal_Arrow(OP_BUY,glBuffer_UpArr_v9Tdfi,shift);
                  }
                  else{
                     DrawSignal_Arrow(OP_BUY,glBuffer_UpArr,shift);
                  }
                  
                  
               }   
               else{
                  //DrawSignal_Arrow(OP_SELL,glBuffer_DnArr,shift);
                  
                  if (glCv9TdfiDiver.trCounter > 1){
                     DrawSignal_Arrow(OP_SELL,glBuffer_DnArr_v9Tdfi,shift);
                  }
                  else{
                     DrawSignal_Arrow(OP_SELL,glBuffer_DnArr,shift);
                  }
                           
               }
               TM.trStructAlert.Alert_DivergenceReal(shift, trTimeframe, trSignalType, trSubw_TimeRight, alertLast);
               
               datetime time  = iTime(_Symbol, _Period, shift);
               alertLast.UpdateTime(shift, time, HEAD_TO_STRING);            
            
            
            }
         

         }
      }
      
      UpdateIsDrawn(isDrawn, HEAD_TO_STRING);
      
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(bar)+", "+
               TM.ToString(shift)+", "+
               TM.ToString(signal_bar)+" | "+
               TM.ToString(reason)+" | "+
               diver.ToString()+", "+
               TM.ToString(reason)+", "+
               ToString()
               ,shift);
                              
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(isReal)+", "+
               TM.ToString(trName)+" "+
               TM.ToString("created.")+" | "+
               TM.ToString(reason)+" | "+
               diver.ToString()+", "+
               ToString()
               ,shift);
   }
   
   ~Divergence(){
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString("deleted.")+" | "+
               ToString()
               );
      
      ObjectsDeleteAll(0, trObjBaseName);         
   }
   
   string ToString(){
      string   val   = StringFormat(" | CDiver: tN:%s, st:%s, iD?:%s, tCL:%s, pCL:%s, tCR:%s, pCR:%s, tSL:%s, pSL:%s, tSR:%s, pSR:%s | ",
                              trName,
                              
                              EnumToString(trSignalType),
                              
                              TM.ToString(trIsDrawn),
                              
                              TM.ToString(trChart_TimeLeft),
                              TM.ToString(trChart_PriceLeft),
                              TM.ToString(trChart_TimeRight),
                              TM.ToString(trChart_PriceRight),
                              
                              TM.ToString(trSubw_TimeLeft),
                              TM.ToString(trSubw_PriceLeft),
                              TM.ToString(trSubw_TimeRight),
                              TM.ToString(trSubw_PriceRight)
                              );
      return   val;                        
   }
   
   int GetBarIndex(){
      return iBarShift(_Symbol, trTimeframe, trSubw_TimeRight);
   }
   
   virtual void ActionDrawing(string reason){
      if (!trIsDrawn) return;
      if (!trIsReal) return;
      
      if (divergence_chart_draw_enable){
         string   obName   = trObjBaseName+"_"+"SW";
         
         double   price1   = trSubw_PriceLeft;
         double   price2   = trSubw_PriceRight;
         
         //datetime time1    = trSubw_TimeLeft+PeriodSeconds(trTimeframe)-1;
         //datetime time2    = trSubw_TimeRight+PeriodSeconds(trTimeframe)-1;
         datetime time1    = trChart_TimeLeft;//+PeriodSeconds(trTimeframe)-1;
         datetime time2    = trChart_TimeRight;//+PeriodSeconds(trTimeframe)-1;
         
         //CChartObjectTrend line;
         if (!trCChartObjectTrend_Subwindow.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, time2, price2))
            trCChartObjectTrend_Subwindow.Attach(0, obName, TM.GetIndicatorSubWindow(), 2);
         
         color clr   = trSignalType == BUY ? glArray_divergence_color_buy[trIndex] : glArray_divergence_color_sell[trIndex];  
         trCChartObjectTrend_Subwindow.Price(1, price2);
         trCChartObjectTrend_Subwindow.Time(1, time2);
         trCChartObjectTrend_Subwindow.Color(clr);
         trCChartObjectTrend_Subwindow.Width(glArray_divergence_width[trIndex]);
         trCChartObjectTrend_Subwindow.Description("TR"+TM.ToString(trTimeframe));
         trCChartObjectTrend_Subwindow.Tooltip(obName);
         trCChartObjectTrend_Subwindow.RayRight(false);
         //trCChartObjectTrend_Subwindow.Detach();
         
      }
      
      if (divergence_chart_draw_enable){
         string   obName   = trObjBaseName+"_"+"CH";
         
         double   price1   = trChart_PriceLeft;
         double   price2   = trChart_PriceRight;
         
         datetime time1    = trChart_TimeLeft;//+PeriodSeconds(trTimeframe)-1;
         datetime time2    = trChart_TimeRight;//+PeriodSeconds(trTimeframe)-1;
         
         //CChartObjectTrend line;
         if (!trCChartObjectTrend_Chart.Create(0, obName, 0, time1, price1, time2, price2))
            trCChartObjectTrend_Chart.Attach(0, obName, 0, 2);
         
         color clr   = trSignalType == BUY ? glArray_divergence_color_buy[trIndex] : glArray_divergence_color_sell[trIndex];  
         trCChartObjectTrend_Chart.Price(1, price2);
         trCChartObjectTrend_Chart.Time(1, time2);
         trCChartObjectTrend_Chart.Color(clr);
         trCChartObjectTrend_Chart.Width(glArray_divergence_width[trIndex]);
         trCChartObjectTrend_Chart.Description("TR"+TM.ToString(trTimeframe));
         trCChartObjectTrend_Chart.Tooltip(obName);
         trCChartObjectTrend_Chart.RayRight(false);
         //trCChartObjectTrend_Chart.Detach();
         
      }
   }
   
   virtual void OnTick(int shift){
      
   }
   
   void UpdateIsDrawn(bool val, string reason){
      if (trIsDrawn != val){
         trIsDrawn   = val;
         
         if (!trIsDrawn){
            ObjectsDeleteAll(0, trObjBaseName);
         }
         else{
            ActionDrawing(HEAD_TO_STRING);
         }
         
         IFLOG
            TM.Log(  
                  HEAD_TO_STRING+
                  TM.ToString(trName)+" "+
                  TM.ToString(trIsDrawn)+" | "+
                  ToString()
                  );
      }
   }

};
