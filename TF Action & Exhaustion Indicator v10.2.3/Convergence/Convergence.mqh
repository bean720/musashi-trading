//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "..\\TradingManager.mqh"
#include "..\\Structs.mqh"

#include <ChartObjects\\ChartObjectsTxtControls.mqh>


class Convergence{
   public:
   string            trName;
   string            trObjBaseName;
   
   int               trIndex;
   ENUM_TIMEFRAMES   trTimeframe;
   
   bool              trIsDrawn;
   bool              trIsEnableDrawn;
   bool              trIsFinalTime;
   bool              trIsInvalidFor_All_Modes;
   bool              trIsReachedForAlertXMinutesBefore;
   bool              trIsReachedForAlertLine;
   
   datetime          trAlertLastTime;
   datetime          trAlertTimeCurrent;
   
   SignalType        trSignalType;
   
   StructConvergence trStructConvergence;
   
   CChartObjectTrend trCChartObjectTrend_SW_Up;
   CChartObjectTrend trCChartObjectTrend_SW_Up_Ray;
   CChartObjectTrend trCChartObjectTrend_SW_Dn;
   CChartObjectTrend trCChartObjectTrend_SW_Dn_Ray;
   
   CChartObjectText  CChartObjectText_CrossX;
   
   CChartObjectVLine CChartObjectVLine_CrossVertical;
   
   Convergence(){
   
   }
   
   Convergence(
               int               shift,
               
               int               index,
               ENUM_TIMEFRAMES   tf,
               
               StructConvergence& conv,
               
               string            reason
               )
   {
      trIndex              = index;
      trTimeframe          = tf;
      
      trStructConvergence  = conv;
      trSignalType         = trStructConvergence.trSignalType;
      
      datetime    time     = GetRealTimeByCurrentShift(shift);
      
      trAlertLastTime      = 0;
      
      trName               = 
                              "DV_"+
                              TM.ToString(trTimeframe)+"_"+
                              EnumToString(trSignalType)+"_"+
                              TM.ToString(time)+"_"
                              ;
                              
      trObjBaseName        = glPrefix + "CV_"+TM.ToString(trTimeframe) + "_" + TM.ToString(time);                     
                              
      if (show_convergence == EnumShowConvergence_All){
         UpdateIsReadyForDrawn(shift, true, HEAD_TO_STRING);
      }
                              
                              
      int   bar   = iBarShift(_Symbol, trTimeframe, time);
      if (enable_alert_convergence && shift <= 1){
         TM.trStructAlert.Alert_ConvergenceRealIsDetected(shift, trTimeframe, trSignalType, time);
      }
      
      IFLOG
         TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString(bar)+", "+
               TM.ToString(shift)+", "+
               TM.ToString(signal_bar)+" | "+
               TM.ToString(reason)+" | "+
               TM.ToString(reason)+", "+
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
   
   ~Convergence(){
   }
   
   void OnTick(int shift){
      
      if (!trIsFinalTime){
         trStructConvergence.GetItersection(trTimeframe, shift);
         
         bool  isFinal  = iTime(_Symbol, trTimeframe, 0) > trStructConvergence.trStructPoint_ExactCross.trTime;
         UpdateIsFinalTime(shift, isFinal, HEAD_TO_STRING);
         
      }
      if (!trIsInvalidFor_All_Modes){
         CheckIsInvalidByNewPointsBeforeCross(shift);
      }
      
   }
   
   void OnTick_Alert(int shift){
      if (!trIsDrawn || !trIsEnableDrawn || trIsInvalidFor_All_Modes){
         return;
      }  
      
      trAlertTimeCurrent   = TimeCurrent();
      if (trAlertLastTime == 0){
         trAlertLastTime   = trAlertTimeCurrent;
      }
      
      ActionAlertBeforeXMinutes(shift);
      ActionAlertIsReached(shift);
      
      trAlertLastTime   = trAlertTimeCurrent;
   }
   
   void ActionAlertIsReached(int shift){
      if (!enable_alert_convergence_line) return;
      if (trIsReachedForAlertLine) return;
   
      datetime time_cur    = trAlertTimeCurrent;
      datetime time_cross  = trStructConvergence.trStructPoint_ExactCross.trTime;
      int      x_minutes   = alert_convergence_before_x_min;
      
      bool     isReached   = trAlertLastTime < time_cross && time_cur >= time_cross;
      bool     isInvalid   = trAlertLastTime > time_cross && time_cur > time_cross;
      
      if (isReached || isInvalid || shift > 0){
         IFLOG
            TM.Log(
                  HEAD_TO_STRING+
                  trName+", "+
                  TM.ToString(isInvalid)+", "+
                  TM.ToString(trAlertLastTime)+", "+
                  TM.ToString(time_cur)+", "+
                  TM.ToString(time_cross)+", "+
                  ToString()
                  );
      
         IFLOG
            TM.Log(
                  HEAD_TO_STRING+
                  trName+", "+
                  TM.ToString(isReached)+", "+
                  TM.ToString(time_cur)+", "+
                  TM.ToString(time_cross)+", "+
                  ToString()
                  );
      }
      
      if (isInvalid){
         UpdateIsReachedForAlertLine(shift, true, HEAD_TO_STRING);
         return;
      }
      
      datetime    time     = GetRealTimeByCurrentShift(shift);
      
      if (isReached){
         TM.trStructAlert.Alert_ConvergenceRealLine(shift, trTimeframe, TM.ToString(time_cross), time);
         UpdateIsReachedForAlertLine(shift, true, HEAD_TO_STRING);
      }
   }
   
   void ActionAlertBeforeXMinutes(int shift){
      if (!enable_alert_convergence_before_x_min) return;
      if (trIsReachedForAlertXMinutesBefore) return;
   
      datetime time_cur    = trAlertTimeCurrent;
      datetime time_cross  = trStructConvergence.trStructPoint_ExactCross.trTime;
      int      x_minutes   = alert_convergence_before_x_min;
      
      int      cur_difr    = (int)(time_cross - time_cur);
      int      minutes     = cur_difr / 60;
      
      bool     isReached   = time_cur >= time_cross - x_minutes * 60;
      
      if (cur_difr < 0 || isReached || shift > 0){
         IFLOG
            TM.Log(
                  HEAD_TO_STRING+
                  trName+", "+
                  TM.ToString(isReached)+", "+
                  TM.ToString(time_cur)+", "+
                  TM.ToString(time_cross)+", "+
                  TM.ToString(x_minutes)+", "+
                  TM.ToString(cur_difr)+", "+
                  TM.ToString(minutes)+", "+
                  ToString()
                  );
      }
      
      if (cur_difr < 0){
         UpdateIsReachedForAlertXMinutesBefore(shift, true, HEAD_TO_STRING);
         return;
      }
      
      datetime    time     = GetRealTimeByCurrentShift(shift);
      
      if (isReached){
         TM.trStructAlert.Alert_ConvergenceRealBeforeXMin(shift, trTimeframe, TM.ToString(minutes), time);
         UpdateIsReachedForAlertXMinutesBefore(shift, true, HEAD_TO_STRING);
      }
   }
   
   datetime GetRealTimeByCurrentShift(int shift){
      datetime    time_cur_tf = iTime(_Symbol, _Period, shift);
      int         bar_cur_tf  = iBarShift(_Symbol, trTimeframe, time_cur_tf);
      datetime    time        = iTime(_Symbol, trTimeframe, bar_cur_tf);
      
      return      time;
   }
   
   
   
   /*
   - If after a valid convergence pattern (4 points) 
   at least one up and one down point appears before 
   the convergence crossing point -> 
   this convergence should be recognized as invalidated.
   */
   void CheckIsInvalidByNewPointsBeforeCross(int shift){
   
      //datetime timeBase = iTime(_Symbol, _Period, shift);
      datetime timeBase = trStructConvergence.trStructPoint_ExactCross.trTime;
      int      bar      = iBarShift(_Symbol, trTimeframe, timeBase);
               bar      = MathMax(1, bar);
      int      bars     = iBars(_Symbol, trTimeframe);
      
      StructPoint lastUp;
      ZeroMemory(lastUp);
      StructPoint lastDn;
      ZeroMemory(lastDn);
      
      for (int i = bar; i < bars - 1; i++){
      
         datetime time     = iTime(_Symbol,trTimeframe,i);
         datetime time1    = iTime(_Symbol,trTimeframe,i+1);
         
         //if (trStructConvergence.trStructPoint_ExactCross.trTime <= time) continue;
         if (time1 <= trStructConvergence.trSubw_Up_TimeRight) break;
         if (time1 <= trStructConvergence.trSubw_Dn_TimeRight) break;
      
         double   yellow0  = TM.GetIndicator_Mdfx(trIndex,0,i);
         double   yellow1  = TM.GetIndicator_Mdfx(trIndex,0,i+1);
         
         double   green0   = TM.GetIndicator_Mdfx(trIndex,1,i);
         double   green1   = TM.GetIndicator_Mdfx(trIndex,1,i+1);
         
         double   red0     = TM.GetIndicator_Mdfx(trIndex,2,i);
         double   red1     = TM.GetIndicator_Mdfx(trIndex,2,i+1);
         
         bool     isBuy    = red1 != EMPTY_VALUE && red0 == EMPTY_VALUE;
         bool     isSell   = green1 != EMPTY_VALUE && green0 == EMPTY_VALUE;
         
         if (isBuy && !lastUp.trIsInitialized){
            lastUp.Initialize(yellow0, time);
         }
         if (isSell && !lastDn.trIsInitialized){
            lastDn.Initialize(yellow0, time);
         }
         
         /*
         if (isBuy || isSell){
            IFLOG
               TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     TM.ToString(i)+", "+
                     TM.ToString(isBuy)+", "+
                     TM.ToString(isSell)
                     );
         }
         */
         
         if (lastUp.trIsInitialized && lastDn.trIsInitialized){
            break;
         }
      }
      
      bool     isUninit = lastUp.trIsInitialized && lastDn.trIsInitialized;
      
      /*
      IFLOG
         TM.Log(
               HEAD_TO_STRING+
               trName+", "+
               TM.ToString(isUninit)+", "+
               lastUp.ToString()+", "+
               lastDn.ToString()
               );
               
      IFLOG
         TM.Log(
               HEAD_TO_STRING+
               trName+", "+
               ToString()
               );
      */
      UpdateIsInvalidFor_LastTwo_Mode(shift, isUninit, HEAD_TO_STRING);
   }
   
   string ToString(){
      string   val   = StringFormat(" | CConv: tN:%s, st:%s, iD?:%s, iFT?:%s, iVL2?:%s, c:%s | ",
                              trName,
                              
                              EnumToString(trSignalType),
                              
                              TM.ToString(trIsDrawn),
                              TM.ToString(trIsFinalTime),
                              TM.ToString(trIsInvalidFor_All_Modes),
                              
                              trStructConvergence.ToString()
                              );
      return   val;                        
   }
   
   int GetBarIndex(){
   //TODO
      return -1;//iBarShift(_Symbol, trTimeframe, trSubw_TimeRight);
   }
   
   virtual void ActionDrawing(string reason){
      if (!trIsDrawn || !trIsEnableDrawn || trIsInvalidFor_All_Modes){
         ObjectsDeleteAll(0, trObjBaseName);
         return;
      }  
             
      if (true){
         
         string   obName   = trObjBaseName+"_"+"Up";
         
         double   price1   = trStructConvergence.trSubw_Up_PriceLeft;
         double   price2   = trStructConvergence.trSubw_Up_PriceRight;
         
         datetime time1    = trStructConvergence.trSubw_Up_TimeLeft;
         datetime time2    = trStructConvergence.trSubw_Up_TimeRight;
         
         //CChartObjectTrend line;
         if (!trCChartObjectTrend_SW_Up.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, time2, price2))
            trCChartObjectTrend_SW_Up.Attach(0, obName, TM.GetIndicatorSubWindow(), 2);
         
         color clr   = glArray_convergence_color[trIndex];//trSignalType == BUY ? glArray_convergence_color_buy[trIndex] : glArray_convergence_color_sell[trIndex];  
         trCChartObjectTrend_SW_Up.Price(1, price2);
         trCChartObjectTrend_SW_Up.Time(1, time2);
         trCChartObjectTrend_SW_Up.Color(clr);
         trCChartObjectTrend_SW_Up.Width(glArray_convergence_width[trIndex]);
         trCChartObjectTrend_SW_Up.Description("CV_"+TM.ToString(trTimeframe));
         trCChartObjectTrend_SW_Up.Tooltip(obName);
         trCChartObjectTrend_SW_Up.RayRight(false);
         
      }
      if (true){
         
         string   obName   = trObjBaseName+"_"+"UpRay";
         
         double   price1   = trStructConvergence.trSubw_Up_PriceLeft;
         double   price2   = trStructConvergence.trSubw_Up_PriceCross_Draw;
         
         datetime time1    = trStructConvergence.trSubw_Up_TimeLeft;
         datetime time2    = trStructConvergence.trStructPoint_ExactCross.trTime;
         
         if (!trCChartObjectTrend_SW_Up_Ray.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, time2, price2))
            trCChartObjectTrend_SW_Up_Ray.Attach(0, obName, TM.GetIndicatorSubWindow(), 2);
         
         color clr   = glArray_convergence_color[trIndex];//trSignalType == BUY ? glArray_convergence_color_buy[trIndex] : glArray_convergence_color_sell[trIndex];  
         trCChartObjectTrend_SW_Up_Ray.Price(1, price2);
         trCChartObjectTrend_SW_Up_Ray.Time(1, time2);
         trCChartObjectTrend_SW_Up_Ray.Style(STYLE_DOT);
         trCChartObjectTrend_SW_Up_Ray.Color(clr);
         trCChartObjectTrend_SW_Up_Ray.Width(glArray_convergence_width[trIndex]);
         trCChartObjectTrend_SW_Up_Ray.Description("CV_"+TM.ToString(trTimeframe));
         trCChartObjectTrend_SW_Up_Ray.Tooltip(obName);
         trCChartObjectTrend_SW_Up_Ray.RayRight(false);
         
      }
      
      if (true){
      
         string   obName   = trObjBaseName+"_"+"Dn";
         
         double   price1   = trStructConvergence.trSubw_Dn_PriceLeft;
         double   price2   = trStructConvergence.trSubw_Dn_PriceRight;
         
         datetime time1    = trStructConvergence.trSubw_Dn_TimeLeft;
         datetime time2    = trStructConvergence.trSubw_Dn_TimeRight;
         
         //CChartObjectTrend line;
         if (!trCChartObjectTrend_SW_Dn.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, time2, price2))
            trCChartObjectTrend_SW_Dn.Attach(0, obName, TM.GetIndicatorSubWindow(), 2);
         
         color clr   = glArray_convergence_color[trIndex];//trSignalType == BUY ? glArray_convergence_color_buy[trIndex] : glArray_convergence_color_sell[trIndex];  
         trCChartObjectTrend_SW_Dn.Price(1, price2);
         trCChartObjectTrend_SW_Dn.Time(1, time2);
         trCChartObjectTrend_SW_Dn.Color(clr);
         trCChartObjectTrend_SW_Dn.Width(glArray_convergence_width[trIndex]);
         trCChartObjectTrend_SW_Dn.Description("CV_"+TM.ToString(trTimeframe));
         trCChartObjectTrend_SW_Dn.Tooltip(obName);
         trCChartObjectTrend_SW_Dn.RayRight(false);
         
      }
      if (true){
      
         string   obName   = trObjBaseName+"_"+"DnRay";
         
         double   price1   = trStructConvergence.trSubw_Dn_PriceLeft;
         double   price2   = trStructConvergence.trSubw_Dn_PriceCross_Draw;
         
         datetime time1    = trStructConvergence.trSubw_Dn_TimeLeft;
         datetime time2    = trStructConvergence.trStructPoint_ExactCross.trTime;
         
         if (!trCChartObjectTrend_SW_Dn_Ray.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1, time2, price2))
            trCChartObjectTrend_SW_Dn_Ray.Attach(0, obName, TM.GetIndicatorSubWindow(), 2);
         
         color clr   = glArray_convergence_color[trIndex];//trSignalType == BUY ? glArray_convergence_color_buy[trIndex] : glArray_convergence_color_sell[trIndex];  
         trCChartObjectTrend_SW_Dn_Ray.Price(1, price2);
         trCChartObjectTrend_SW_Dn_Ray.Time(1, time2);
         trCChartObjectTrend_SW_Dn_Ray.Color(clr);
         trCChartObjectTrend_SW_Dn_Ray.Width(glArray_convergence_width[trIndex]);
         trCChartObjectTrend_SW_Dn_Ray.Description("CV_"+TM.ToString(trTimeframe));
         trCChartObjectTrend_SW_Dn_Ray.Tooltip(obName);
         trCChartObjectTrend_SW_Dn_Ray.Style(STYLE_DOT);
         trCChartObjectTrend_SW_Dn_Ray.RayRight(false);
         
      }     
      
//---
      if (true){
         
         string   obName   = trObjBaseName+"_"+"X";
         
         double   price1   = trStructConvergence.trStructPoint_ExactCross.trPrice;
         datetime time1    = trStructConvergence.trStructPoint_ExactCross.trTime;
         
         if (!CChartObjectText_CrossX.Create(0, obName, TM.GetIndicatorSubWindow(), time1, price1))
            CChartObjectText_CrossX.Attach(0, obName, TM.GetIndicatorSubWindow(), 1);
         
         color clr   = glArray_convergence_color[trIndex];//trSignalType == BUY ? glArray_convergence_color_buy[trIndex] : glArray_convergence_color_sell[trIndex];  
         CChartObjectText_CrossX.Price(0, price1);
         CChartObjectText_CrossX.Time(0, time1);
         CChartObjectText_CrossX.Color(clr);
         CChartObjectText_CrossX.Description("x");
         CChartObjectText_CrossX.Tooltip(obName);
         
      }
      
      if (true){
         
         string   obName   = trObjBaseName+"_"+"Cross";
         
         datetime time1    = trStructConvergence.trStructPoint_ExactCross.trTime;
         
         if (!CChartObjectVLine_CrossVertical.Create(0, obName, 0, time1))
            CChartObjectVLine_CrossVertical.Attach(0, obName, 0, 1);
         
         color clr   = glArray_convergence_color[trIndex];//trSignalType == BUY ? glArray_convergence_color_buy[trIndex] : glArray_convergence_color_sell[trIndex];  
         CChartObjectVLine_CrossVertical.Time(0, time1);
         CChartObjectVLine_CrossVertical.Style(STYLE_DOT);
         CChartObjectVLine_CrossVertical.Color(clr);
         CChartObjectVLine_CrossVertical.Description("CV_X_"+TM.ToString(trTimeframe));
         CChartObjectVLine_CrossVertical.Tooltip(obName);
         
      }
      
       
   }
   
   void UpdateIsReadyForDrawn(int shift, bool val, string reason){
      if (trIsDrawn != val){
         trIsDrawn   = val;
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     TM.ToString(trIsDrawn)+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      
      }
   }
   
   void UpdateIsReachedForAlertLine(int shift, bool val, string reason){
      if (trIsReachedForAlertLine != val){
         trIsReachedForAlertLine   = val;
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     TM.ToString(trIsReachedForAlertLine)+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      
      }
   }
   
   void UpdateIsReachedForAlertXMinutesBefore(int shift, bool val, string reason){
      if (trIsReachedForAlertXMinutesBefore != val){
         trIsReachedForAlertXMinutesBefore   = val;
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     TM.ToString(trIsReachedForAlertXMinutesBefore)+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      
      }
   }
   
   void UpdateIsInvalidFor_LastTwo_Mode(int shift, bool val, string reason){
      if (trIsInvalidFor_All_Modes != val){
         trIsInvalidFor_All_Modes   = val;
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     TM.ToString(trIsInvalidFor_All_Modes)+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      
      }
   }
   
   
   
   void UpdateIsEnableDrawn(int shift, bool val, string reason){
      if (trIsEnableDrawn != val){
         trIsEnableDrawn   = val;
         
         if (!trIsEnableDrawn)
            ObjectsDeleteAll(0, trObjBaseName);
         else{
            ActionDrawing(reason+"::"+HEAD_TO_STRING);
         }      
         
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
   
   void UpdateIsFinalTime(int shift, bool val, string reason){
      if (trIsFinalTime != val){
         trIsFinalTime   = val;
         
         IFLOG{
            TM.Log(
                     HEAD_TO_STRING+
                     trName+", "+
                     ToString()+", "+
                     TM.ToString(reason)
                     ,shift);
         }
      
      }
   }
   
   
   
};
