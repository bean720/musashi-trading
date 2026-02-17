
#property strict

#include "../MQH\Enums.mqh"
#include "../Signals\SignalBase.mqh"
#include "../MQH\TradingManager.mqh"
#include "../MQH\Structs.mqh"
#include "Trade.mqh"
#include "TableParameters.mqh"


class TradeVirtual : public Trade{
   public:
   
   string ToString(){
      string   val   = StringFormat(" | trV#%s, tt:%s / iF?:%s, iIbS?:%s, iS?:%s, iRtS?:%s, iE?:%s, iBE?:%s / ep:%s, bp:%s, lf:%s / bpt:%s / SPT:%s, SVT:%s, STP:%s | ",
                              trName,
                              EnumToString(trType),
                              
                              TM.ToString(trIsFinished),
                              TM.ToString(trIsInvalidated),
                              TM.ToString(trIsSelected),
                              TM.ToString(trIsReadyToSendOrder),
                              TM.ToString(trIsExpire),
                              TM.ToString(trIsBreakEvenTriggered),
                              
                              TM.ToString(trEntryPrice),
                              TM.ToString(trBasePrice),
                              TM.ToString(trLotFirst),
                              
                              TM.ToString(trBasePriceTime),
                              
                              TM.ToString(trStructPotentialTrade.ToString()),
                              TM.ToString(trStructVirtualInitialTrade.ToString()),
                              TM.ToString(trStructTableParameters.ToString())
                              );
      return   val;                        
   }
   
   
   TradeVirtual(){
      trEntryTime = TimeCurrent();
      trName      = 
                  "TRTV_"+
                  TM.ToString(trEntryTime)
                  ;

      TM.Log(  
               HEAD_TO_STRING+
               TM.ToString(trName)+" "+
               TM.ToString("created.")+" | "+
               ToString()
               );
               
   }
   
   color GetFirstTabColor(){
      color clr         = clrNONE;
      
            clr         = glTradeClrVirtual;
            
      return   clr;
   }
   
//--- Text
   string GetTextExitTp(){
      //EnumTPadExitType_TP  exType   = glTradePad.GetTPadExitType_TP();//trStructTableParameters.trExitType_TP;
      ENUM_TIMEFRAMES      exTf     = glTradePad.GetTimeFrameExitType_TP();//trStructTableParameters.trExitTimeframe_TP;
      int                  per      = glTradePad.GetExitPeriod_TP();//trStructTableParameters.trExitPeriod_TP;
      bool                 isTable  = true;//trStructTableParameters.trIsTableTrade;
      
      bool  isRR           = glTradePad.GetTPadExitType_TP_RR();
      bool  isPrice        = glTradePad.GetTPadExitType_TP_Price();
      bool  isEma          = glTradePad.GetTPadExitType_TP_Ema();
      bool  isIndi         = glTradePad.GetTPadExitType_TP_Indicator();
      
      string               val      = "";
      
      if (isRR){
         val += "+:";
      }
      else{
         val += "-:";
      }
      
      if (isPrice){
         val += "+:";
      }
      else{
         val += "-:";
      }
      
      if (isEma){
         val   += 
                     TM.ToString(exTf)+""+
                     /*"MA"+*/"("+
                     TM.ToString(per)+"):"
                     ;
      }
      else{
         val += "-:";
      }      
      
      if (isIndi){
         val += "+";
      }
      else{
         val += "-";
      }      
      
      /*
      switch(exType){
         case TPadExitType_TP_Price:
            val   = "TP Price";
            break;
         case TPadExitType_TP_Pips:
            val   = "TP Pips";
            break;
         case TPadExitType_TP_Disabled:
            val   = isTable ? "Disabled" : "Signals"; 
            break;
         case TPadExitType_TP_Ema:
            val   = 
                     TM.ToString(exTf)+" "+
                     "EMA"+"("+
                     TM.ToString(per)+"}"
                     ;
            break;
      }
      */
      return   val;
   }
   
   string GetTextExitSl(){
      //EnumTPadExitType_SL  exType   = glTradePad.GetTPadExitType_SL();//trStructTableParameters.trExitType_SL;
      ENUM_TIMEFRAMES      exTf     = glTradePad.GetTimeFrameExitType_SL();//trStructTableParameters.trExitTimeframe_SL;
      int                  per      = glTradePad.GetExitPeriod_SL_Ema();//trStructTableParameters.trExitPeriod_SL;
      bool                 isTable  = true;//trStructTableParameters.trIsTableTrade;
      
      bool  isSlPips    = glTradePad.GetTPadExitType_SL_Pips();
      bool  isSlPrice   = glTradePad.GetTPadExitType_SL_Price();
      bool  isSlEma     = glTradePad.GetTPadExitType_SL_Ema();
      
      
      
      string               val      = "";
      
      if (isSlPips){
         val += "+:";
      }
      else{
         val += "-:";
      }
      
      if (isSlPrice){
         val += "+:";
      }
      else{
         val += "-:";
      }
      if (isSlEma){
         val  += 
                     TM.ToString(exTf)+""+
                     /*"MA"+*/"("+
                     TM.ToString(per)+"}"
                     ;
      }
      else{
         val += "-";
      }
      
      return   val;
   }
   
   string GetText_RTR(){
      string   trailingReward = "TX" + GetText_RTR_TrailingReward();
      string   initialRatio   = GetText_RTR_InitialRatio();
      
      string   val   = 
                        trailingReward + " : " +
                        initialRatio
                        ;
      
      return   val;                  
   }
   
   string GetText_RTRAmount(){
      string   initialRisk    = "$"+GetText_RTRValue_InitialRisk();
      string   trailingReward = "$TX" + GetText_RTRValue_TrailingReward_String();
      string   initialReward  = "$"+GetText_RTRValue_InitialReward();
      
      string   val   = 
                        initialRisk + " : " +
                        trailingReward + " : " +
                        initialReward
                        ;
      
      return   val;                  
   }
   
   void Virtual_PrepairTypePriceSlTpDistLot(ENUM_ORDER_TYPE &orderType, double &price, double &slDist, double &tpDist, double &lot){
               orderType   = glTradePad.GetTPadOrderType();//trStructTableParameters.trOrderType;
      
      double   addPips     = orderType < 2 ? 0 : pending_entry_add_pips;
      int      coef        = 
                              orderType < 2 ? 
                                 orderType % 2 == 0 ? 1 : -1 :
                                 orderType == OP_BUYSTOP || orderType == OP_SELLLIMIT ? 1 : -1
                                 ;
      //double   price       = trStructPotentialTrade.trPriceEntry + coef * addPips * TM.Pip();
               price       = glTradePad.tpStructPotentialTrade.trPriceEntry + coef * addPips * TM.Pip();
      SignalType  signal   = orderType % 2 == 0 ? BUY : SELL;         
      double   sl          = glTradePad.tpStructPotentialTrade.GetPriceStopLoss_Nearest_ByType(signal, HEAD_TO_STRING);
      double   tp          = glTradePad.tpStructPotentialTrade.GetPriceTakeProfit_Nearest_ByType(signal, HEAD_TO_STRING);//trPriceTakeProfit;
      
      //double   potenSlDist = (orderType % 2 == 0 ? sl - price  : price - sl);
      
      double   sl_pips     = MathAbs(price - sl) / TM.Pip();
               lot         = Lot(sl_pips);
      
               tpDist      = tp <= 0   ? 0   : MathAbs(price - tp); 
               slDist      = sl <= 0   ? 0   : MathAbs(price - sl); 
   }
   
   
   string GetText_RTR_InitialRatio(){
      string   val   = "-";
      
      ENUM_ORDER_TYPE   orderType   = (ENUM_ORDER_TYPE)-1;
      double            price       = 0;
      double            slDist      = 0;
      double            tpDist      = 0;
      double            lot         = 0;
      
      Virtual_PrepairTypePriceSlTpDistLot(orderType,price,slDist,tpDist,lot);
      
      double   initRR      = tpDist <= 0 || slDist <= 0 ? 0 : tpDist / slDist;
      
               val         = TM.ToString(initRR,1);
               
      return   val;
   }
   
   string GetText_RTRValue_InitialRisk(){
      string   val   = "-";
      
      ENUM_ORDER_TYPE   orderType   = (ENUM_ORDER_TYPE)-1;
      double            price       = 0;
      double            slDist      = 0;
      double            tpDist      = 0;
      double            lot         = 0;
      
      Virtual_PrepairTypePriceSlTpDistLot(orderType,price,slDist,tpDist,lot);
      
      double   slDistPips  = slDist / TM.Pip();
      double   riskAmount  = TM.GetMoneyAmountByDistancePipsAndLot(slDistPips, lot);
               
               val         = TM.ToString(-riskAmount,2);
               
      return   val;
   }
   
   string GetText_RTRValue_InitialReward(){
      string   val   = "-";

      ENUM_ORDER_TYPE   orderType   = (ENUM_ORDER_TYPE)-1;
      double            price       = 0;
      double            slDist      = 0;
      double            tpDist      = 0;
      double            lot         = 0;
      
      Virtual_PrepairTypePriceSlTpDistLot(orderType,price,slDist,tpDist,lot);
      
      double   tpDistPips  = tpDist / TM.Pip();
      double   rewAmount   = TM.GetMoneyAmountByDistancePipsAndLot(tpDistPips, lot);
      
               val         = TM.ToString(rewAmount,2);
               
      return   val;
   }
   
   //TODO
   string GetText_RTR_TrailingReward(){
      string   val   = "-";
      
               
      return   val;
   }
   
   //TODO
   double GetText_RTRValue_TrailingReward_Double(){
      double   val   = 0;
               
      return   val;
   }
   
   //TODO
   string GetText_RTRValue_TrailingReward_String(){
      string   val   = "-";
               
      return   val;
   }
   
   string GetOrderText(){
   
      ENUM_ORDER_TYPE   orderType   = (ENUM_ORDER_TYPE)-1;
      double            price       = 0;
      double            slDist      = 0;
      double            tpDist      = 0;
      double            lot         = 0;
      
      Virtual_PrepairTypePriceSlTpDistLot(orderType,price,slDist,tpDist,lot);

      string   msg   = EnumToString(orderType);
      StringReplace(msg,"ORDER_TYPE_","");
      return   "Virtual: "+TM.ToString(msg);
   }
   
   double GetRiskPercent(){
      double   val         = glTradePad.GetRiskPercent();// trStructTableParameters.trHeadRiskPercent;
      if (TM.new_bars[0])
         TM.Log(
                  HEAD_TO_STRING+
                  TM.ToString(trName)+", "+
                  TM.ToString(val)+", "+
                  ToString()
                  );
      
      return   val;
   }
   
   double Lot(double sl_pips){
      double   lot         = 0;
      double   riskPercent = GetRiskPercent();
      
      double   perPip   = per_pip_value > 0 ? per_pip_value : SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE) * TM.FractFactor();
      
      double risk_amount   = AccountBalance() * (riskPercent / 100);
      double dnVal         = (perPip * sl_pips);
      lot = dnVal == 0 ? 0 : risk_amount / dnVal;
      
      double min_lot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
      double max_lot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
      int lot_digits = (int)(MathLog(SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP)) / MathLog(0.1));
      lot = NormalizeDouble(MathMin(MathMax(min_lot, lot), max_lot), lot_digits);
      
      if (TM.new_bars[0])
         TM.Log(
               HEAD_TO_STRING+
               TM.ToString(trName)+", "+
               TM.ToString(lot)+", "+
               TM.ToString(riskPercent)+", "+
               TM.ToString(perPip)+", "+
               TM.ToString(per_pip_value)+", "+
               TM.ToString(dnVal)+", "+
               ToString()
               );
      
      return lot;
   }
   
   void OnChartEvent(const int id,        
                     const long& lparam,   
                     const double& dparam,  
                     const string& sparam  
                     ){
      //trStructPotentialTrade.OnChartEvent(id,lparam,dparam,sparam);                  
   }                  
   
};
