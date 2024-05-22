/**
@description - AccountTriggerHandler
@author Kharla Haldos
@date  July 4, 2016
@history Kharla Haldos July 4, 2016 - added before insert ,ethod and ph country code validation
**/

public class AccountTriggerHandler {

    
    public  void onBeforeInsert(list<Account> accList)
    {
        PopulateShippingAddress(accList);
        validatePHPhoneNumber(accList);
    }
    
    public  void onBeforeUpdate(list<Account> accList, list<Account> oldAccList)
    {
        PopulateShippingAddress(accList);
        validatePHPhoneNumber(accList);
        PopulateOldBillingAddress(accList, oldAccList);
    }
    
    public void onAfterUpdate(list<Account> accList)
    {
        PopulateConMailingAddFromAccBillingAdd(accList);
    }
    
        /**
        @@method description PopulateContactMailingAddFromBAccBillingAdd - When a user updates an existing  Account's Billing Address, 
                             the new address should be copied over to the Mailing Address of each of the Contacts related to the Account.
        @@author Kharla Haldos
        @@date 07/06/2016                   
        **/
   public void PopulateConMailingAddFromAccBillingAdd(list<Account> accList){
     
       Set<Id> accountIds = Trigger.newMap.keySet();
       Map<Id, Account> accountMap = new Map<Id, Account>();
 
      for(Account newAccnt : accList)
       {   
              if(newAccnt.BillingCity != null &&
                 newAccnt.BillingCountry != null &&
                 newAccnt.BillingPostalCode != null &&
                 newAccnt.BillingState != null &&
                 newAccnt.BillingStreet != null){
              
                   accountMap.put(newAccnt.Id, newAccnt);   
                   
              }
              else{
              
                  newAccnt.addError('Billing Address  fields should not be a null values');
              }
   
       }
      
       //Query contacts related to triggering accounts
       List<Contact> updateMailAddList = [Select Id, AccountId from Contact WHERE AccountId in:accountMap.Keyset()];
                 
       Account acctMapList;
       if((updateMailAddList.size() > 0) && updateMailAddList != NULL)
       {
           for(Contact updMailAdd: updateMailAddList)
           { 
                acctMapList = AccountMap.get(updMailAdd.AccountId);
                
                updMailAdd.MailingStreet = acctMapList.billingstreet;
                updMailAdd.MailingCity = acctMapList.billingcity;
                updMailAdd.MailingPostalCode = acctMapList.billingpostalcode;
                updMailAdd.MailingState = acctMapList.billingstate;
                updMailAdd.MailingCountry = acctMapList.billingcountry;
                
           }
                     
           update updateMailAddList;
              
        }
       
             
   }
  
           /**
            @@method description PopulateOldBillingAddress- get the values of old billing address account based on the new updated values upon updating the billing address
            @@author Kharla Haldos
            @@date  07/05/2016
        **/       
    public  void PopulateOldBillingAddress(list<Account> accList, list<Account> oldAccList){
    
   
        Integer i = 0;//Set initial values for index of my list
        
        for(Account acc: accList)//loop the current account list
        {
             //List of New values of Billing Address
                String newBillingCity = acc.BillingCity;
                String newBillingCountry = acc.BillingCountry;
                String newBillingPostalCode = acc.BillingPostalCode;
                String newBillingState = acc.BillingState;
                String newBillingStreet = acc.BillingStreet;
             
              //List of Oldvalues of Billing Address
              String oldBillingCity = oldAccList[i].BillingCity;
              String oldBillingCountry = oldAccList[i].BillingCountry;
              String oldBillingPostalCode = oldAccList[i].BillingPostalCode;
              String oldBillingState = oldAccList[i].BillingState;
              String oldBillingStreet = oldAccList[i].BillingStreet;
              
              system.debug('Old List Array:' + oldAcclist);
              
              if(oldBillingCity != null &&
                  oldBillingCountry != null &&
                  oldBillingPostalCode != null &&
                  oldBillingState != null &&
                  oldBillingStreet != null)
                  {
                  
                   //Do the actual population of Billing Address Fields using the old values.
                   accList[i].Old_City__c = oldBillingCity;
                   accList[i].Old_Country__c= oldBillingCountry ;
                   accList[i].Old_Postal_Code__c= oldBillingPostalCode ;
                   accList[i].Old_State__c= oldBillingState ;
                   accList[i].Old_Street__c= oldBillingStreet ;
                   
                    i++;
                    
                   }
                  
        }
           
     }
     
       /**
            @@method description PopulateShippingAddress - Auto populate Shipping Address based on the details of Billing Address under Account object
            @@author Kharla Haldos
            @@date  07/04/2016
        **/      
                                            
    public  void PopulateShippingAddress(list<Account> accList){
      
      
        for(Account acc: accList)
        {
            //Validate Billing Country  should ignore input of us/usa and Shipping City is empty
           
            if(acc.BillingCity != null &&
                 acc.BillingCountry != null &&
                 acc.BillingPostalCode != null &&
                 acc.BillingState != null &&
                 acc.BillingStreet != null){
          
                if((acc.BillingCountry.equalsIgnoreCase('us') || acc.BillingCountry.equalsIgnoreCase('usa')) 
                    && acc.ShippingCity == null) {
                     
                        acc.ShippingCity = acc.BillingCity;
                        acc.ShippingCountry = acc.BillingCountry;
                        acc.ShippingPostalCode = acc.BillingPostalCode;
                        acc.ShippingState = acc.BillingState;
                        acc.ShippingStreet = acc.BillingStreet;      
                }
            }
        }
    }
        
        /**
        
            @@method description validatePHPhone Number should only accept +63
            @@author Kharla Haldos
            @@date  07/04/2016
        **/
        public  void validatePHPhoneNumber(list<Account> accList){
            for(Account acc: accList){
            
                 if(acc.BillingCountry != null){
                
                   if(acc.BillingCountry.equalsIgnoreCase('ph')){
                          string phoneStr='';
                          
                          if(acc.Phone != null){
                          
                               phoneStr= string.valueOf(acc.Phone);
                               
                               if(!phoneStr.startsWith('+63')){
                               
                                  acc.Phone.addError('Philippine telephone numbers must be prefixed with the Country Code: +63.');
                              }
                          }
                      }
                  }
            }
          
    }
    
}