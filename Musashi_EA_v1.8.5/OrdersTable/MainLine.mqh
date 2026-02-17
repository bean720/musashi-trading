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

#include "../Trade/Trade.mqh"
#include "../Trade/TradesHandler.mqh"

//Base class for main line in the table (with data). 
//Fuc-s the same as in the FootLine
class MainLine{
   public:
   string   mnLine;
   
   int      mnPairIndex;
   string   mnPair;
   
   int      mnIndex;
   
   Column   *columns[];
   
   Trade    *trTrade;
   
   MainLine(int index, int pairIndex, Trade *trade){
      trTrade     = trade;
      mnIndex     = index;
      mnPairIndex = pairIndex;
      mnPair      = _Symbol;
   
      mnLine = "ML_"+mnPair+"_"+TM.ToString(mnIndex);
      
      EnumColumnType   colType   = ColumnTypeMain;
      AddColumn(new ColumnColor(trTrade,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnTicket(trTrade,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnRtrRatio(trTrade,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnAmount(trTrade,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnExitTp(trTrade,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnExitSl(trTrade,colType,mnPairIndex,mnIndex,GetNextStartX()));

   }
   
   ~MainLine(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         delete columns[i];
      }
   
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
            /*
            Trade tr = columns[i].trTrade;
            
            if (CheckPointer(tr) != POINTER_INVALID){
               if (tr.trIsSelected){
                  
               }
            }
            */
         }
      }      
   }
   
};
