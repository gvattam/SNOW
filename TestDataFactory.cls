@isTest
public class TestDataFactory {
    
    public static Account createAccount(String name,Boolean insertRecord) {
        Account acc = new Account(Name = name, BillingCountry = 'US', BillingState = 'CA', ShippingCountry = 'US', ShippingState = 'CA');
        if(insertRecord)
            insert acc;
        return acc;
    }
    
    public static Opportunity createOpportunity(Id accountId, 
                                                String type, 
                                                String stage, Boolean insertRecord) {
                                                    Opportunity opportunity = 
                                                        new Opportunity(
                                                            AccountId = accountId,
                                                            Type = type,
                                                            CloseDate = System.today().addMonths(12),
                                                            StageName = stage,
                                                            Name = 'Test Opportunity',
                                                            Pricebook2Id = Test.getStandardPricebookId());
                                                    if(insertRecord)
                                                        insert opportunity;
                                                    return opportunity;
                                                }
    
    public static Pricebook2 createPricebook(String sPBName, Boolean insertRecord) {
        Pricebook2 pb = new Pricebook2(Name = sPBName, IsActive = True);
        if(insertRecord)                                                    
            insert pb;
        return pb;
    }
    
    public static PricebookEntry createPricebookEntry(Id pbID, Id productId, 
                                                      Decimal amount, Boolean insertRecord) {
                                                          PricebookEntry pbEntry = new PricebookEntry(
                                                              Pricebook2Id = Test.getStandardPricebookId(),
                                                              Product2Id = productId,
                                                              UnitPrice = amount,
                                                              IsActive = true
                                                          );
                                                          if(pbID != NULL){
                                                              pbEntry.Pricebook2Id = pbID;
                                                          }                                                  
                                                          if(insertRecord)                                                    
                                                              insert pbEntry;
                                                          return pbEntry;
                                                      }
    
    public static OpportunityLineItem createOpportunityLine(
        Id opportunityId, 
        Id productId, 
        PricebookEntry priceEntry, 
        Id lineItemId, Boolean insertRecord) {
            OpportunityLineItem line = new OpportunityLineItem(
                Product2Id = productId,
                OpportunityId = opportunityId,
                PricebookEntryId = priceEntry.Id,
                TotalPrice = priceEntry.UnitPrice,
                Quantity = 1
            );
            if(insertRecord)
                insert line;
            return line;
        }
    
    public static Product2 createProduct(String name, Decimal amount, Boolean insertRecord) {
        Product2 product = new Product2(
            Name = name,
            IsActive = true, 
            ProductCode = Name
        );
        if(insertRecord)
            insert product;
        return product;
    }
    
    public static Contact createContact(Id accId, String lastName, Boolean insertRecord) {
        Contact testCon = 
            new Contact(
                LastName = lastName, 
                AccountId = accId,
                Email = 'testsd@stpa.co.uptima',
                LeadSource = 'Live Chat',
                MailingCountry = 'US', 
                MailingState = 'CA'
            );
        if(insertRecord) insert testCon;
        return testCon; 
    }
    
}