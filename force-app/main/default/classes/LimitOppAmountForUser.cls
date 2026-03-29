public class LimitOppAmountForUser {
    public static void limitOppAmountForUserMethod(List<Opportunity> oppList){
        
        Map<Id, Decimal> oppAmtMap = New Map<Id, Decimal>();
        
        List<Opportunity> existingOppList = [SELECT Id, Name, Amount, CreatedDate, OwnerId FROM Opportunity WHERE CreatedDate = Today AND OwnerId =: UserInfo.getUserId()];
        
        if(!existingOppList.isEmpty()){
            for(Opportunity existingOpp : existingOppList){
                if(oppAmtMap.containsKey(existingOpp.OwnerId)){
                    Decimal tempAmount = oppAmtMap.get(existingOpp.OwnerId);
                    tempAmount = tempAmount + existingOpp.Amount;
                    oppAmtMap.put(existingOpp.OwnerId, tempAmount);
                } else {
                    oppAmtMap.put(existingOpp.OwnerId, existingOpp.Amount);
                }
            }
        }
        
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                if(oppAmtMap.containsKey(opp.OwnerId)){
                    Decimal totalAmount = opp.Amount + oppAmtMap.get(opp.OwnerId);
                    if(totalAmount > 500000){
                        opp.addError('Total opportunity Amount cannot exceed $500000 in a day');
                    }
                }
            }
        }
    }
}