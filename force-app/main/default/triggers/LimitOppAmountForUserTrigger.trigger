trigger LimitOppAmountForUserTrigger on Opportunity (before insert, before update, after undelete) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        LimitOppAmountForUser.limitOppAmountForUserMethod(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUndelete){
        LimitOppAmountForUser.limitOppAmountForUserMethod(Trigger.new);
    }
}