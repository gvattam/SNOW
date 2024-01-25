@isTest
public class OpportunityTriggerHandlerTest {

    @isTest
    static void testBeforeInsert() {
        DatedConversionRate fx_rate = [SELECT ConversionRate FROM DatedConversionRate WHERE IsoCode='EUR' AND NextStartDate > 2999-01-01];
        system.debug('fx_rate >>>>>'+ fx_rate);
        
        Product2 prod = TestDataFactory.createProduct('Product', 200, false);
        prod.CurrencyIsoCode = 'EUR';
        insert prod;
        
        // Create PricebookEntry with a conversion rate of 1.1 for EUR
        PricebookEntry pbEntry = TestDataFactory.createPricebookEntry(Test.getStandardPricebookId(), prod.Id, 200, false);
        pbEntry.CurrencyIsoCode = 'EUR';
        insert pbEntry;
        
        // Create additional test data for before insert
        Account acc = TestDataFactory.createAccount('Test Account 2', true);
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id, 'New Business', 'Qualified', false);
        opp.CurrencyIsoCode = 'EUR';

        // Trigger context setup for before insert
        Test.startTest();
        insert opp;

        OpportunityLineItem line_item = new OpportunityLineItem(
            OpportunityId = opp.Id,
            TotalPrice = 10000,
            Quantity = 10,
            Product2Id = prod.Id,
            PricebookEntryId = pbEntry.Id
        );
        insert line_item;

        opp.StageName = 'Closed Won';
        opp.CloseDate = Date.newInstance(2999, 01, 02);
        update opp;
        Test.stopTest();
        
        opp = [SELECT id,Amount,Amount_USD__c FROM Opportunity WHERE Id = :opp.Id];
        system.debug('opp>>>>>'+ opp);
        Decimal expectedAmountUSD = opp.Amount * fx_rate.ConversionRate;
        // Assert that the Amount_USD__c field is updated correctly
        System.assertEquals(expectedAmountUSD, opp.Amount_USD__c, 'Amount_USD__c should be updated correctly');

     }
    
    
    @isTest
    static void testBeforeUpdate() {
        Product2 prod = TestDataFactory.createProduct('Product', 200, false);
        prod.CurrencyIsoCode = 'USD';
        insert prod;
        PricebookEntry pbEntry = TestDataFactory.createPricebookEntry(Test.getStandardPricebookId(), prod.Id, 200, false);
        pbEntry.CurrencyIsoCode = 'USD';
        insert pbEntry;

        // Create additional test data for before update
        Account acc = TestDataFactory.createAccount('Test Account 2', true);
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id, 'New Business', 'Qualified', false);
        opp.CurrencyIsoCode = 'USD';

        // Trigger context setup for before update
        Test.startTest();
        insert opp;

        OpportunityLineItem line_item = new OpportunityLineItem(
            OpportunityId = opp.Id,
            TotalPrice = 10000,
            Quantity = 10,
            Product2Id = prod.Id,
            PricebookEntryId = pbEntry.Id
        );
        insert line_item;

        opp.StageName = 'Closed Won';
        opp.CloseDate = System.today();
        update opp;
        Test.stopTest();
        // Query the Opportunity after the trigger execution
        opp = [SELECT id,Amount,Amount_USD__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(opp.Amount, opp.Amount_USD__c, 'Amount_USD__c should be updated correctly');

    }
    
    
    @isTest
    static void testAllOthermethods() {
        Product2 prod = TestDataFactory.createProduct('Product', 200, false);
        prod.CurrencyIsoCode = 'USD';
        insert prod;
        PricebookEntry pbEntry = TestDataFactory.createPricebookEntry(Test.getStandardPricebookId(), prod.Id, 200, false);
        pbEntry.CurrencyIsoCode = 'USD';
        insert pbEntry;

        // Create additional test data for before update
        Account acc = TestDataFactory.createAccount('Test Account 2', true);
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id, 'New Business', 'Qualified', false);
        opp.CurrencyIsoCode = 'USD';

        // Trigger context setup for before update
        Test.startTest();
        insert opp;

        OpportunityLineItem line_item = new OpportunityLineItem(
            OpportunityId = opp.Id,
            TotalPrice = 10000,
            Quantity = 10,
            Product2Id = prod.Id,
            PricebookEntryId = pbEntry.Id
        );
        insert line_item;

        opp.StageName = 'Closed Won';
        opp.CloseDate = System.today();
        update opp;
        
        delete opp;
        undelete opp;
        Test.stopTest();
        

    }
}