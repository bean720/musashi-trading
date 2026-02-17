
#include "../MQH\Enums.mqh"
#include "../Signals\SignalBase.mqh"
#include "../MQH\TradingManager.mqh"
#include "../MQH\Structs.mqh"


class CTradeGroup{
   public:
   string      trName;
   
   int         trIndex;
   
   bool        trIsFinished;
   bool        trIsBreakEvenTriggered;
   
   SignalType  trType;
   
   double      trLotSize;
   double      trInit_StopLossDistPips;
   double      trInitRisk_Value;
   
   int         trTickets[];
   
   datetime    trEntryTime;
   
   void LoadString(string str){
      LOG(
               TM.ToString(str)
               );
   
      string support[];
      string   sep_lvl  = FILE_SEP_LEVEL_4;
      string   sep_or   = FILE_SEP_LEVEL_5;
      
      TM.ParseStringToArray(str,support,sep_lvl);
      
      int   i  = 0;
      
      trName         = (support[i++]);
      
      trIndex        = int(support[i++]);
      trIsFinished   = int(support[i++]);
      trIsBreakEvenTriggered  = int(support[i++]);
      trType         = SignalType(int(support[i++]));
      trEntryTime    = int(support[i++]);
      
      trLotSize               = StringToDouble(support[i++]);
      trInit_StopLossDistPips = StringToDouble(support[i++]);
      trInitRisk_Value        = StringToDouble(support[i++]);

      TM.ParseStringToArray(support[i++],trTickets,sep_or);

      LOG(
               TM.ToString(trName)+", "+
               "CTradeGroup restored. ->"+
               str
               );
   }   
   
   
   string SaveString(){
      string   sep_lvl  = FILE_SEP_LEVEL_4;
      string   sep_or   = FILE_SEP_LEVEL_5;
   
      string val =  
                           trName+sep_lvl+
                           
                           TM.ToString((int)trIndex)+sep_lvl+
                           TM.ToString((int)trIsFinished)+sep_lvl+
                           TM.ToString((int)trIsBreakEvenTriggered)+sep_lvl+
                           TM.ToString((int)trType)+sep_lvl+
                           TM.ToString((int)trEntryTime)+sep_lvl+
                           
                           TM.ToString(trLotSize)+sep_lvl+
                           TM.ToString(trInit_StopLossDistPips)+sep_lvl+
                           TM.ToString(trInitRisk_Value)+sep_lvl+
                           
                           TM.ToStringArray(trTickets,sep_or)
                           ;
                           
      LOG(
               TM.ToString(trName)+", "+
               "Try to save trade. -> "+ 
               val+" | "+
               ToString()
               );
               
      return val;
   }
   
   
   
   
   
   CTradeGroup(int index, SignalType signal, string reason){
      trIndex     = index;
      trType      = signal;
      trName      = "TRG_"+TM.ToString(trIndex)+"_"+EnumToString(trType);
      trEntryTime = TimeCurrent();
      
      LOG(
               TM.ToString(reason)+" "+
               TM.ToString(trName)+" "+
               TM.ToString("created.")+" | "+
               ToString()
               );
   }
   
   CTradeGroup(string msg){
   
      trName = "TRG_";
      
      LoadString(msg);
      
      LOG(
               TM.ToString(trName)+" "+
               TM.ToString("created.")+" | "+
               ToString()
               );
   }
   
   
   ~CTradeGroup(){
      LOG(
               TM.ToString(trName)+" "+
               TM.ToString("deleted.")+" | "+
               ToString()
               );
               
   }
   
   string ToString(){
      string   val   = StringFormat(" | TRG => tr#%s, iF?:%s, lot:%s, t-s:%s | ",
                              trName,
                              TM.ToString(trIsFinished),
                              TM.ToString(trLotSize),
                              TM.ToString(TM.ToStringArray(trTickets,":"))
                              );
      return   val;                        
   }
   
   
   void OnTick(){
      if (trIsFinished) return;
      
      CheckIsFinished();
   }
   
   void CheckIsFinished(){
      //if (number_of_trades > 1) return;
      bool  isFinished  = true;
      
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         or.Initialize(ticket);
         
         if (or.trCloseTime == 0){
            isFinished  = false;
            
            break;
         }
      }
      
      int      newBarIndexEntry  = 0;
      bool     newBarEntry       = TM.new_bars[newBarIndexEntry];
      
      if (newBarEntry || isFinished){
         LOG(
                     TM.ToString(isFinished)+", "+
                     ToString()
                     );
      }
      
      SetIsFinished(isFinished, HEAD_TO_STRING);
   }
   
   void SetIsFinished(bool state, string reason){
      if (trIsFinished != state){
         trIsFinished   = state;
         
         LOG(
                  TM.ToString(reason)+", "+
                  TM.ToString(trIsFinished)+", "+
                  ToString()
                  );
      
      }
   }
   
   double GetLotsOnChart(){
      double   result   = 0;
      
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         or.Initialize(ticket);
         
         if (or.trCloseTime > 0) continue;
         
         result   += or.trLot;
      }   
      
      return   result;
   }
   
   void ClosePartially(double percent, string reason){
      int      result         = 0;
      double   lot            = GetLotsOnChart();
      double   lotForClose    = lot / 100.0 * percent;
      double   lotForCloseR   = TM.LotFilter(lotForClose);
      double   remain         = lotForCloseR;
      
      LOG(
         TM.ToString(reason)+", "+
         TM.ToString(lotForCloseR)+", "+
         TM.ToString(lotForClose)+", "+
         TM.ToString(lot)+", "+
         TM.ToString(percent)+", "+
         ToString()
         );
   
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         or.Initialize(ticket);
         
         if (or.trCloseTime > 0) continue;
         
         double   lotOr = or.trLot;
         
                  remain   = TM.LotFilter(remain);
         
         double   lotClose = MathMin(lotOr, remain);
         remain   -= lotClose;
         
         LOG(
               TM.ToString(lotClose)+", "+
               TM.ToString(remain)+", "+
               TM.ToString(lotOr)+", "+
               ToString()
               );
         
         or.CloseMarketTrade(
                              HEAD_TO_STRING,
                              lotClose
                              );
                              
         int   newTicket   = or.GetTicketPartialClosedOrder(HEAD_TO_STRING);  
         
         if (newTicket > 0){
            trTickets[i]   = newTicket;
            
            LOG(
                  TM.ToString(ticket)+" => "+
                  TM.ToString(newTicket)+", "+
                  ToString()
                  );
         }
         result++;
         
         if (remain <= 0) break;
      }
   }
   
   int DestroyGroup(string reason){
      int   result   = 0;
      
      LOG(
         TM.ToString(reason)+", "+
         ToString()
         );
      
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         or.Initialize(ticket);
         if (or.DestroyTrade(reason+"::"+HEAD_TO_STRING))
            result++;
      }
      
      return result;
   }
   
   void ModifyTakeProfits(double newTp, string reason){
      LOG(
         TM.ToString(reason)+", "+
         TM.ToString(newTp)+", "+
         ToString()
         );
         
      int   result   = 0;
         
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         or.Initialize(ticket);
         or.ModifyTakeProfit(newTp,HEAD_TO_STRING);
         result++;
      }
         
   }
   
   int ModifyStopLosses(double newSl, string reason){
      LOG(
         TM.ToString(reason)+", "+
         TM.ToString(newSl)+", "+
         ToString()
         );
         
      int   result   = 0;
         
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         or.Initialize(ticket);
         if (or.ModifyStopLoss(newSl,HEAD_TO_STRING))
            result++;
      }
      
      return result;   
   }
   
   void DeleteAllPendings(string reason){
      int   result   = 0;
      
      LOG(
         TM.ToString(reason)+", "+
         ToString()
         );
      
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         or.Initialize(ticket);
         or.DeletePendingOrder(reason+"::"+HEAD_TO_STRING);
         result++;
      }
   }
   
   bool IsMarket(){
      bool  result = false;
      
      for (int i = 0; i < ArraySize(trTickets); i++){
         int   ticket   = trTickets[i];
         StructOrder or;
         if (or.trType < 2){
            result = true;
            break;
         }
      }
      
      return   result;
   }
   
   void OnClickButton_Modify(
      StructTableParameters& trStructTableParameters, 
      StructPotentialTrade& trStructPotentialTrade, 
      string reason)
   {
   
      bool  isMarket = IsMarket();
   
      LOG(
            TM.ToString(reason)+", "+
            TM.ToString(isMarket)+", "+
            ToString()
            );
   
      if (!isMarket){
         DeleteAllPendings(reason+"::"+HEAD_TO_STRING);
         TryToSendOrder(trStructTableParameters, trStructPotentialTrade, reason+"::"+HEAD_TO_STRING);
      }
   
   }
   
   int TryToSendOrder(
      StructTableParameters& trStructTableParameters, 
      StructPotentialTrade& trStructPotentialTrade, 
      string reason)
   {
      int      ticket   = 0;
      string   msg      = "MSG: ";
      
      
      if (trStructTableParameters.trOrderType < 2){
         int      open_type   = (trType == BUY) ? OP_BUY : OP_SELL;
         //double   stopLoss    = trStructPotentialTrade.trPriceStopLoss;
         //double   takeProfit  = trStructPotentialTrade.trPriceTakeProfit;
                  ticket      = SendMarketOrder(trStructTableParameters, trStructPotentialTrade, open_type, PANEL);
         
         if (ArraySize(trTickets) > 0){
            ticket   = GetFirstTicket();
         }   
      }
      else {
         int      open_type   = trStructTableParameters.trOrderType;
         int      coef        = open_type == OP_BUYSTOP || open_type == OP_SELLLIMIT ? 1 : -1;
         
         double   entryPrice  = trStructPotentialTrade.trPriceEntry + coef * pending_entry_add_pips * TM.Pip();
         
                  msg        +=
                                TM.ToString(__LINE__)+", "+
                                TM.ToString(entryPrice)
                                ;
         
                  ticket      = SendPendingOrder(trStructTableParameters,trStructPotentialTrade, open_type, entryPrice, PANEL);
                  
         if (ArraySize(trTickets) > 0){
            ticket   = GetFirstTicket();
         }   
      }   
      
      LOG(
            TM.ToString(reason)+", "+
            TM.ToString(trName)+", "+
            EnumToString(trStructTableParameters.trOrderType)+", "+
            TM.ToString(msg)+", "+
            ToString()
            );   
      return   ticket;
   }   
   
   int SendMarketOrder(
      StructTableParameters& trStructTableParameters, 
      StructPotentialTrade& trStructPotentialTrade, 
      int order_type, 
      string com)
   {
   
      int maxRetries = 10;
      int retryCount = 0;   
      
      int      magicN   = magic_number_panel;//trStructTableParameters.trEaFiltersEnable ? magic_number : magic_number_panel;
      LOG(
            TM.ToString(trName)+", "+
            TM.ToStringOrderType(order_type)+", "+
            TM.ToString(magicN)+", "+
            TM.ToString(com)+", "+
            ToString()
            );
            
      LOG(
            TM.ToString(trName)+", "+
            trStructTableParameters.ToString()+", "+
            ToString()
            );
            
      LOG(
            TM.ToString(trName)+", "+
            trStructPotentialTrade.ToString()+", "+
            ToString()
            );
            
      int      coef     = order_type == OP_BUY ? 1 : -1;
      RefreshRates();
      double   price    = (order_type == OP_BUY) ? Ask : Bid;
      
      //double   tp       = trStructPotentialTrade.trPriceTakeProfit;
      //double   sl       = trStructPotentialTrade.trPriceStopLoss;
      
      SignalType  signal   = order_type % 2 == 0 ? BUY : SELL;         
      double   sl    = trStructPotentialTrade.GetPriceStopLoss_Nearest_ByType(signal, HEAD_TO_STRING);
      double   tp    = trStructPotentialTrade.GetPriceTakeProfit_Nearest_ByType(signal, HEAD_TO_STRING);//trPriceTakeProfit;
      
      double   sl_pips  = sl <= 0 ? 0 : MathAbs(price - sl) / TM.Pip();
      
      UpdateInit_StopLossDistPips(sl_pips, HEAD_TO_STRING);
      
      double   lot      = Lot(trStructTableParameters, sl_pips, HEAD_TO_STRING, true);
      
      UpdateLotSize(lot, HEAD_TO_STRING);
      
      color    clr      = (order_type == OP_BUY) ? clrGreen : clrRed;
      
      double   tpDist      = tp <= 0   ? 0   : MathAbs(price - tp); 
      double   slDist      = sl <= 0   ? 0   : MathAbs(price - sl); 
      double   initRR      = tpDist <= 0 || slDist <= 0 ? 0 : tpDist / slDist;
      
      LOG(
            TM.ToString(trName)+", "+
            TM.ToString(initRR)+", "+
            TM.ToString(tpDist)+", "+
            TM.ToString(slDist)+" | "+
            TM.ToString(price)+", "+
            TM.ToString(tp)+", "+
            TM.ToString(sl)+", "+
            ToString()
            );
      
      //UpdateInitRr(initRR,HEAD_TO_STRING);
      
      double   tpDistPips  = tpDist / TM.Pip();
      double   slDistPips  = slDist / TM.Pip();
      
      UpdateInit_StopLossDistPips(slDistPips, HEAD_TO_STRING);
      
      double   riskAmount  = TM.GetMoneyAmountByDistancePipsAndLot(slDistPips, lot);
      UpdateInitRisk_Value(riskAmount,HEAD_TO_STRING);
      
      double   rewAmount   = TM.GetMoneyAmountByDistancePipsAndLot(tpDistPips, lot);
      //UpdateInitReward_Value(rewAmount,HEAD_TO_STRING);
      
      double   maxClipSize    = clip_size;
      double   remain         = lot;
      int      ticket         = 0;
      
      bool     isIndi         = trStructTableParameters.trExitType_TP_Indicator;
      
      while (remain > 0.001){
         retryCount = 0;
         
         while (retryCount < maxRetries) {      
            RefreshRates();
                     price    = (order_type == OP_BUY) ? Ask : Bid;
            double   nextLot  = maxClipSize <= 0 ? remain : MathMin(remain, maxClipSize);
            nextLot  = TM.LotFilter(nextLot);
            
            LOG(
                  TM.ToString(trName)+", "+
                  TM.ToString(nextLot)+", "+
                  TM.ToString(remain)+", "+
                  TM.ToString(maxClipSize)+" | "+
                  TM.ToString(price)+" | "+
                  ToString()
                  );
            
            ticket   = OrderSend(
                                          Symbol(),
                                          order_type,
                                          nextLot,
                                          NormalizeDouble(price,_Digits),
                                          100,
                                          NormalizeDouble(sl,_Digits),
                                          NormalizeDouble(tp,_Digits),
                                          com,
                                          magicN,
                                          0,
                                          clr
                                          );
           
                    
           
           
            if (ticket < 0){
               int errorCode = GetLastError();
               LOG(
                     TM.ToString(trName)+", "+
                     TM.ToString(retryCount)+": "+
                     "Error during the order opening. "+
                     TM.ToString(errorCode)+", "+
                     TM.ToString(price)+", "+
                     TM.ToString(tp)+", "+
                     TM.ToString(sl)+", "+
                     TM.ToString(Bid)+", "+
                     TM.ToString(Ask)+", "+
                     TM.ToString(MarketInfo(Symbol(),MODE_STOPLEVEL))
                   );
                   
               if (errorCode == 129) {
                  retryCount++;
                  Sleep(100); 
                  continue;
               } 
               else {
                  Alert("Error during the order opening: "+TM.ToString(errorCode));
                  return ticket; 
               }
            }
            else {
               remain   -= nextLot;
               AddNewTicket(ticket, HEAD_TO_STRING);
               
               if (isIndi){
                  TM.CreateGlobalVal(ticket);
               }
               
               LOG(
                     TM.ToString(trName)+", "+
                     "An order #"+
                     TM.ToString(ticket)+
                     " was opened successfully."+", "+
                     ToString()
                     );
               break;      
            } 
         }     
      }         
      return   ticket;
   }
      
   int SendPendingOrder(
      StructTableParameters& trStructTableParameters, 
      StructPotentialTrade& trStructPotentialTrade, 
      int order_type, double price, string com)
   {
      RefreshRates();
      int      magicN   = magic_number_panel;//trStructTableParameters.trEaFiltersEnable ? magic_number : magic_number_panel;
      
      TM.Log(
            HEAD_TO_STRING+
            TM.ToString(trName)+", "+
            "Sending Pending order: "+
            TM.ToStringOrderType(order_type)+", "+
            TM.ToString(magicN)+", "+
            TM.ToString(price)+", "+
            TM.ToString(com)
            );
      int      coef     = order_type % 2 == 0   ? 1 : -1;
   
      //double   tp       = trStructPotentialTrade.trPriceTakeProfit;
      //double   sl       = trStructPotentialTrade.trPriceStopLoss;
      
      SignalType  signal   = order_type % 2 == 0 ? BUY : SELL;         
      double   sl    = trStructPotentialTrade.GetPriceStopLoss_Nearest_ByType(signal, HEAD_TO_STRING);
      double   tp    = trStructPotentialTrade.GetPriceTakeProfit_Nearest_ByType(signal, HEAD_TO_STRING);//trPriceTakeProfit;
      
      double   sl_pips  = MathAbs(price - sl) / TM.Pip();
      double   lot      = Lot(trStructTableParameters,sl_pips,HEAD_TO_STRING,true);
      UpdateLotSize(lot, HEAD_TO_STRING);
      
                                    
      double   tpDist      = tp <= 0   ? 0   : MathAbs(price - tp); 
      double   slDist      = sl <= 0   ? 0   : MathAbs(price - sl); 
      double   initRR      = tpDist <= 0 || slDist <= 0 ? 0 : tpDist / slDist;
      
      LOG(
            TM.ToString(trName)+", "+
            TM.ToString(initRR)+", "+
            TM.ToString(tpDist)+", "+
            TM.ToString(slDist)+" | "+
            TM.ToString(price)+", "+
            TM.ToString(tp)+", "+
            TM.ToString(sl)+", "+
            ToString()
            );
      
      //UpdateInitRr(initRR,HEAD_TO_STRING);
      
      double   tpDistPips  = tpDist / TM.Pip();
      double   slDistPips  = slDist / TM.Pip();
      
      UpdateInit_StopLossDistPips(slDistPips, HEAD_TO_STRING);
      
      double   riskAmount  = TM.GetMoneyAmountByDistancePipsAndLot(slDistPips, lot);
      UpdateInitRisk_Value(riskAmount,HEAD_TO_STRING);
      
      double   rewAmount   = TM.GetMoneyAmountByDistancePipsAndLot(tpDistPips, lot);
      //UpdateInitReward_Value(rewAmount,HEAD_TO_STRING);
                     
      color    clr      = order_type % 2 == 0   ? clrGreen : clrRed;
      
      double   maxClipSize    = clip_size;
      double   remain         = lot;
      int      ticket         = 0;
      
      bool     isIndi         = trStructTableParameters.trExitType_TP_Indicator;
      
      while (remain > 0){
         double   nextLot     = maxClipSize <= 0 ? remain : MathMin(remain, maxClipSize);
         nextLot  = TM.LotFilter(nextLot);
         remain   -= nextLot;
         
         LOG(
               TM.ToString(trName)+", "+
               TM.ToString(nextLot)+", "+
               TM.ToString(remain)+", "+
               TM.ToString(maxClipSize)+" | "+
               ToString()
               );
         
         ticket   = OrderSend(                                    
                                    Symbol(),
                                    order_type,
                                    lot,
                                    NormalizeDouble(price,_Digits),
                                    100,
                                    NormalizeDouble(sl,_Digits),
                                    NormalizeDouble(tp,_Digits),
                                    com,
                                    magicN,
                                    0,
                                    clr
                                    );
                                    
         if (ticket < 0){
            LOG(
                  TM.ToString(trName)+", "+
                  "Error during the order opening. "+
                  TM.ToString(GetLastError())+", "+
                  TM.ToString(price)+", "+
                  TM.ToString(tp)+", "+
                  TM.ToString(sl)+", "+
                  TM.ToString(Bid)+", "+
                  TM.ToString(Ask)+", "+
                  TM.ToString(MarketInfo(Symbol(),MODE_STOPLEVEL))
                );
            return   ticket;    
         }
         else {
            AddNewTicket(ticket, HEAD_TO_STRING);
            
            if (isIndi){
               TM.CreateGlobalVal(ticket);
            }
            
            LOG(
                  TM.ToString(trName)+", "+
                  "An order #"+
                  TM.ToString(ticket)+
                  " was opened successfully."+", "+
                  ToString()
                  );
         }  
      }          
      return   ticket;
   }   
   
   int DeleteGlobalVal(string reason){
      int   result   = 0;
      
      for (int i = 0; i < ArraySize(trTickets); i++){
         if (TM.DeleteGlobalVal(trTickets[i])){
            result++;
         }
      }
      
      if (result > 0){
         LOG(
            TM.ToString(reason)
            +", "+TM.ToString(result)
         );
      }
      
      return   result;
   }
   
   int CreateGlobalVal(string reason){
      int   result   = 0;
      
      for (int i = 0; i < ArraySize(trTickets); i++){
         if (TM.CreateGlobalVal(trTickets[i])){
            result++;
         }
      }
      
      if (result > 0){
         LOG(
            TM.ToString(reason)
            +", "+TM.ToString(result)
         );
      }
      
      return   result;
   }
   
   void AddNewTicket(int ticket, string reason){
      if (ticket <= 0 || !TM.IsInArray(ticket,trTickets)){
         TM.AddInArray(trTickets,ticket);
         
         LOG(
                  TM.ToString(reason)+", "+
                  TM.ToString(trName)+", "+
                  TM.ToString(ticket)+", "+
                  TM.ToStringArray(trTickets,":")+", "+
                  ToString()
                  );
      
      }
   }   
   
   void UpdateInit_StopLossDistPips(double val, string reason){
      if (trInit_StopLossDistPips != val){
         trInit_StopLossDistPips   = val;
         
         LOG(
                  TM.ToString(reason)+", "+
                  TM.ToString(trName)+", "+
                  TM.ToString(trInit_StopLossDistPips)+", "+
                  ToString()
                  );
      
      }
   }
   
   void UpdateLotSize(double val, string reason){
      if (trLotSize != val){
         trLotSize   = val;
         
         LOG(
                  TM.ToString(reason)+", "+
                  TM.ToString(trName)+", "+
                  TM.ToString(trLotSize)+", "+
                  ToString()
                  );
      
      }
   }
   
   
   void UpdateInitRisk_Value(double val, string reason){
      if (trInitRisk_Value != val){
         trInitRisk_Value   = val;
         
         LOG(
                  TM.ToString(trName)+", "+
                  TM.ToString(trInitRisk_Value)+", "+
                  TM.ToString(reason)+", "+
                  ToString()
                  );
      
      }
   }
   
   double Lot(StructTableParameters& trStructTableParameters, double sl_pips, string reason, bool isLog){
      int      newBarIndexEntry  = 0;
      bool     newBarEntry       = TM.new_bars[newBarIndexEntry];
   
      double   lot         = 0;
      double   riskPercent = GetRiskPercent(trStructTableParameters, isLog);
      
      double   perPip   = per_pip_value > 0 ? per_pip_value : SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE) * TM.FractFactor();
      
      double risk_amount   = AccountBalance() * (riskPercent / 100);
      double dnVal         = (perPip * sl_pips);
      lot = dnVal == 0 ? 0 : risk_amount / dnVal;
      
      double min_lot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
      double max_lot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
      int lot_digits = (int)(MathLog(SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP)) / MathLog(0.1));
      lot = NormalizeDouble(MathMin(MathMax(min_lot, lot), max_lot), lot_digits);
      
      if (isLog || newBarEntry)
         LOG(
               TM.ToString(reason)+", "+
               TM.ToString(trName)+", "+
               TM.ToString(lot)+", "+
               TM.ToString(riskPercent)+", "+
               TM.ToString(sl_pips)+", "+
               TM.ToString(perPip)+", "+
               TM.ToString(per_pip_value)+", "+
               TM.ToString(dnVal)+", "+
               ToString()
               );
      
      return lot;
   }   
   
   double GetRiskPercent(StructTableParameters& trStructTableParameters, bool isLog){
      int      newBarIndexEntry  = 0;
      bool     newBarEntry       = TM.new_bars[newBarIndexEntry];
   
      double   val         = trStructTableParameters.trHeadRiskPercent;
      
      if (isLog || newBarEntry)
         LOG(
               TM.ToString(trName)+", "+
               TM.ToString(val)+", "+
               ToString()
               );
      
      return   val;
   }
   
   
   bool ActionPendingOrderRecaluclateLotSizeByNewSl(
      StructTableParameters& trStructTableParameters, 
      StructPotentialTrade& trStructPotentialTrade, 
      string reason)
   {
      bool  result   = false;
      
      int   ticket   = GetLastTicket();
      StructOrder or;
      or.Initialize(ticket);
      
      if (ticket <= 0 || or.trType < 2){
         
         int      newBarIndexEntry  = 0;
         bool     newBarEntry       = TM.new_bars[newBarIndexEntry];
         
         if (newBarEntry)
            LOG(
                  TM.ToString(trName)+", "+
                  or.ToString()+", "+
                  ToString()
                  );
         
         return result;
      }
      
      double   orSlPrice   = or.trStopLoss;
      double   orTpPrice   = or.trTakeProfit;
      double   orOpenPrice = or.trOpenPrice;
      double   orLot       = or.trLot;
      double   orSlPips    = MathAbs(orOpenPrice - orSlPrice) / TM.Pip();
      double   realLot     = Lot(trStructTableParameters, orSlPips, HEAD_TO_STRING, false);
      
      result     = realLot != orLot;
      
      if (result){
         trStructPotentialTrade.UpdatePriceStopLoss(orSlPrice,HEAD_TO_STRING);
         trStructPotentialTrade.UpdatePriceTakeProfit(orTpPrice,HEAD_TO_STRING);
         trStructPotentialTrade.UpdatePriceOpenPrice(orOpenPrice,HEAD_TO_STRING);
         trStructPotentialTrade.UpdatePriceEntryPrice(orOpenPrice,HEAD_TO_STRING);
         
         DeleteAllPendings(HEAD_TO_STRING);
         TryToSendOrder(trStructTableParameters, trStructPotentialTrade, HEAD_TO_STRING);
      }
      
      return   result;
   }
   
   bool ActionExit_TP(
      StructTableParameters& trStructTableParameters, 
      StructPotentialTrade& trStructPotentialTrade, 
      double newTp,
      string reason)
   {
      bool  result   = false;
      bool  isMarket = IsMarket();
      int   ticket   = GetLastTicket();
      
      StructOrder or;
      or.Initialize(ticket);

      double   orTakeProfit   = or.trTakeProfit;
               orTakeProfit   = NormalizeDouble(orTakeProfit,_Digits);
               
      bool     isNew       = orTakeProfit != newTp;
      bool     isDir       = true;//or.trType % 2 == 0 ? newTp > orTakeProfit : newTp < orTakeProfit;
               result      = isNew && isDir;
      
      if (result){
         ModifyTakeProfits(newTp, reason+"::"+HEAD_TO_STRING);
      }
      
      return   result;
   }
   
   bool ActionExit_SL(
      StructTableParameters& trStructTableParameters, 
      StructPotentialTrade& trStructPotentialTrade, 
      double newSl,
      string reason)
   {
      bool  result   = false;
      bool  isMarket = IsMarket();
      int   ticket   = GetLastTicket();
      
      StructOrder or;
      or.Initialize(ticket);
      
      double   orStopLoss  = or.trStopLoss;
               orStopLoss  = NormalizeDouble(orStopLoss,_Digits);
               
      bool     isNew       = orStopLoss != newSl;
      bool     isDir       = or.trType % 2 == 0 ? newSl > orStopLoss : newSl < orStopLoss;
               result      = isNew && isDir;
      
      if (result){
         if (isMarket){
            ModifyStopLosses(newSl, reason+"::"+HEAD_TO_STRING);
         }
         else{
            double   lastOpenPrice  = or.trOpenPrice;
            trStructPotentialTrade.UpdatePriceOpenPrice(lastOpenPrice,HEAD_TO_STRING);
            
            DeleteAllPendings(reason+"::"+HEAD_TO_STRING);
            //or.DeletePendingOrder(HEAD_TO_STRING);
            TryToSendOrder(trStructTableParameters, trStructPotentialTrade, HEAD_TO_STRING);
         }
      }
      
      return   result;
   }
   
   
   int   GetLastTicket(){
      int   size   = ArraySize(trTickets);
      
      return   size > 0 ? trTickets[size - 1] : 0;
   }
   
   int   GetFirstTicket(){
      int   size  = ArraySize(trTickets);
      
      return   size > 0 ? trTickets[0] : 0;
   }
   
   
   int ActionBreakEven(StructTableParameters& trStructTableParameters, string reason){
      int   result   = 0;
      if (trIsBreakEvenTriggered) return result;
      
      bool     isEnable    = trStructTableParameters.trBreakEvenEnable;
      double   startRisk   = trStructTableParameters.trBreakEvenPips;
      double   profitPips  = breakeven_profit;
      
      int      newBarIndexEntry  = 0;
      bool     newBarEntry       = TM.new_bars[newBarIndexEntry];
      
      if (isEnable && startRisk > 0){
         int   ticket   = GetLastTicket();
         
         StructOrder or;
         or.Initialize(ticket);
         
         double   openPrice   = or.trOpenPrice;
         double   curSl       = or.trStopLoss;
         
         double   distPips    = trInit_StopLossDistPips;//MathAbs(openPrice - curSl) / TM.Pip();
         double   startPips   = distPips * startRisk;
         
         if (distPips <= 0){
            if (newBarEntry)
               LOG(
                  TM.ToString(distPips)+", "+
                  TM.ToString(openPrice)+", "+
                  TM.ToString(curSl)+", "+
                  TM.ToString(startPips)+", "+
                  TM.ToString(startRisk)+", "+
                  ToString()
                  );
            return result;      
         }
         
         int      coef        = or.trType % 2 == 0 ? 1 : -1;
         double   level       = openPrice + coef * startPips * TM.Pip();
         double   curPrice    = or.GetPriceCurrentClose();
         
         bool     isCrossed   = or.trType % 2 == 0 ? curPrice >= level : curPrice <= level;
         double   newSl       = openPrice + coef * profitPips * TM.Pip();
         bool     isNewSl     = curSl == 0 || (or.trType % 2 == 0 ? newSl > curSl : newSl < curSl);
         
         if (isCrossed){
            UpdateIsBreakEvenTriggered(true,HEAD_TO_STRING);
            result++;
            if (isNewSl){
               ModifyStopLosses(newSl, HEAD_TO_STRING);
            }
         }
         
         if (isCrossed || newBarEntry){
            LOG(
                     TM.ToString(isCrossed)+", "+
                     TM.ToString(trName)+", "+ 
                     
                     TM.ToString(SEP)+", "+ 
                     TM.ToString(startPips)+", "+ 
                     TM.ToString(distPips)+", "+ 
                     TM.ToString(startRisk)+", "+ 
                     
                     TM.ToString(SEP)+", "+ 
                     TM.ToString(openPrice)+", "+ 
                     TM.ToString(curSl)+", "+ 
                     
                     or.ToString()+", "+ 
                     ToString()
                     );
         
            LOG(
                     TM.ToString(isCrossed)+", "+
                     TM.ToString(trName)+", "+ 
                     
                     TM.ToString(SEP)+", "+ 
                     TM.ToString(ticket)+", "+ 
                     
                     TM.ToString(SEP)+", "+ 
                     TM.ToString(isNewSl)+", "+ 
                     TM.ToString(newSl)+", "+ 
                     TM.ToString(curSl)+", "+ 
                     
                     TM.ToString(SEP)+", "+ 
                     TM.ToString(isCrossed)+", "+ 
                     TM.ToString(curPrice)+", "+ 
                     TM.ToString(level)+", "+ 
                     
                     or.ToString()+", "+ 
                     ToString()
                     );
         }            
      }
      
      if (newBarEntry || trIsBreakEvenTriggered){
         LOG(
                  TM.ToString(reason)+", "+
                  TM.ToString(trIsBreakEvenTriggered)+", "+
                  TM.ToString(trName)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(isEnable)+", "+ 
                  TM.ToString(startRisk)+", "+ 
                  TM.ToString(profitPips)+", "+ 
                  
                  ToString()
                  );
      }
      
      return   result;
   }   
   
   int ActionTrailingStop(StructTableParameters& trStructTableParameters, string reason){
      int      result      = 0;
      bool     isEnable    = trStructTableParameters.trTslEnable;
      double   startRisk   = trStructTableParameters.trTslPips;
      
      int      newBarIndexEntry  = 0;
      bool     newBarEntry       = TM.new_bars[newBarIndexEntry];
      
      if (!isEnable || startRisk <= 0) return result;
   
      int   ticket   = GetLastTicket();
      
      StructOrder or;
      or.Initialize(ticket);
      
      double   openPrice   = or.trOpenPrice;
      double   curSl       = or.trStopLoss;
      
      double   distPips    = trInit_StopLossDistPips;
      double   startPips   = distPips * startRisk;
      
      if (distPips <= 0){
         if (newBarEntry)
            LOG(
               TM.ToString(distPips)+", "+
               TM.ToString(openPrice)+", "+
               TM.ToString(curSl)+", "+
               TM.ToString(startPips)+", "+
               TM.ToString(startRisk)+", "+
               ToString()
               );
         return result;      
      }
      
      int      coef        = or.trType % 2 == 0 ? 1 : -1;
      double   level       = openPrice + coef * startPips * TM.Pip();
      double   curPrice    = or.GetPriceCurrentClose();
      
      bool     isCrossed   = or.trType % 2 == 0 ? curPrice >= level : curPrice <= level;
      double   newSl       = curPrice - coef * distPips * TM.Pip();
      bool     isNewSl     = curSl == 0 || (or.trType % 2 == 0 ? newSl > curSl : newSl < curSl);
      
      if (isCrossed){
         //UpdateIsBreakEvenTriggered(true,HEAD_TO_STRING);
         
         if (isNewSl){
            if (ModifyStopLosses(newSl, HEAD_TO_STRING)){
               result++;
            }
         }
      }
      
      if (isNewSl || newBarEntry){
         LOG(
                  TM.ToString(isCrossed)+", "+
                  TM.ToString(trName)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(startPips)+", "+ 
                  TM.ToString(distPips)+", "+ 
                  TM.ToString(startRisk)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(openPrice)+", "+ 
                  TM.ToString(curSl)+", "+ 
                  
                  or.ToString()+", "+ 
                  ToString()
                  );
      
         LOG(
                  TM.ToString(isCrossed)+", "+
                  TM.ToString(trName)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(ticket)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(isNewSl)+", "+ 
                  TM.ToString(newSl)+", "+ 
                  TM.ToString(curSl)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(isCrossed)+", "+ 
                  TM.ToString(curPrice)+", "+ 
                  TM.ToString(level)+", "+ 
                  
                  or.ToString()+", "+ 
                  ToString()
                  );
         }            
      
      if (newBarEntry || trIsBreakEvenTriggered){
         LOG(
                  TM.ToString(trIsBreakEvenTriggered)+", "+
                  TM.ToString(trName)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(isEnable)+", "+ 
                  TM.ToString(startRisk)+", "+ 
                  
                  ToString()
                  );
      }   
      
      return result;
   }
   
   int ActionBreakEven_ByCandle(StructTableParameters& trStructTableParameters, string reason){
      int   result   = 0;
      if (trIsBreakEvenTriggered) return result;
      
      bool     isEnable    = be_after_x_candles_enable;
      int      candles     = be_after_x_candles;
      double   profitPips  = breakeven_profit;
      
      int      startCandle = iBarShift(_Symbol,_Period,trEntryTime);
      
      bool     isCandles         = startCandle >= candles;
      
      bool     newBarEntry       = TM.new_bar;
      
      if (!newBarEntry) return result;
      if (!isEnable || candles <= 0) return result;
      
      int   ticket   = GetLastTicket();
      
      StructOrder or;
      or.Initialize(ticket);
      
      double   openPrice   = or.trOpenPrice;
      double   curSl       = or.trStopLoss;
      
      double   distPips    = trInit_StopLossDistPips;
      
      if (distPips <= 0){
         if (newBarEntry)
            LOG(
               TM.ToString(distPips)+", "+
               TM.ToString(openPrice)+", "+
               TM.ToString(curSl)+", "+
               ToString()
               );
         return result;      
      }
      
      int      coef        = or.trType % 2 == 0 ? 1 : -1;
      double   curPrice    = or.GetPriceCurrentClose();
      
      bool     isCrossed   = isCandles;
      double   newSl       = openPrice + coef * profitPips * TM.Pip();
      bool     isNewSl     = curSl == 0 || (or.trType % 2 == 0 ? newSl > curSl : newSl < curSl);
      
      if (isCrossed){
         
         result++;
         if (isNewSl){
            if (ModifyStopLosses(newSl, HEAD_TO_STRING)){
               UpdateIsBreakEvenTriggered(true,HEAD_TO_STRING);
            }
         }
      }
      
      if (isCrossed || newBarEntry){
         LOG(
                  TM.ToString(isCrossed)+", "+
                  TM.ToString(trName)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(startCandle)+", "+ 
                  TM.ToString(candles)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(openPrice)+", "+ 
                  TM.ToString(curSl)+", "+ 
                  
                  or.ToString()+", "+ 
                  ToString()
                  );
      
         LOG(
                  TM.ToString(isCrossed)+", "+
                  TM.ToString(trName)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(ticket)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(isNewSl)+", "+ 
                  TM.ToString(newSl)+", "+ 
                  TM.ToString(curSl)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(isCrossed)+", "+ 
                  TM.ToString(curPrice)+", "+ 
                  
                  or.ToString()+", "+ 
                  ToString()
                  );
      }            
      
      if (newBarEntry || trIsBreakEvenTriggered){
         LOG(
                  TM.ToString(trIsBreakEvenTriggered)+", "+
                  TM.ToString(trName)+", "+ 
                  
                  TM.ToString(SEP)+", "+ 
                  TM.ToString(isEnable)+", "+ 
                  TM.ToString(profitPips)+", "+ 
                  
                  ToString()
                  );
      }
      
      return   result;
   }      
   
   void UpdateIsBreakEvenTriggered(bool state, string reason){
      if (trIsBreakEvenTriggered != state){
         trIsBreakEvenTriggered   = state;
         
         LOG(
                  TM.ToString(reason)+", "+
                  TM.ToString(trIsBreakEvenTriggered)+", "+
                  TM.ToString(trName)+", "+
                  ToString()
                  );
      
      }
   }
   
   
   
   
   
   

      

};
