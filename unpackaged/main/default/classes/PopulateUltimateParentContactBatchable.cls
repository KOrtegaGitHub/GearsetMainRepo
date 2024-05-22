/**
@description - PopulateUltimateParentUpdateTest
@author Kharla Haldos
@date  July 11, 2016
@history Kharla Haldos July 11, 2016 - Class for PopulateUltimateParentContactBatchableTest 
**/

global class PopulateUltimateParentContactBatchable implements Database.Batchable<sObject>
{
    //Query Locator - Retrieved all contacts records
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SeLect Id, Name, AccountId, Ultimate_Parent_Account__c, Account.Ultimate_Parent__c from Contact WHERE AccountId != NULL]);
    }
    
    //Actual execution and logics
    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
        //Setting up the variables
        Set<Id> accIdSets = new Set<Id>();
        List<Account> accList = new List<Account>();
        
         for(Contact con: scope)
         {
             accIdSets.add(con.AccountId);
         }
        
        //Collate all accounts related to contacts ids
        if(!accIdSets.isEmpty())
        {
                    accList = [SELECT Id, Name, Ultimate_Parent__c from Account WHERE Id= :accIdSets];
        }
  
        if(acclist.size() > 0)
        {
    
            for(Contact con: scope)
            {
                for(Account acc: accList)
                {
                    if(con.AccountId == acc.id)
                    {
                        
                        if(acc.Ultimate_Parent__c != NULL)
                        {
                          //Populate the value of Account Ultimate Parent from contact Ultimate Parent Account
                          con.Ultimate_Parent_Account__c = acc.Ultimate_Parent__c;
                          
                        }
                    }
                }
            
            }
            
        
           Database.Update(scope);

         
        }    
    }
    
    global void finish(Database.BatchableContext BC)
    {
    
    }

}