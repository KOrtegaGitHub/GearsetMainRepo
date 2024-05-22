/**
@description - ContactTriggerHandler
@author Kharla Haldos
@date  July 6, 2016
@history Kharla Haldos July 6, 2016 - added before insert ,method  SetPrimaryContact & checkPrimaryContactIsSet
**/

public class ContactTriggerHandler {

    public void onBeforeInsert(list<Contact> conList){
        setPrimaryContact(conList);
    }
    
    public void onAfterUpdate(list<Contact> conList, list<Contact> oldConList){
        checkPrimaryContactIsSet(conList,oldConList);    
    }
    
    /**
     @@description - Setup following variable that can share with other method
     @@author - Kharla Haldos
     @@createdDate - 07/07/16
    **/
    
    //Setup the variable for set of ids
    Set<id> accountIdSetTrue = new Set<id>();
    Set<id> accountIdSetFalse = new Set<id>();
    Set<id> contactIdSet = new Set<id>();
    //Setup Map variables
    Map<Id, Integer> accIdAndContactCountMap = new Map<Id, Integer>();
    Map<Id, list<Contact>> accIdAndPriConMap = new Map<Id, list<Contact>>();
    //Setup variables for fixed count
    Integer INTFIXEDCOUNT= 1;
    Integer checkCountOfPrimaryCon = 0;
   
    /**
    @@method description checkPrimaryContactIsSet- When an existing Non-Primary Contact is updated to become a Primary Contact,  
                    the system should check if the Account related to the updated Contact does not yet have a Primary Contact. 
                    If the Account already has a Primary Contact, a message should be shown to the user
    @@author Kharla Haldos
    @@date 07/06/2016                   
   **/   
    public void checkPrimaryContactIsSet(list<Contact> conlist,list<Contact> oldConList){
       
        Integer i= 0;
        for(Contact newUpdateConList : conList){// validation for a particular contact whether it is already primary or not.
        
        
            if(newUpdateConList.Primary_Contact__c == true && 
               newUpdateConList.AccountId != NULL && 
               (oldConList[i].Primary_Contact__c == TRUE || oldConList[i].Primary_Contact__c == FALSE))
               {
                   if(!accountIdSetTrue.contains(newUpdateConList.AccountId)){
                   
                       accountIdSetTrue.add(newUpdateConList.AccountId); //Add ids in a set if not yet included in a set Account
                       contactIdSet.add(newUpdateConList.Id);//Add ids in a set if not yet included in a set Contact
                       
                   }
                   i++;
               }
               
            if(contactIdSet != NULL && contactIdSet.size() > 0)
            {
                List<Contact> oldContactList =[SELECT Id, AccountId from Contact WHERE AccountId IN :accountIdSetTrue 
                                           AND Primary_Contact__c = TRUE AND Id NOT IN :contactIdSet];
             
                for(Contact cntId : oldContactList){                       
                                
                     accIdAndContactCountMap.put(cntId.AccountId,INTFIXEDCOUNT);                    
                }
                
                
                for(Contact newCon : conList){
                    if(newCon.AccountId != NULL && accIdAndContactCountMap.containsKey(newCon.AccountId)){
                    
                        checkCountOfPrimaryCon = accIdAndContactCountMap.get(newCon.AccountId);
                        
                        if(checkCountOfPrimaryCon == intFixedCount && newCon.Primary_Contact__c == TRUE )
                        {
                            newCon.Primary_Contact__c.addError('Invalid Primary Contact. This Account has an existing Primary Contact.');
                        }
                        
                    }
                }
                
                
            }
        }
    }
    
    /**
    @@method description setPrimaryContact - When a new Contact is created as a Primary Contact, 
                    the system should check if the Account related to the new Contact does not yet have a Primary Contact. 
                    If the Account already has a Primary Contact, a message should be shown to the user
    @@author Kharla Haldos
    @@date 07/06/2016                   
   **/    
    
    public void setPrimaryContact(list<Contact> conList){
               
        for(Contact newCon: conList){
 
            
               if(newCon.Primary_Contact__c == true && newCon.AccountId != NULL){
                                       
                   if(!accountIdSetTrue.contains(newCon.AccountId)){
                       
                       accountIdSetTrue.add(newCon.AccountId);
                   }                
               
               }else if(newCon.Primary_Contact__c == false && newCon.AccountId != NULL){
               
                  if(!accountIdSetFalse.contains(newCon.AccountId)){
                       
                       accountIdSetFalse.add(newCon.AccountId);
                   }  

               }
        }
    
        
        if((accountIdSetTrue !=NULL) && (accountIdSetTrue.size() > 0)){   

            //Get the list of accounId in Contact related in account that is set as primary contact
            List<Contact> OldContactList =[SELECT Name,Primary_Contact__c,AccountId FROM Contact 
                            WHERE AccountId IN :accountIdSetTrue AND Primary_Contact__c=TRUE]; 
                             
            Integer intCnt = 1;
            for(Contact cnt : OldContactList){                                                 
            
                accIdAndContactCountMap.put(cnt.AccountId,intCnt);
                intCnt++;                                                                                                                                                         
            }
                
        for(Contact newCon: conList){
            
            if(newCon.AccountId != NULL && accIdAndContactCountMap.containsKey(newCon.AccountId)){
            
                checkCountOfPrimaryCon = accIdAndContactCountMap.get(newCon.AccountId);

                if(checkCountOfPrimaryCon == INTFIXEDCOUNT){
                    newCon.Primary_Contact__c.addError('Invalid Primary Contact. This Account has an existing Primary Contact.');
                    
                }
                    
            }
         }
        
       }else if((accountIdSetFalse != NULL) && (accountIdSetFalse.size() > 0)){
             
             //Get the list of accounId in Contact related in account and check if there's an assign Primary contact already
             List<Contact> newContactList =[SELECT Name,Primary_Contact__c,AccountId FROM Contact 
                            WHERE AccountId IN :accountIdSetFalse and Primary_Contact__c = TRUE];  
            
            Boolean setTrue = true;
            if(newContactList.size() == 0)
            {
                    for(Contact cnt : conList){
                        
                        cnt.Primary_Contact__c = setTrue;
                    }
                
            }
       
      }
          
    }
    
}