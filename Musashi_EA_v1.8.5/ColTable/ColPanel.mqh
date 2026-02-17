//+------------------------------------------------------------------+
//|                                                ColPanel.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "ColHeadLine.mqh"
#include "ColMainLine.mqh"


class ColPanel{
   public:
   ColHeadLine*   headLine;
   ColMainLine*   mainLines[];
   
   int            trXCoordLast;
   
   string      pName;
   
   ColPanel(){
   
      pName    = "Panel_";
   
      headLine = new ColHeadLine(0);
   
      int   index = 0;
      AddMainLine(new ColMainLine(index++)); 
      AddMainLine(new ColMainLine(index++));
      AddMainLine(new ColMainLine(index++));
      AddMainLine(new ColMainLine(index++));
      AddMainLine(new ColMainLine(index++));
      AddMainLine(new ColMainLine(index++));
      AddMainLine(new ColMainLine(index++));
      AddMainLine(new ColMainLine(index++));
      AddMainLine(new ColMainLine(index++));
      
      DrawBackGround();
   }
   
   ~ColPanel(){
      ObjectsDeleteAll(0,pName);
      delete   headLine;
      for (int i = 0;i < ArrayRange(mainLines,0);i++){
         delete mainLines[i];
      }
   }
   
   void DrawBackGround(){
      if (TM.IsTestMode())
         return;
   
      int   baseXStart  = col_startXForLines;
      int   baseYStart  = col_startYForHeadLines;
      int   baseXEnd    = mainLines[ArrayRange(mainLines,0)-1].columns[ArrayRange(mainLines[ArrayRange(mainLines,0)-1].columns,0)-1].GetX() + col_xSizeForEnable;
      int   baseYEnd    = mainLines[ArrayRange(mainLines,0)-1].columns[ArrayRange(mainLines[ArrayRange(mainLines,0)-1].columns,0)-1].GetY() + col_ySizeForMainLines;
      
      int   baseXSize   = baseXEnd - baseXStart;
      int   baseYSize   = baseYEnd - baseYStart;
      
      int   x           = baseXStart - col_bcgPadding;
      int   y           = baseYStart;
      
      int   xSize       = baseXSize + col_bcgPadding * 2;
      int   ySize       = baseYSize + col_bcgPadding;
      
      trXCoordLast      = x + xSize;
      
      TM.RectLabelCreate(pName,col_panel_sub_window,x,y,xSize,ySize);
      
   }
   
   void AddMainLine(ColMainLine *mline){
      ArrayResize(mainLines,ArrayRange(mainLines,0)+1);
      mainLines[ArrayRange(mainLines,0)-1] = GetPointer(mline);
   }
   
   void OnTick(){
      if (TM.IsTestMode())
         return;
   
      headLine.OnTick();
      for (int i = 0;i < ArrayRange(mainLines,0);i++){
         if (CheckPointer(mainLines[i]) != POINTER_INVALID){
            mainLines[i].OnTick();
         }
		}
   }
   
   bool  CheckIsEntryEnabledByIndex(int index){
      bool  val   = false;
      for (int i = 0;i < ArrayRange(mainLines,0);i++){
         if (CheckPointer(mainLines[i]) != POINTER_INVALID){
            if (mainLines[i].mnIndex == index){
               val   = mainLines[i].columns[0].CheckIsEnabled();
               break;
            }
         }
      }
      return   val;   
   }
   
   bool  CheckIsExitEnabledByIndex(int index){
      bool  val   = false;
      for (int i = 0;i < ArrayRange(mainLines,0);i++){
         if (CheckPointer(mainLines[i]) != POINTER_INVALID){
            if (mainLines[i].mnIndex == index){
               val   = mainLines[i].columns[ArraySize(mainLines[i].columns) - 1].CheckIsEnabled();
               break;
            }
         }
      }
      return   val;   
   }
   
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      for (int i = 0;i < ArrayRange(mainLines,0);i++){
         if (CheckPointer(mainLines[i]) != POINTER_INVALID){
            mainLines[i].OnChartEvent(id,lparam,dparam,sparam);
         }
      }      
   }
   
};
//ColPanel* panel;
