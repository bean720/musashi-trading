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

//Base class for lowest Head line in the table. Fuc-s the same as in the FootLine
class HeadLine{
   public:
   string   mnLine;
   
   int      mnIndex;
   
   Column   *columns[];
   
   HeadLine(int index){
   
      mnIndex     = index;
      int   mnPairIndex = mnIndex;
   
      mnLine = "HL_"+TM.ToString(mnIndex);
      
      EnumColumnType   colType   = ColumnTypeHead2;
      AddColumn(new ColumnColor(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnTicket(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnRtrRatio(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnAmount(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnExitTp(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnExitSl(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      
      //AddColumn(new ColumnPrice(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnSpread(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnRsi(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnFibo(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnTradeType(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnLots(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnProfit(colType,mnPairIndex,mnIndex,GetNextStartX()));
      //AddColumn(new ColumnClosePair(colType,mnPairIndex,mnIndex,GetNextStartX()));
      
   }
   
   ~HeadLine(){
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
   
   void DeleteObjects(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         columns[i].DeleteObject();
      }
   }
   
   void UpdateDisableGraphic(bool state){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         columns[i].UpdateDisableGraphic(state);
      }
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
