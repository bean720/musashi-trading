//+------------------------------------------------------------------+
//|                                                ButtonHandler.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <ChartObjects\\ChartObjectsTxtControls.mqh>

#include "..//Button//ButtonHandler.mqh"

class ButtonHandler{
   public:
   Button* buttons[];
   
   CChartObjectLabel trCChartObjectLabel_Text;
   
   ButtonHandler(){
      
      DrawLabel();
   }
   
   void DrawLabel(){
      if (from_ea) return;
      
      string   obName      = glPrefix + "Text_";
      int      sub_wind    = TM.GetIndicatorSubWindow();
      trCChartObjectLabel_Text.Create(0,obName,sub_wind,startXForBut,startYForText);
      trCChartObjectLabel_Text.FontSize(text_size);
      trCChartObjectLabel_Text.Color(text_color);
      trCChartObjectLabel_Text.Description(text_input);
      trCChartObjectLabel_Text.Corner(CORNER_RIGHT_UPPER);
   }
   
   ~ButtonHandler(){
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         delete buttons[i];
      }
   }
   
   void AddButton(Button *button){
      ArrayResize(buttons,ArrayRange(buttons,0)+1);
      buttons[ArrayRange(buttons,0)-1] = GetPointer(button);
   }
   
   void OnTick(){
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         buttons[i].OnTick();
		}
   }
   
   int GetMinEnabledTf_Extreme(){
      int   val   = -1;
      for (int i = 0;i < ArrayRange(glArray_mbfx_enable,0);i++){
         //Print(
         //      HEAD_TO_STRING+
         //      TM.ToString(i)+", "+
         //      TM.ToString(buttons[i].btName)+", "+
         //      TM.ToString(buttons[i].GetButtonState())+", "+
         //      TM.ToString(glArray_extreme_level_enable[i])
         //      );
         if (buttons[i].GetButtonState() && glArray_extreme_level_enable[i]){
            val   = i;
            break;
         }
		}
		
		return   val;
   }
   
   void OnChartEvent(int id,
                  long lparam, 
                  double dparam, 
                  string sparam 
                  ){
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         if (CheckPointer(buttons[i]) != POINTER_INVALID){
            buttons[i].OnChartEvent(id,lparam,dparam,sparam);
         }
      }      
   }
   
};
ButtonHandler* glButtonHandler;