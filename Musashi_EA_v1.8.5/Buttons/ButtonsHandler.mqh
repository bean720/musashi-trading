//+------------------------------------------------------------------+
//|                                                ButtonHandler.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "ButtonBase.mqh"
#include "Button.mqh"



class ButtonHandler{
   public:
   string         bhName;
   ButtonBase*    buttons[];
   
   ButtonHandler(string name){
      bhName  = name;
   }
   
   ~ButtonHandler(){
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         delete buttons[i];
      }
   }
   
   void AddButton(ButtonBase *button){
      ArrayResize(buttons,ArrayRange(buttons,0)+1);
      buttons[ArrayRange(buttons,0)-1] = GetPointer(button);
   }
   
   void OnTick(){
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         buttons[i].OnTick();
		}
   }
   
   int   GetLastRealY(){
      int      val   = butBaseY;
      int      size  = ArraySize(buttons);
      for (int i = size - 1; i >= 0; i--){
         if (!buttons[i].btTheSameRow){
            val   = buttons[i].btY + buttons[i].btYsize;
            break;
         }
      }
      return   val;
   }

   void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam){
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         buttons[i].OnChartEvent(id,lparam,dparam,sparam);
		}
   }
   
   void ActionHideShow(bool state, string name){
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         if (buttons[i].btName != name)
            buttons[i].SetOnChart(state);
		}
      for (int i = 0;i < ArrayRange(buttons,0);i++){
         if (buttons[i].btName != name)
            buttons[i].ActionHide();
		}
		
   }

};
ButtonHandler* button_handler;
