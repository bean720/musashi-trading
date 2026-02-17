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

//Class for footer for panel
class FootLine{
   public:
   string   mnLine;
   
   int      mnIndex;
   
   Column   *columns[];
   
   //constructor
   FootLine(int index){
   
      mnIndex     = index;
      int   mnPairIndex = mnIndex;
   
      mnLine = "FL_"+TM.ToString(mnIndex);
      
      EnumColumnType   colType   = ColumnTypeFoot;
      
      AddColumn(new ColumnColor(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnTicket(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnRtrRatio(NULL,colType,mnPairIndex,mnIndex,GetNextStartX()));
      AddColumn(new ColumnFootTotal(colType,mnPairIndex,mnIndex,GetNextStartX()));
   }
   
   void UpdateY(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         columns[i].clBaseY   = columns[i].GetY();
      }
   }
   
   //desctructor
   ~FootLine(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         delete columns[i];
      }
   
   }
   
   //get next X coord
   int   GetNextStartX(){
      int   val   = startXForLines;
      int   size  = ArraySize(columns);
      
      if (size)
         val   = columns[size - 1].GetNextX();
      
      return val;
   }
   
   //add new ceil
   void AddColumn(Column *clm){
      ArrayResize(columns,ArrayRange(columns,0)+1);
      columns[ArrayRange(columns,0)-1] = GetPointer(clm);
   }
   
   //delete visual obj-s
   void DeleteObjects(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         columns[i].DeleteObject();
      }
   }
   
   //enable/disavle visual obj-s
   void UpdateDisableGraphic(bool state){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         columns[i].UpdateDisableGraphic(state);
      }
   }
   
   //main calculations
   void OnTick(){
      for (int i = 0;i < ArrayRange(columns,0);i++){
         columns[i].OnTick();
      }
   }
   
   //event for a click
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
