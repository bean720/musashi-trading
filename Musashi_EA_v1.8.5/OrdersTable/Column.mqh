//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "../MQH\Enums.mqh"
#include "../Signals\SignalBase.mqh"
#include "../MQH\TradingManager.mqh"

//BaseClass for a Cell in the visual panel
class Column{
   public:
   string   clName;
   
   int      clPairIndex;
   string   clPair;
   
   int      clSubWindow;
   int      clIndex;
   int      clStartX;
   int      clTimeframe;
   int      clXSize;
   int      clYSize;
   
   int      clBaseX;
   int      clBaseY;
   
   bool     clFirstInit;
   bool     clDisableGraphic;
   
   EnumColumnType     clColType;
   
   Trade                *trTrade;
   
   //Column constructor
   Column(){
   }
   
   //Column destructor
   ~Column(){
   }
   
   //Main calculations
   virtual void OnTick(){
   }
   
   //checking is the cell enabled/disabled
   virtual bool CheckIsEnabled(){
      return   false;
   }
   
   //drawing the cell obj 
   virtual void DrawObject(){
   }
   
   //enable/disable the cell obj
   void UpdateDisableGraphic(bool state){
      if (clDisableGraphic != state){
         clDisableGraphic = state;
      }
   }
   
   //delete the cell obj
   void DeleteObject(){
      ObjectDelete(0,clName);
   }
   
   //Event for a click
   virtual void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
                  
   }
   
   //get the cell X coord
   int GetX(){
      return clStartX;
   }
   
   //get next cell X coord
   int GetNextX(){
      return clStartX + clXSize + xPadding;
   }
   
   //get the cell Y coord
   int GetY(){
      if (clColType == ColumnTypeMain){
         return startYForMainLines + ySizeForMainLines / 2 + clIndex * (ySizeForMainLines + yPadding);
      }
      else if (clColType == ColumnTypeHead1){
         return startYForHeadLines + ySizeForHead1Lines / 2;// - 2 * yPadding;
      }
      else if (clColType == ColumnTypeHead2){
         return startYForHead2Lines;//startYForHeadLines + ySizeForHead1Lines + yPadding + ySizeForHeadLines;
      }
      else{
         return glLastMainPoint + ySizeForFootLines;
      }
   }
   
   bool ButtonCreate(
                     const string            name="Button",          
                     const int               x=0,                   
                     const int               y=0,                    
                     const int               width=50,                 
                     const int               height=18,               
                     const string            text="Button",           
                     const bool              state=false,   
                           color             back_clr=clrNONE,  
                     const int               sub_window=0,            
                     const color             clr=clrWhite, 
                     const color             border_clr=clrWhite,      
                     const bool              back=false,              
                     const bool              selection=false,        
                     const bool              hidden=true,            
                     const long              z_order=1,
                     const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, 
                     const string            font="Arial",             
                     //const int               font_size=10,             
                     const long              chart_ID=0              
                     ){ 
      ResetLastError(); 
      if (ObjectFind(0,name) == -1){
         if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)){ 
            Print(__FUNCTION__, ": err = ",GetLastError()); 
            return(false); 
         } 
      } 
      
      int   font_size = int(height/2.5);
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
      //ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,BORDER_SUNKEN); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state); 
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
      return(true); 
   }    
      
   
};
