/**
@description - ContactTriggerHandler_Test
@author Kharla Haldos
@date  July 8, 2016
@history Kharla Haldos July 8, 2016 - Test class for setPrimaryContact,setPrimaryContactNegativeScen and checkPrimaryContactIsSet
**/

@isTest
public class ContactTriggerHandler_Test{

    static testmethod void setPrimaryContact(){
       
       Account newAcc = new Account(Name ='AccountPriTest');

       insert newAcc;
  
       Contact newCon = new Contact(Lastname = 'NewPrimarySet', Primary_Contact__c = false, AccountId = newAcc.id);
     
       insert newCon;
       
       system.assertequals(false,newCon.Primary_Contact__c);
       
       newCon.Primary_Contact__c = true;
       newCon.AccountId = newAcc.Id;

       Test.startTest(); 
        
       update newCon;
       
       Test.stopTest();
       
    }
      static testmethod void setPrimaryContactNegativeScen(){
       
       Account newAcc = new Account();
       newAcc.Name ='AccountPriTest';
      
       insert newAcc;
       
      
       Contact newCon1 = new Contact(); 
       newCon1.Lastname = 'NewPrimarySet';      
       newCon1.Primary_Contact__c = true;
       newCon1.AccountId = newAcc.Id;
   
       insert newCon1;
       
       Contact newCon2= new Contact();
       newCon2.Lastname = 'NewPrimarySet2'; 
       newCon2.Primary_Contact__c = true;
       newCon2.AccountId = newAcc.Id;
      
       Test.startTest();
       try{
           insert newCon2;
           
       }catch(exception e){
           newCon2.addError(e + 'Invalid Primary Contact. This Account has an existing Primary Contact.');
       }
       
       Test.stopTest();
    }
    
    static testmethod void checkPrimaryContactIsSet(){
       
       Account newAcc = new Account(Name ='AccountPriTest');

       insert newAcc;
  
       list<Contact> newCon= new list<Contact>();
       Contact newCon1 = new Contact(Lastname = 'NewPrimarySet', Primary_Contact__c = true, AccountId = newAcc.id);
       newCon.add(newCon1);
       
       Test.startTest(); 
       Contact newCon2 = new Contact(Lastname = 'NewPrimarySet2', Primary_Contact__c = false, AccountId = newAcc.id);
       newCon.add(newCon2);
       
       insert newCon;
       
       newCon2.Primary_Contact__c = true;
   
       try{
           update newCon2;
           
       }catch(exception e){
       
           newCon2.addError(e + 'Invalid Primary Contact. This Account has an existing Primary Contact.');
       }
       Test.stopTest();
       
    }
        
}