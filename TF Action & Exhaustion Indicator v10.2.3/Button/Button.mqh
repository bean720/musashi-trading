//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "..//Enums.mqh"
#include "..//Signal//SignalBase.mqh"
#include "..//TradingManager.mqh"

#include <ChartObjects\\ChartObjectsTxtControls.mqh>


class Button{
   public:
   string   btName;
   
   int      btIndex;
   int      btTf;
   int      btXIndex;
   int      btYIndex;
   
   Button(int index){
      
      btIndex   = index;
      btTf      = glArray_Timeframes[btIndex];
      int      numb  = 1;
      btXIndex  = (int)MathMod(btIndex,numb);
      btYIndex  = (int)MathFloor(btIndex / numb);
      
      btName      = glPrefix+"Btn_"+TM.ToString(btIndex)+"$"+TM.ToString(btXIndex)+":"+TM.ToString(btYIndex);
      
      DrawObject();
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(btName)+" created"
               ,0,_Symbol);
     
   }
   
   ~Button(){
      if (_UninitReason != REASON_CHARTCHANGE)
         ObjectDelete(0,btName);
   }
   
   
   virtual void OnTick(){
   
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      if (sparam == btName){
         bool  state    = GetButtonState(); 
         IFLOG
            TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(btName)+" clicked: "+
                  TM.ToString(state)
                  ,0,_Symbol);
         bool  enabled  = glArray_mbfx_enable[btIndex];
         
         if (!enabled){
            //ObjectSetInteger(0,btName,OBJPROP_STATE,enabled); 
            SetButtonState(enabled);
         }
         else{
            SetNewData();
         }         
         DrawObject();         
      }                           
   }
   
   bool GetButtonState(){
      bool  val   = ObjectGetInteger(0,btName,OBJPROP_STATE);
      return   val;
   }

   bool SetButtonState(bool newState){
      return   ObjectSetInteger(0,btName,OBJPROP_STATE,newState); ;
   }

   void SetNewData(){
      int   index    = 4 + 3 * btIndex;
      bool  state    = ObjectGetInteger(0,btName,OBJPROP_STATE); 
      
      glArray_DivergenceHandler[btIndex].UpdateIsDrawn(state, HEAD_TO_STRING);
      glArray_DivergenceHandler_Forming[btIndex].UpdateIsDrawn(state, HEAD_TO_STRING);
      
      glArray_ConvergenceHandler[btIndex].UpdateIsEnableDrawn(0, state, HEAD_TO_STRING);
      glArray_DivergenceZoneHandler[btIndex].UpdateIsEnableDrawn(0, state, HEAD_TO_STRING);

      int   style    = state ? DRAW_LINE : DRAW_NONE;
      
      SetIndexStyle(index++,style);
      SetIndexStyle(index++,style);
      SetIndexStyle(index++,style);
      
   }

   void DrawObject(){
      int   x  = startXForBut - xSizeForBut * btXIndex - xPadding * btXIndex;
      int   y  = startYForBut + ySizeForBut * btYIndex + yPadding * btYIndex;
      ButtonCreate(x,y);
   }
   
   bool ButtonCreate(
                     const int               x=0,                   
                     const int               y=0,                    
                          
                           color             back_clr=clrBlack,  
                     const color             border_clr=clrNONE,      
                     const bool              back=false,              
                     const bool              selection=false,        
                     const bool              hidden=true,            
                     const long              z_order=1,
                     const ENUM_BASE_CORNER  corner=CORNER_RIGHT_UPPER, 
                     const string            font="Arial",             
                     const long              chart_ID=0              
                     ){ 
      
      if (from_ea) return (true);
                     
      string   name        = btName;
      int      sub_window  = TM.GetIndicatorSubWindow();
      string   tf          = EnumToString((ENUM_TIMEFRAMES)btTf);
      StringReplace(tf,"PERIOD_","");
      string   text        = tf;
      int      width       = xSizeForBut;               
      int      height      = ySizeForBut; 
      color    clr         = clrAqua;
      int      font_size   = int(height / 3);             
                                  
      ResetLastError(); 
      if (ObjectFind(0,name) == -1){
         if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)){ 
            Print(__FUNCTION__, ": err = ",GetLastError()); 
            return(false); 
         } 
         ObjectSetInteger(chart_ID,name,OBJPROP_STATE,glArray_mbfx_enable[btIndex]); 
      }   
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
      return(true); 
   }    
   
   
};


class TextConvergence : public Button{
   public:
   
   TextConvergence(int index) : Button (index){
      
      btIndex   = index;
      btTf      = glArray_Timeframes[btIndex];
      int      numb  = 1;
      btXIndex  = (int)MathMod(btIndex,numb);
      btYIndex  = (int)MathFloor(btIndex / numb);
      
      btName      = glPrefix+"Cnv_"+TM.ToString(btIndex)+"$"+TM.ToString(btXIndex)+":"+TM.ToString(btYIndex);
      
      DrawObject();
      
      TM.Log(
               HEAD_TO_STRING+
               TM.ToString(btName)+" created"
               ,0,_Symbol);
     
   }
   
   ~TextConvergence(){
      if (_UninitReason != REASON_CHARTCHANGE)
         ObjectDelete(0,btName);
   }
   
   
   void OnTick(){
      DrawObject();
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      if (sparam == btName){
         IFLOG
            TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(btName)+" clicked: "
                  ,0,_Symbol);
      }                           
   }
   
   void DrawObject(){
      int   x  = startXForBut - xSizeForBut - xPadding;
      int   y  = startYForBut + ySizeForBut * btYIndex + yPadding * btYIndex;
      ObjCreate(x, y);
   }
   
   bool ObjCreate(
                     const int               x=0,                   
                     const int               y=0,                    
                          
                           color             back_clr=clrBlack,  
                     const color             border_clr=clrNONE,      
                     const bool              back=false,              
                     const bool              selection=false,        
                     const bool              hidden=true,            
                     const long              z_order=1,
                     const ENUM_BASE_CORNER  corner=CORNER_RIGHT_UPPER, 
                     const string            font="Arial",             
                     const long              chart_ID=0              
                     ){ 
                     
      if (from_ea) return (true);
                     
      string   name        = btName;
      int      sub_window  = TM.GetIndicatorSubWindow();
      string   tf          = EnumToString((ENUM_TIMEFRAMES)btTf);
      
      datetime timeCur     = TimeCurrent();
      datetime timeCross   = 0;
      
      Convergence*   inst  = NULL;
      Convergence*   real  = glArray_ConvergenceHandler[btIndex].GetNearestFutureConvergence(0);
      
      if (IS_NOT_NULL(real)){
         inst = real;
      }
      else {
         Convergence*   hist  = glArray_ConvergenceHandler[btIndex].GetNearestHistoryConvergence(0);
         if (IS_NOT_NULL(hist))
            inst = hist;
      }
      
      if (IS_NOT_NULL(inst)){
         timeCross   = inst.trStructConvergence.trStructPoint_ExactCross.trTime;
      }
      
      int   seconds  = timeCross == 0 ? 0 : (int)timeCross - (int)timeCur;
      
      if (true){
         CChartObjectLabel obj;
         
         string   obName   = name;
         
         if (!obj.Create(0, obName, TM.GetIndicatorSubWindow(), x, y))
            obj.Attach(0, obName, TM.GetIndicatorSubWindow(), 1);
         
         color    clr      = clrAqua;
         
         int      hour     = (MathAbs(seconds) / (60 * 60));
         int      remSec   = MathAbs(seconds) % (60 * 60);
         int      min      = (remSec / 60) % 60;
         int      sec      = remSec % 60;
         
         
         string   sign     = seconds < 0 ? "-" : "";
         string   timer    = 
                              sign+" "+
                              (hour < 10 ? "0" : "") + TM.ToString(hour)+":"+
                              (min < 10 ? "0" : "") + TM.ToString(min)+":"+
                              (sec < 10 ? "0" : "") + TM.ToString(sec)
                              ;
         
         
         obj.X_Distance(x);
         obj.Y_Distance(y);
         obj.Color(clr);
         obj.FontSize(text_size);
         obj.Corner(corner);
         obj.Description(TM.ToString(timer));
         obj.Tooltip(obName);
         
         obj.Detach();
      }
      
      return(true); 
   }    
   
   
};
