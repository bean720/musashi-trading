//+------------------------------------------------------------------+
//|                                                      Signals.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "../MQH\Enums.mqh"
#include "ButtonBase.mqh"
#include "../MQH\TradingManager.mqh"

class ButtonCloseHistory  : public ButtonBase{
   public:

   ButtonCloseHistory(){
      btName                     = prefix+"ButtonCloseHistory_"+TM.ToString(ArraySize(button_handler.buttons));
      btX                        = butBaseX + butBaseXsize;
      btY                        = button_handler.GetLastRealY() + butBaseShift;
      
      btXsize                    = butBaseXsize;
      btYsize                    = butBaseYsize;
      
      btTextFontSize             = (int)((btYsize / 3.5) * bp_text_scale);
      
      btColorButtonEnabled       = bp_close_hist_but_clr;
      btColorButtonDisabled      = bp_close_hist_but_clr;
      btColorTextEnabled         = bp_close_hist_text_clr;
      btColorTextDisabled        = bp_close_hist_text_clr;
      
      TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(btName)+" "+
               TM.ToString("created | ")+
               ToString()
               );
   }
   
   ~ButtonCloseHistory(){
      ObjectDelete(btName);
      TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(btName)+" "+
               TM.ToString("deleted | ")+
               ToString()
               );
   }
   
   string GetTextEnabled(){
      
      return   "Show";
   }
   
   string GetTextDisabled(){
      return   "Hide";
   }
   
   bool  GetState(){
      return   ObjectGetInteger(0,btName,OBJPROP_STATE) > 0;
   }
   
   void CreateButton(){
      ButtonCreates();
   }
   
   void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam){
      if (sparam == btName){
         bool   state = ObjectGetInteger(0,btName,OBJPROP_STATE);
         button_handler.ActionHideShow(state,btName);   
         button_handler.OnTick();
         TM.Log(  
                  HEAD_TO_STRING+
                  TM.ToString(btName)+","+
                  TM.ToString(sparam)+" | "+
                  TM.ToString(ToString())
                  );
      }         
   }
};



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class ButtonBuy  : public ButtonBase{
   public:

   ButtonBuy(bool inTheSameRow) : ButtonBase(){
      btName                     = prefix+"ButtonBuy_"+TM.ToString(ArraySize(button_handler.buttons));
      btX                        = butBaseX + butBaseXsize;
      btY                        = button_handler.GetLastRealY() + butBaseShift;
      btTheSameRow               = inTheSameRow;
      
      btXsize                    = (int)(butBaseXsize / 2 - butBaseShift / 2);
      btYsize                    = butBaseYsize;
      
      btTextFontSize             = (int)((btYsize / 3.5) * bp_text_scale);
      
      btColorButtonEnabled       = bp_buy_but_clr;
      btColorButtonDisabled      = bp_buy_but_clr;
      btColorTextEnabled         = bp_buy_text_clr;
      btColorTextDisabled        = bp_buy_text_clr;
      
      TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(btName)+" "+
               TM.ToString("created | ")+
               ToString()
               );
   }
   
   ~ButtonBuy(){
      ObjectDelete(btName);
      TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(btName)+" "+
               TM.ToString("deleted | ")+
               ToString()
               );
   }
   
   string GetTextEnabled(){
      string   val      = "Disabled";
      
      return   val;
   }
   
   string GetTextDisabled(){
      string   val      = "BUY";

      return   val;
   }
   
   bool  GetState(){
      return   TM.GetMarketTrades() > 0;
   }
   
   void CreateButton(){
      ButtonCreates();
   }
   
   void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam){
      if (sparam == btName){
         TM.Log(  
                  HEAD_TO_STRING+
                  TM.ToString(btName)+","+
                  TM.ToString(sparam)+" | "+
                  TM.ToString(ToString())
                  );
          
         int   trades   = TM.GetMarketTrades();       
         
         if (!trades){
            //TM.SendOrder(OP_BUY,MAIN);
            //sFilterCloseAboveBelowLevelSignal.UpdateLevel();
            glCalculateTimeForCloseXBarsSignal.UpdateLevel();
         }   
            
         button_handler.OnTick();
      }         
   }
};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class ButtonSell  : public ButtonBase{
   public:

   ButtonSell(bool inTheSameRow) : ButtonBase(){
      btName                     = prefix+"ButtonSell_"+TM.ToString(ArraySize(button_handler.buttons));
      btX                        = int(butBaseX + butBaseXsize / 2 - butBaseShift / 2);
      btY                        = button_handler.GetLastRealY() + butBaseShift;
      btTheSameRow               = inTheSameRow;
      
      btXsize                    = (int)(butBaseXsize / 2 - butBaseShift / 2);
      btYsize                    = butBaseYsize;
      
      btTextFontSize             = (int)((btYsize / 3.5) * bp_text_scale);
      
      btColorButtonEnabled       = bp_sell_but_clr;
      btColorButtonDisabled      = bp_sell_but_clr;
      btColorTextEnabled         = bp_sell_text_clr;
      btColorTextDisabled        = bp_sell_text_clr;
      
      TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(btName)+" "+
               TM.ToString("created | ")+
               ToString()
               );
   }
   
   ~ButtonSell(){
      ObjectDelete(btName);
      TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(btName)+" "+
               TM.ToString("deleted | ")+
               ToString()
               );
   }
   
   string GetTextEnabled(){
      string   val      = "Disabled";

      return   val;
   }
   
   string GetTextDisabled(){
      string   val      = "SELL";

      return   val;
   }
   
   bool  GetState(){
      return   TM.GetMarketTrades() > 0;
   }
   
   void CreateButton(){
      ButtonCreates();
   }
   
   void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam){
      if (sparam == btName){
         TM.Log(  
                  HEAD_TO_STRING+
                  TM.ToString(btName)+","+
                  TM.ToString(sparam)+" | "+
                  TM.ToString(ToString())
                  );
         
         int   trades   = TM.GetMarketTrades();       
         
         if (!trades){
            //TM.SendOrder(OP_SELL,MAIN);
            //sFilterCloseAboveBelowLevelSignal.UpdateLevel();
            glCalculateTimeForCloseXBarsSignal.UpdateLevel();
         }   
            
         button_handler.OnTick();
      }         
   }
};


