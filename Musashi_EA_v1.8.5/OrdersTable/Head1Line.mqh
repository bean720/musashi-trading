//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "../MQH\Enums.mqh"
#include "Columns.mqh"
#include "../MQH\TradingManager.mqh"

//Base class for highest Head line in the table. Fuc-s the same as in the FootLine
class Head1Line{
   public:
   string   mnLine;
   
   int      mnIndex;
   
   Column   *columns[];
   
   Head1Line(int index){
   
      mnIndex     = index;
      int   mnPairIndex = mnIndex;
   
      mnLine = "H1L_"+TM.ToString(mnIndex);
      
      EnumColumnType   colType   = ColumnTypeHead1;
      AddColumn(new ColumnHide(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnGMT(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnServerTime(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnPcTime(colType,mnPairIndex,mnIndex,GetNextStartX()));
      
      
   }
   
   ~Head1Line(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         delete columns[i];
      }
   
   }
   
   int   GetNextStartX(){
      int   val   = startXForLines;
      int   size  = ArraySize(columns);
      
      if (size)
         val   = columns[size - 1].GetNextX();
      
      return val;
   }
   
   
   void AddColumn(Column *clm){
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
