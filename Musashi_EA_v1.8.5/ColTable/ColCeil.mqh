//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "../Enums.mqh"
#include "../SignalBase.mqh"
#include "../TradingManager.mqh"


class ColCeil{
   public:
   string   clName;
   
   int      clSubWindow;
   int      clIndex;
   int      clStartX;
   int      clTimeframe;
   int      clXSize;
   int      clYSize;
   
   int      clBaseX;
   int      clBaseY;
   
   bool     clFirstInit;
   
   bool     clIsMain;
   
   
   ColCeil(){
      clName = "CL_";
   }
   
   ~ColCeil(){
   }
   
   virtual void OnTick(){
   }
   
   virtual bool CheckIsEnabled(){
      return   false;
   }
   
   virtual void DrawObject(){
   }
   
   virtual void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
                  
   }
   
   int GetX(){
      return clStartX;
   }
   
   int GetNextX(){
      return clStartX + clXSize + col_xPadding;
   }
   
   int GetY(){
      if (clIsMain){
         return col_startYForMainLines + col_ySizeForMainLines + clIndex * (col_ySizeForMainLines + col_yPadding);
      }
      else{
         return col_startYForHeadLines + col_ySizeForHeadLines;
      }
   }
   
   
};
