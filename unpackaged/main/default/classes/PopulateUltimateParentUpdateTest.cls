/**
@description - PopulateUltimateParentUpdateTest
@author Kharla Haldos
@date  July 11, 2016
@history Kharla Haldos July 11, 2016 - Test Class for PopulateUltimateParentContactBatchableTest and its negative scneario
**/


@isTest
public class PopulateUltimateParentUpdateTest {

     /*private static testmethod void PopulateUltimateParentUpdateSchedulableTest(){
        
        Test.startTest();
        system.schedule('PopulateUltimateParentContactBatchable', '0 0 23 **?', new PopulateUltimateParentContactSchedulable());
        
        Test.stopTest();
    }*/
    
    private static testMethod void PopulateUltimateParentContactBatchableTest() 
    {
        //Parent Account test data
        Account Acc1 = new Account();
        Acc1.Name = 'Test1';
        insert Acc1;
        
        //child Account test data
        Account Acc2 = new Account();
        Acc2.Name = 'Test2';        
        Acc2.ParentId = Acc1.id;
        
        insert Acc2;
        
        //test data for contact
        Contact con1 = new Contact();
        con1.LastName ='ConTest1';
        con1.AccountId = Acc2.id;

        insert con1;
        
        //Setting up the values of account fields to contact fields
        con1.Ultimate_Parent_Account__c = acc2.Ultimate_Parent__c;
        update con1;
             
                
       Test.startTest();
       Database.executebatch(new PopulateUltimateParentContactBatchable());
       Test.stopTest();     
        
       
    }       

    private static testMethod void PopulateUltimateParentContactBatchableTestNeg() 
    {
        
        //Parent Account test data
        Account Acc1 = new Account();
        Acc1.Name = 'Test1';
        insert Acc1;
        
        //Child Account test data
        Account Acc2 = new Account();
        Acc2.Name = 'Test2';        
        Acc2.ParentId = Acc1.id;
        
        insert Acc2;
        
        Contact con1 = new Contact();
        
        //Setting up the values of account fields to contact fields
        con1.Ultimate_Parent_Account__c = Acc1.id;
        update con1;
             
                
       Test.startTest();
       Database.executebatch(new PopulateUltimateParentContactBatchable());
       Test.stopTest();     
        
       
    }  
}