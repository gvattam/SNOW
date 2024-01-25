public class OpportunityTriggerHandlerUtil{
    public static void updateConvertedAmount(List<Opportunity> pNew, Map<Id, Opportunity > pOldMap) {
        Set<Id> OpportunityIDSet = new Set<Id>();
        Map<Id, Decimal> amountRateMap = new Map<Id, Decimal>();
        Opportunity old;
        if (pNew == null || pNew.isEmpty()) {
            return;
        }

        for(Opportunity o: pNew){
            if (pOldMap != null && pOldMap.get(o.Id) != null) {
                old = pOldMap.get(o.Id);
            }
            system.debug('??? old'+ old);
            system.debug('??? o'+ o);
            if (old == null || (o.Amount != old.Amount || (o.StageName != old.StageName && o.StageName == system.label.ClosedWonStage) )) {
                OpportunityIDSet.add(o.Id);
            }
        }
        
        if(!OpportunityIDSet.IsEmpty()){
           amountRateMap = OpportunityCurrencyConversionHandler.handleOpportunityCurrencyConversion(OpportunityIDSet);
           system.debug('amountRateMap?????'+ amountRateMap);
        }
        
        
        if(!amountRateMap.IsEmpty()){
            for(Opportunity o: pNew){
                Decimal rate = amountRateMap.containsKey(o.Id) ? amountRateMap.get(o.Id) : 1;
                system.debug('rate?????'+ rate);
                o.Amount_USD__c = o.Amount * rate;
            }
        }
    }
}