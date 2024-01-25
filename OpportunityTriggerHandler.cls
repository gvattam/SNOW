public class OpportunityTriggerHandler implements ITriggerHandler {
    
    public void BeforeInsert(List<SObject> pNew) {
        OpportunityTriggerHandlerUtil.updateConvertedAmount((List<Opportunity>)pNew,null);
    }
    
    public void BeforeUpdate(Map<Id, SObject> pNewMap, Map<Id, SObject> pOldMap){
        OpportunityTriggerHandlerUtil.updateConvertedAmount((List<Opportunity>)pNewMap.values(),(Map<Id, Opportunity>)pOldMap);
    }

    public void BeforeDelete(Map<Id, SObject> pOld) {}

    public void AfterInsert(Map<Id, SObject> pNew) {}

    public void AfterUpdate(Map<Id, SObject> pNew, Map<Id, SObject> pOld) {}

    public void AfterDelete(Map<Id, SObject> pOld) {}

    public void AfterUndelete(Map<Id, SObject> pOld) {}
}