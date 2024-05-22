trigger AccountTrigger on Account (before insert, before Update, after Update) {
    
    AccountTriggerHandler trigHandler= new AccountTriggerHandler();
   
      
    // Trigger only copies over the address for new Accounts where the Shipping Address is (mostly) empty.
    if(trigger.isBefore && trigger.isInsert){
            trigHandler.OnBeforeInsert(trigger.new);
        }
    

    if(trigger.isBefore && trigger.isUpdate){
 
            trigHandler.onBeforeUpdate(trigger.new, trigger.old);
        }
        
     if(trigger.isAfter && trigger.isUpdate){
            trigHandler.onAfterUpdate(trigger.new);
     }
}