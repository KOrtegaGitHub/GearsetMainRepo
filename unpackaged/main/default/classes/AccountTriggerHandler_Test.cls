/**
@description - AccountTriggerHandler_Test
@author Kharla Haldos
@date  July 8, 2016
@history Kharla Haldos July 8, 2016 - Test class for PopulateConMailingAddFromAccBillingAdd and PopulateConMailingAddFromAccBillingAddNegScen, validatePHPhoneNumber
**/

@isTest
public class AccountTriggerHandler_Test {
 
    static testMethod void PopulateConMailingAddFromAccBillingAdd(){
         
        integer batchSize = 20;
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        
        for(integer i=0; i <= batchSize; i++){
        
            Account acc = new Account();
            acc.Name = 'KharlaAcc' + i;
            acc.BillingStreet = 'SampleStreetOld'+ i;
            acc.BillingCity = 'SampleSCityOld'+ i;
            acc.BillingPostalCode = '123Old'+ i;
            acc.BillingCountry = 'USOld'+ i;
            acc.BillingState = 'SingaporeOld'+ i;
            accList.add(acc);
        }
        
        Insert accList;
        
        for(integer i=0; i <= batchSize; i++){
            Contact con = new Contact();
            con.AccountId = accList[i].id;
            con.LastName ='KharlaCon'+ i;
            conList.add(con);
         }
        
        Insert conList;
        
        List<Account> newUpdAccount = new List<Account>();
        for(Account updAcc: accList){
        
            updAcc.BillingStreet = 'SampleStreet';
            updAcc.BillingCity = 'SampleSCity';
            updAcc.BillingPostalCode = '123';
            updAcc.BillingCountry = 'US';
            updAcc.BillingState = 'Singapore';
            newUpdAccount.add(updAcc);
        }
        Test.startTest();
        
        
        try{
               Update newUpdAccount;
               Update conList;
               
        }catch(exception e){}
    
        Test.stopTest();
    }
    
     static testmethod void PopulateConMailingAddFromAccBillingAddNegScen(){
        
         Account acc = new Account();
         acc.Name = 'Kharla';
         acc.BillingStreet = 'SampleStreetOld';
         acc.BillingCity = 'SampleSCityOld';
         acc.BillingPostalCode = '123Old';
         acc.BillingCountry = 'USOld';
         acc.BillingState = 'SingaporeOld';
        
         Insert acc;
         
        Contact con = new Contact();
        con.AccountId = acc.id;
        con.LastName ='KharlaCon';
        
        
        Insert con;
        
         acc.BillingStreet = null;
         acc.BillingCity = null;
         acc.BillingPostalCode = null;
         acc.BillingCountry = null;
         acc.BillingState = null;
         
        Test.startTest();
        try{
         
            update acc;
            update con;
         
         }catch(exception e){}
         
        Test.stopTest();
      }
      
      static testmethod void validatePHPhoneNumber(){
  
         Account acc = new Account();
         
         acc.Name = 'KharlaAcc2';
         acc.BillingStreet = 'SampleStreet';
         acc.BillingCity = 'Makati';
         acc.BillingPostalCode = '123';
         acc.BillingCountry = 'ph';
         acc.BillingState = 'PHI';
         acc.Phone ='+65 917 8683 585';
         
         Test.startTest();
         try{
             insert acc;
             update acc;
         }catch(exception e){}
         Test.stopTest();
      }
}