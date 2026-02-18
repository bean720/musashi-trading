//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"


#include <ChartObjects\\ChartObjectsArrows.mqh>

class ArrowForming{
   public:
   string            trName;
   string            trObjBaseName;
   
   //int               trIndex;
   
   uint              trFlashLastTime;
   
   datetime          trTime_Start;
   
   bool              trIsOnChart;
   bool              trIsFinished;
   
   SignalType        trSignalType;
   
   
   CChartObjectArrow trCChartObjectArrow_Subwindow;
   CChartObjectArrow trCChartObjectArrow_Chart;
   
   ArrowForming(
               int               shift,
               
               SignalType        sig,
               
               datetime          time,
               
               string            reason
               )
   {
      
      trSignalType         = sig;
      trIsOnChart          = true;
      
      trTime_Start         = time;
      
      trName               = 
                              "AF"+"_"+
                              TM.ToString(_Period)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + trName;   
      
      //TM.trStructAlert.Alert_ColorChange_Poten(shift, _Period, trSignalType, trTime_Start);
      
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trObjBaseName)+", "+
               TM.ToString(reason)
               ,shift);   
      } 
   }
   
   ~ArrowForming(){
      IFLOG{
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trObjBaseName)
               );   
      } 
   }
   
   void ActionDrawing(string reason){
      if (!trIsOnChart) return;
      //if (!trIsDrawn) return;
   
      if (divergence_chart_draw_enable){
         string   obName   = trObjBaseName+"_"+"SW";
         CChartObjectArrow line;
         
         int      index    = TM.GetTfIndexByValue(_Period);
         double   ind      = TM.GetIndicator_Mdfx(index, 0, 0);
         int      coef     = trSignalType % 2 == 0 ? 1 : -1;
         double   price1   = ind - coef * 5;
         
         datetime time1    = TimeCurrent();
         char     code     = trSignalType % 2 == 0 ? (char)233 : (char)234;
         ENUM_ARROW_ANCHOR anch  = trSignalType % 2 == 0 ? ANCHOR_TOP : ANCHOR_BOTTOM;
         
         if (!trCChartObjectArrow_Subwindow.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, code))
            trCChartObjectArrow_Subwindow.Attach(0, obName, TM.GetIndicatorSubWindow(), 1);
         
         color clr   = trSignalType == BUY ? color_arrow_up : color_arrow_dn;  
         trCChartObjectArrow_Subwindow.Price(0, price1);
         trCChartObjectArrow_Subwindow.Time(0, time1);
         trCChartObjectArrow_Subwindow.Color(clr);
         trCChartObjectArrow_Subwindow.Width(1);
         trCChartObjectArrow_Subwindow.Anchor(anch);
         trCChartObjectArrow_Subwindow.Description("Forming: "+TM.ToString(_Period));
         trCChartObjectArrow_Subwindow.Tooltip(obName);
         
      }
      
      if (divergence_chart_draw_enable){
         string   obName   = trObjBaseName+"_"+"CH";
         
         double   low      = iLow(_Symbol,_Period,0);
         double   high     = iHigh(_Symbol,_Period,0);
         
         int      shift    = 0;
         double   range    = 0;
         int      j        = 0;
         for (j = shift;j <= shift + 9;j++)
            range += MathAbs(iHigh(Symbol(),Period(),j)-iLow(Symbol(),Period(),j));
         range /= j;
         
         double   price    = (trSignalType % 2 == 0) ? low - range * 0.5 : high + range * 0.5 ;
         
         double   price1   = price;//trSignalType % 2 == 0 ? low : high;
         datetime time1    = TimeCurrent();
         char     code     = trSignalType % 2 == 0 ? (char)233 : (char)234;
         ENUM_ARROW_ANCHOR anch  = trSignalType % 2 == 0 ? ANCHOR_TOP : ANCHOR_BOTTOM;
         
         if (!trCChartObjectArrow_Chart.Create(0, obName, 0, time1, price1, code))
            trCChartObjectArrow_Chart.Attach(0, obName, 0, 1);
         
         color clr   = trSignalType == BUY ? color_arrow_up : color_arrow_dn;  
         trCChartObjectArrow_Chart.Price(0, price1);
         trCChartObjectArrow_Chart.Time(0, time1);
         trCChartObjectArrow_Chart.Color(clr);
         trCChartObjectArrow_Chart.Width(1);
         trCChartObjectArrow_Chart.Description("Forming: "+TM.ToString(_Period));
         trCChartObjectArrow_Chart.Anchor(anch);
         trCChartObjectArrow_Chart.Tooltip(obName);
         
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
            trCChartObjectArrow_Subwindow.Delete();
            trCChartObjectArrow_Chart.Delete();
            ChartRedraw(0);
         }
         else{
            ActionDrawing(HEAD_TO_STRING);
            ChartRedraw(0);
         }
         
      }
   }
   
   void OnTick(int shift){
      
      datetime time  = iTime(_Symbol, _Period, shift);
      
      if (time != trTime_Start){
         trCChartObjectArrow_Chart.Delete();
         trCChartObjectArrow_Subwindow.Delete();
         UpdateIsFinished(shift, true, HEAD_TO_STRING);
      }
      
      if (!trIsFinished){
         ActionDrawing(HEAD_TO_STRING);
      }
   }
   
   void UpdateIsFinished(int shift, bool val, string reason){
      if (trIsFinished != val){
         trIsFinished   = val;
      
         IFLOG{
            TM.Log(
                     TM.ToString(trName)+", "+
                     TM.ToString(trIsFinished)+", "+
                     TM.ToString(reason)
                     ,shift);
         
         }
      }
   }
};
