//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "../Enums.mqh"
#include "ColCeil.mqh"
#include "../SignalBase.mqh"
#include "../Signals.mqh"
#include "../SignalHandler.mqh"
#include "../TradingManager.mqh"


class ColumnEnable : public ColCeil{
   public:
   
   ColumnEnable(bool main, int index, int startX, int timeframe){
      clIsMain    = main;
      clIndex     = index;
      clStartX    = startX;
      clName      = "CL_"+"Enable_"+TM.ToString(clIndex);
      clBaseX     = GetX();
      clBaseY     = GetY();
      clXSize     = col_xSizeForEnable;
      clYSize     = col_ySizeForMainLines;
      
      clTimeframe = timeframe;
   }
   
   ~ColumnEnable(){
      ObjectsDeleteAll(0,clName);
   }
   
   void OnTick(){
      DrawObject();
   }
   
   bool CheckIsEnabled(){
      bool  val   = false;
      
      if (ObjectFind(0,clName) != -1){
         val   = ObjectGetInteger(0,clName,OBJPROP_STATE);
      }
      else{
         val   = enable_timeframes_array[clIndex];
      }
      return   val;
   }
   
   
   
   void DrawObject(){
      if (clIsMain){
         int   x        = clBaseX;
         int   y        = clBaseY;
         int   width    = clXSize;
         int   height   = clYSize;
         
         bool     state    = CheckIsEnabled();
         string   text     = state ? "X" : "";
         color    clr      = clrNONE;
      
         TM.ButtonCreate(
                           clName,
                           x,
                           y,
                           width,
                           height,
                           text,
                           state,
                           clr,
                           col_panel_sub_window
                           );
      }     
      else{
      
      }             
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      if (sparam == clName){
         if (id == CHARTEVENT_OBJECT_CLICK){
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(clName)+" clicked"
                     );
                     
            DrawObject();  
         }       
      }                           
   }
};

class ColumnEnableExit : public ColCeil{
   public:
   
   ColumnEnableExit(bool main, int index, int startX, int timeframe){
      clIsMain    = main;
      clIndex     = index;
      clStartX    = startX;
      clName      = "CL_"+"EnableExit_"+TM.ToString(clIndex);
      clBaseX     = GetX();
      clBaseY     = GetY();
      clXSize     = col_xSizeForEnable;
      clYSize     = col_ySizeForMainLines;
      
      clTimeframe = timeframe;
   }
   
   ~ColumnEnableExit(){
      ObjectsDeleteAll(0,clName);
   }
   
   void OnTick(){
      DrawObject();
   }
   
   bool CheckIsEnabled(){
      bool  val   = false;
      if (ObjectFind(0,clName) != -1){
         val   = ObjectGetInteger(0,clName,OBJPROP_STATE);
      }
      else{
         val   = enable_exit_timeframes_array[clIndex];
      }
      return   val;
   }
   
   
   
   void DrawObject(){
      if (clIsMain){
         ActionDrawButton();
      }
      else{
         ActionDrawLabel();
      }                     
   }
   
   void ActionDrawButton(){
      int   x        = clBaseX;
      int   y        = clBaseY;
      int   width    = clXSize;
      int   height   = clYSize;
      
      bool     state    = CheckIsEnabled();
      string   text     = state ? "X" : "";
      color    clr      = clrNONE;
   
      TM.ButtonCreate(
                        clName,
                        x,
                        y,
                        width,
                        height,
                        text,
                        state,
                        clr,
                        col_panel_sub_window
                        );
   }
   
   void ActionDrawLabel(){
      int   x        = clBaseX;
      int   y        = clBaseY;
      //int   width    = clXSize;
      int   height   = int(clYSize / 2);
      
      //bool     state    = CheckIsEnabled();
      string   text      = "Exit";
      color    clr      = clrAqua; 
      string   name1    = clName + "1_";
      string   name2    = clName + "2_";
   
      TM.LabelCreate(
                        name1,
                        x,
                        y,
                        text,
                        height,
                        clr,
                        col_panel_sub_window
                        );
        
                        
      y     += int (height * 1.5);
      text  = "TF";
      
      TM.LabelCreate(
                        name2,
                        x,
                        y,
                        text,
                        height,
                        clr,
                        col_panel_sub_window
                        );
                      
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      if (sparam == clName){
         if (id == CHARTEVENT_OBJECT_CLICK){
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(clName)+" clicked"
                     );
                     
            DrawObject();    
         }     
      }                           
   }
};


class ColumnColorMbfxIndicator : public ColCeil{
   public:
   SignalHandler  *sSignalHandler;
   
   FilterColorMbfxIndicatorSignal   *sFilterColorMbfxIndicatorSignal;
   
   
   ColumnColorMbfxIndicator(bool main, int index, int startX, int timeframe){
      clIsMain    = main;
      clIndex     = index;
      clStartX    = startX;
      clName      = "CL_"+"Mbfx_"+TM.ToString(clIndex) + (clIsMain ? "" : "H_");
      clXSize     = col_xSizeForColorMbfx;
      clYSize     = col_ySizeForMainLines;
      clBaseX     = GetX();
      clBaseY     = GetY();
      
      clTimeframe = timeframe;
      
      sFilterColorMbfxIndicatorSignal  = new FilterColorMbfxIndicatorSignal(clName,clIndex);
      
      sSignalHandler = new SignalHandler("SH_Panel_MDFX:"+TM.ToString(clIndex));
      sSignalHandler.AddSignal(sFilterColorMbfxIndicatorSignal);
      
   }
   
   ~ColumnColorMbfxIndicator(){
      ObjectsDeleteAll(0,clName);
      delete   sSignalHandler;
      delete   sFilterColorMbfxIndicatorSignal;
   }
   
   void OnTick(){
      //SH Actions
      DrawObject(false);
   }
   
   bool CheckIsEnabled(){
      bool  val   = false;
      return   val;
   }
   
   
   
   void DrawObject(bool onChartEvent){
      if (clIsMain){
         ActionDrawButton(onChartEvent);
      }
      else{
         ActionDrawLabel(onChartEvent);
      }   
   
   }
   
   void ActionDrawLabel(bool onChartEvent){
      int   x        = clBaseX;
      int   y        = clBaseY;
      //int   width    = clXSize;
      int   height   = int(clYSize / 2);
      
      //bool     state    = CheckIsEnabled();
      string   text      = "Entry";
      color    clr      = clrAqua; 
      string   name1    = clName + "1_";
      string   name2    = clName + "2_";
   
      TM.LabelCreate(
                        name1,
                        x,
                        y,
                        text,
                        height,
                        clr,
                        col_panel_sub_window
                        );
        
                        
      y     += int (height * 1.5);
      text  = "Filters";
      
      TM.LabelCreate(
                        name2,
                        x,
                        y,
                        text,
                        height,
                        clr,
                        col_panel_sub_window
                        );
                      
   }
   
   void ActionDrawButton(bool onChartEvent){
      SignalHandler *sh = sSignalHandler;
      
      if (TM.new_bars[clIndex] || onChartEvent || !first_init){//TODO timeframes
         sh.OnTick();
         
         sh.LogOpenSignal();
         
         SignalType  openSignal  = sh.GetOpenSignal();
         
         
         int   x        = clBaseX;
         int   y        = clBaseY;
         int   width    = clXSize;
         int   height   = clYSize;
         
         bool     state    = CheckIsEnabled();
         string   text     = state ? "" : "";
         color    clr      = openSignal == BUY ? clr_uptrend : openSignal == SELL ? clr_dntrend : openSignal == BOTH ? clr_fttrend : clrNONE; 
         
      
         TM.ButtonCreate(
                           clName,
                           x,
                           y,
                           width,
                           height,
                           text,
                           state,
                           clr,
                           col_panel_sub_window
                           );
      
      }   
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      if (sparam == clName){
         if (id == CHARTEVENT_OBJECT_CLICK){
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(clName)+" clicked"
                     );
                     
            DrawObject(true);   
         }      
      }                           
   }
};


class ColumnColorAtrIndicator : public ColCeil{
   public:
   SignalHandler  *sSignalHandler;
   
   FilterColorAtrIndicatorSignal   *sFilterColorAtrIndicatorSignal;
   
   
   ColumnColorAtrIndicator(bool main, int index, int startX, int timeframe){
      clIsMain    = main;
      clIndex     = index;
      clStartX    = startX;
      clName      = "CL_"+"Atr_"+TM.ToString(clIndex);
      clXSize     = col_xSizeForColorAtr;
      clYSize     = col_ySizeForMainLines;
      clBaseX     = GetX();
      clBaseY     = GetY();
      
      clTimeframe = timeframe;
      
      sFilterColorAtrIndicatorSignal  = new FilterColorAtrIndicatorSignal(clName,clIndex);
      
      sSignalHandler = new SignalHandler("SH_Panel_ATR:"+TM.ToString(clIndex));
      sSignalHandler.AddSignal(sFilterColorAtrIndicatorSignal);
      
   }
   
   ~ColumnColorAtrIndicator(){
      ObjectsDeleteAll(0,clName);
      delete   sSignalHandler;
      delete   sFilterColorAtrIndicatorSignal;
   }
   
   void OnTick(){
      DrawObject(false);
   }
   
   bool CheckIsEnabled(){
      bool  val   = false;
      return   val;
   }
   
   
   
   void DrawObject(bool onChartEvent){
      if (clIsMain){
         SignalHandler *sh = sSignalHandler;
         
         if (TM.new_bars[clIndex] || onChartEvent || !first_init){//TODO timeframes
            sh.OnTick();
            
            sh.LogOpenSignal();
            
            SignalType  openSignal  = sh.GetOpenSignal();
            
            
            int   x        = clBaseX;
            int   y        = clBaseY;
            int   width    = clXSize;
            int   height   = clYSize;
            
            bool     state    = CheckIsEnabled();
            string   text     = state ? "" : "";
            color    clr      = openSignal == BUY ? clr_uptrend : openSignal == SELL ? clr_dntrend : openSignal == BOTH ? clr_fttrend : clrNONE; 
            
         
            TM.ButtonCreate(
                              clName,
                              x,
                              y,
                              width,
                              height,
                              text,
                              state,
                              clr,
                              col_panel_sub_window
                              );
         
         }
      }   
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      if (sparam == clName){
         if (id == CHARTEVENT_OBJECT_CLICK){
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(clName)+" clicked"
                     );
                     
            DrawObject(true);   
         }      
      }                           
   }
};

class ColumnTfName : public ColCeil{
   public:
   
   ColumnTfName(bool main, int index, int startX, int timeframe){
      clIsMain    = main;
      clIndex     = index;
      clStartX    = startX;
      clName      = "CL_"+"TFN_"+TM.ToString(clIndex);
      clXSize     = col_xSizeForTf;
      clYSize     = col_ySizeForMainLines;
      clBaseX     = GetX();
      clBaseY     = GetY();
      
      clTimeframe = timeframe;
      
   }
   
   ~ColumnTfName(){
      ObjectsDeleteAll(0,clName);
   }
   
   void OnTick(){
      //SH Actions
      DrawObject(false);
   }
   
   bool CheckIsEnabled(){
      bool  val   = false;
      return   val;
   }
   
   
   
   void DrawObject(bool onChartEvent){
      if (clIsMain){
         int   x        = clBaseX;
         int   y        = clBaseY;
         int   width    = clXSize;
         int   height   = int(clYSize / 1.5);
         
         bool     state    = CheckIsEnabled();
         string   text      = EnumToString(ENUM_TIMEFRAMES(clTimeframe));
         StringReplace(text,"PERIOD_","");
         color    clr      = clrAqua; 
         
      
         TM.LabelCreate(
                           clName,
                           x,
                           y,
                           text,
                           height,
                           clr,
                           col_panel_sub_window
                           );
      
      }
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      if (sparam == clName){
         if (id == CHARTEVENT_OBJECT_CLICK){
            TM.Log(
                     HEAD_TO_STRING+
                     TM.ToString(clName)+" clicked"
                     );
                     
            DrawObject(true);     
         }    
      }                           
   }
};


