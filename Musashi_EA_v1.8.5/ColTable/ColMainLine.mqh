//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "../Enums.mqh"
#include "ColCeils.mqh"
#include "../TradingManager.mqh"


class ColMainLine{
   public:
   string   mnLine;
   
   int      mnIndex;
   int      mnTimeframe;
   
   ColCeil   *columns[];
   
   ColMainLine(int index){
   
      mnIndex     = index;
      mnTimeframe = timeframes_array[index];
   
      mnLine = "ML_"+TM.ToString(mnIndex);
      
      AddColumn(new ColumnEnable(true,mnIndex,GetNextStartX(),mnTimeframe));
      AddColumn(new ColumnColorMbfxIndicator(true,mnIndex,GetNextStartX(),mnTimeframe));
      AddColumn(new ColumnColorAtrIndicator(true,mnIndex,GetNextStartX(),mnTimeframe));
      AddColumn(new ColumnTfName(true,mnIndex,GetNextStartX(),mnTimeframe));
      AddColumn(new ColumnEnableExit(true,mnIndex,GetNextStartX(),mnTimeframe));
      
   }
   
   ~ColMainLine(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         delete columns[i];
      }
   }
   
   int   GetNextStartX(){
      int   val   = col_startXForLines;
      int   size  = ArraySize(columns);
      
      if (size)
         val   = columns[size - 1].GetNextX();
      
      return val;
   }
   
   
   void AddColumn(ColCeil *clm){
      ArrayResize(columns,ArrayRange(columns,0)+1);
      columns[ArrayRange(columns,0)-1] = GetPointer(clm);
   }
   
   
   void OnTick(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         columns[i].OnTick();
      }
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         if (CheckPointer(columns[i]) != POINTER_INVALID){
            columns[i].OnChartEvent(id,lparam,dparam,sparam);
         }
      }      
   }
   
};
