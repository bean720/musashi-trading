#property version   "1.00"
#property strict


#include "MQH\Enums.mqh"
#include "MQH\Structs.mqh"
#include "Signals\SignalBase.mqh"
#include "Signals\Signals.mqh"
#include "Signals\SignalHandler.mqh"
#include "MQH\TradingManager.mqh"

#resource "Resources\\Exit TF Action & Exhaustion Indicator v10.2.3.ex4"
const string   TF_Action_Exhaustion_Indicator_PATH =    "::Resources\\Exit TF Action & Exhaustion Indicator v10.2.3.ex4";

//---Inputs

      bool                 enable_logging                = true;
input string               tfaei_path_exit               = "MO Indicator 9 Test";      //Path Entry


//---Global
      bool                 glIsMasterAcc                 = AccountNumber() == 8687850;
      int                  signal_bar                    = 1;
      bool                 enable_debug                  = false;

      double               take_profit                   = 0;
      double               stop_loss                     = 0;

      MM_TYPE              mm                            = fixed;
      double               lot_size                      = 0.1;
      double               risk_percent                  = 1.0;
      double               lot_for_lot_per_money         = 1.0;
      double               money_for_lot_per_money       = 10000.0;

      bool                 breakeven_enable              = true;
      double               breakeven_start               = 10.0;
      double               breakeven_profit              = 2.0;

      bool                 trailing_enable               = false;
      double               trailing_start                = 20.0;
      double               trailing_stop                 = 10.0;
      double               trailing_step                 = 2.0;

      bool                 enable_alert                  = false;
      bool                 enable_email                  = false;
      bool                 enable_mobile                 = false;

int OnInit() {
   
   TM                   = new TradingManager();
   
   glSignalHandler      = new SignalHandler("SH_Main");
   glSignalHandler.AddSignal(new ExitIndicatorArrowSignal());
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   delete   glSignalHandler;

   delete   TM;
}

void OnTick(){
   TM.OnTick();
//---
   MainShActions();
//---
}

void MainShActions(){
   SignalHandler *sh = glSignalHandler;
   
   if (TM.new_bar){
      sh.OnTick();
      SignalType open_signal  = sh.GetOpenSignal();
      SignalType close_signal = sh.GetCloseSignal();
      
      if (TM.new_bar){
         sh.LogOpenSignal();
         sh.LogCloseSignal();
      }
      
      if (close_signal != NO){
         int   close_type  = (close_signal == BOTH) ? -1 : (close_signal == BUY) ? OP_SELL : OP_BUY;
         int   count       = TM.CloseAllTrades_GlobalVariable(close_type);
         
         if (count > 0){
            if (!TM.new_bar){
               sh.LogOpenSignal();
               sh.LogCloseSignal();
            }
         }
      }
   }
}

string GetProjectName(){
   return __FILE__;
}

