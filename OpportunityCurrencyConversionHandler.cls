public class OpportunityCurrencyConversionHandler {
    public static Map<Id, Decimal> handleOpportunityCurrencyConversion(Set<Id> opportunityIDs) {
        Map<Id, Decimal> oppConversionRateMap = getConversionRateMapForOpportunity(opportunityIDs);
        return oppConversionRateMap;
    }
    
    private static Map<Id, Decimal> getConversionRateMapForOpportunity(Set<Id> opportunityIDs) {
        Map<Id, Opportunity> opportunities = findOpportunities(opportunityIDs);
        Map<Id, Decimal> oppConversionRateMap = new Map<Id, Decimal>();

        Set<DatedConversionRate> fixedRates = new Set<DatedConversionRate>();

        for (Opportunity opp : opportunities.values()) {
            String clsDate = makeCloseDateString(opp.CloseDate);
            String rateSOQL = ' (IsoCode = \'' + opp.CurrencyIsoCode + '\' AND StartDate <= ' + clsDate + ' AND NextStartDate > ' + clsDate + ')';

            fixedRates.addAll(findDatedRateConversions(rateSOQL));
            for (DatedConversionRate rateRecord : fixedRates) {
                if (opp.CloseDate >= rateRecord.StartDate && opp.CloseDate < rateRecord.NextStartDate && opp.CurrencyIsoCode == rateRecord.IsoCode) {
                    oppConversionRateMap.put(opp.Id, rateRecord.ConversionRate);
                    break;
                }
            }
        }
        return oppConversionRateMap;
    }

    private static List<DatedConversionRate> findDatedRateConversions(String pFilter) {
        String strSOQL = 'SELECT Id, IsoCode, ConversionRate, StartDate, NextStartDate FROM DatedConversionRate WHERE ' + pFilter;
        try {
            return (List<DatedConversionRate>) Database.query(strSOQL);
        } catch(Exception e) {
            System.debug('Error fetching Dated Conversion Rates: ' + e.getMessage());
            return new List<DatedConversionRate>();
        }
    }

    private static String makeCloseDateString(Date closeDate) {
        return DateTime.newInstance(
                closeDate.year(),
                closeDate.month(),
                closeDate.day()
        ).format('yyyy-MM-dd');
    }
    
     private static Map<Id, Opportunity> findOpportunities(Set<ID> opportunityIDs) {
        return new Map<Id, Opportunity>([SELECT Id, CurrencyIsoCode, CloseDate FROM Opportunity WHERE Id IN :opportunityIDs]);
    }
}