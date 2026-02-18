//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

class DivergenceForming : public Divergence{
   public:
   uint        trFlashLastTime;
   
   bool        trIsOnChart;
   
   DivergenceForming(
               int               shift,
               
               int               index,
               ENUM_TIMEFRAMES   tf,
               
               StructDivergence& diver,
               
               bool              isDrawn,
               
               string            reason
               ) : Divergence (shift, index, tf, diver, false, isDrawn, reason)
   {
      trObjBaseName  += "Form_";
      
      trIsOnChart          = true;
      
      trName               = 
                              "DVF"+"_"+
                              TM.ToString(trTimeframe)+"_"+
                              EnumToString(trSignalType)+"_"+
                              TM.ToString(trSubw_TimeRight)+"_"
                              ;
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trObjBaseName)+", "+
               TM.ToString(reason)+", "+
               ToString()
               ,shift);   
      } 
      
      int   bar   = iBarShift(_Symbol, trTimeframe, trSubw_TimeRight);
      
      ENUM_TIMEFRAMES   lowestTf = TM.GetLowestTimeframe();
      bool     isLowestTf  = lowestTf == trTimeframe;
      
      
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
                  TM.ToString(alert_divergence_enabled)+", "+
                  TM.ToString(isArrowInside)+", "+
                  TM.ToString(alertLastTime)+", "+
                  TM.ToString(trChart_TimeLeft)+", "+
                  TM.ToString(trChart_TimeRight)+", "+
                  ToString()
                  ,shift);
      
         if (alert_divergence_enabled){
            TM.trStructAlert.Alert_DivergencePoten(shift, trTimeframe, trSignalType, trSubw_TimeRight, alertLast);
         }
      }   
   }
   
   void ActionDrawing(string reason){
      if (!trIsOnChart) return;
      if (!trIsDrawn) return;
   
   
      if (divergence_chart_draw_enable){
         string   obName   = trObjBaseName+"_"+"SW";
         CChartObjectTrend line;
         
         double   price1   = trSubw_PriceLeft;
         double   price2   = trSubw_PriceRight;
         
         //datetime time1    = trSubw_TimeLeft+PeriodSeconds(trTimeframe)-1;
         //datetime time2    = trSubw_TimeRight+PeriodSeconds(trTimeframe)-1;
         //         time2    = MathMin(TimeCurrent(), time2);
                  
         datetime time1    = trChart_TimeLeft;//+PeriodSeconds(trTimeframe)-1;
         datetime time2    = trChart_TimeRight;//+PeriodSeconds(trTimeframe)-1;
                  time2    = MathMin(TimeCurrent(), time2);
         
         //CChartObjectTrend line;
         if (!trCChartObjectTrend_Subwindow.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, time2, price2))
            trCChartObjectTrend_Subwindow.Attach(0, obName, TM.GetIndicatorSubWindow(), 2);
         
         //color clr   = trSignalType == BUY ? clrDodgerBlue : clrCoral; 
         color clr   = trSignalType == BUY ? glArray_divergence_color_buy[trIndex] : glArray_divergence_color_sell[trIndex];  
         trCChartObjectTrend_Subwindow.Price(1, price2);
         trCChartObjectTrend_Subwindow.Time(1, time2);
         trCChartObjectTrend_Subwindow.Color(clr);
         //trCChartObjectTrend_Subwindow.Style(STYLE_DOT);
         trCChartObjectTrend_Subwindow.Width(glArray_divergence_width[trIndex]);
         trCChartObjectTrend_Subwindow.Description("Forming: "+TM.ToString(trTimeframe));
         trCChartObjectTrend_Subwindow.Tooltip(obName);
         trCChartObjectTrend_Subwindow.RayRight(false);
         //trCChartObjectTrend_Subwindow.Detach();
         
      }
      
      if (divergence_chart_draw_enable){
         string   obName   = trObjBaseName+"_"+"CH";
         
         double   price1   = trChart_PriceLeft;
         double   price2   = trChart_PriceRight;
         
         //datetime time1    = trChart_TimeLeft+PeriodSeconds(trTimeframe)-1;
         //datetime time2    = trChart_TimeRight+PeriodSeconds(trTimeframe)-1;
         //         time2    = MathMin(TimeCurrent(), time2);
                  
         datetime time1    = trChart_TimeLeft;//+PeriodSeconds(trTimeframe)-1;
         datetime time2    = trChart_TimeRight;//+PeriodSeconds(trTimeframe)-1;
                  time2    = MathMin(TimeCurrent(), time2);
         
         //CChartObjectTrend line;
         if (!trCChartObjectTrend_Chart.Create(0, obName, 0, time1, price1, time2, price2))
            trCChartObjectTrend_Chart.Attach(0, obName, 0, 2);
         
         //color clr   = trSignalType == BUY ? clrDodgerBlue : clrCoral;  
         color clr   = trSignalType == BUY ? glArray_divergence_color_buy[trIndex] : glArray_divergence_color_sell[trIndex];  
         trCChartObjectTrend_Chart.Price(1, price2);
         trCChartObjectTrend_Chart.Time(1, time2);
         trCChartObjectTrend_Chart.Color(clr);
         trCChartObjectTrend_Chart.Style(STYLE_DOT);
         trCChartObjectTrend_Chart.Width(1);
         trCChartObjectTrend_Chart.Description("Forming: "+TM.ToString(trTimeframe));
         trCChartObjectTrend_Chart.Tooltip(obName);
         trCChartObjectTrend_Chart.RayRight(false);
         //trCChartObjectTrend_Chart.Detach();
         
      }
   }
   
   void ActionFlashing(int shift){
      uint     msCur       = IsTesting() ? (uint)TimeLocal() : GetTickCount();
      int      step        = IsTesting() ? 1 : 500;
      
      uint     flashTime   = trFlashLastTime + step;
      
      bool     isReady     = msCur >= flashTime;
      
      if (isReady){
         
         trFlashLastTime   = msCur;
         
         trIsOnChart       = !trIsOnChart;
         
         if (!trIsOnChart){
            trCChartObjectTrend_Subwindow.Delete();
            trCChartObjectTrend_Chart.Delete();
            ChartRedraw(0);
         }
         else{
            ActionDrawing(HEAD_TO_STRING);
            ChartRedraw(0);
         }
         
      }
   }
   
   void OnTick(int shift){
      ActionDrawing(HEAD_TO_STRING);
   }
};
