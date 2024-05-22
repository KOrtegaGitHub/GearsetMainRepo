/*@Description: This is the test class for the dynamic account search pagei
* @Author: Ma. Carla Haldos
* @Created Date: 07/22/2016
* @History: 07/22/2016 - Created
*           07/24/2016 - Updated add additional methods
*/
@isTest
public class AccountSearchController_Test {


    /*@Description: This is method used TestDataFactory to populate records
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 -
    *         
    */
    @testSetup
    public static void testDataSetUp(){
      //instantiate TestDataFactory
      TestDataFactory dataFactory = new TestDataFactory();
      
      List<Account> accList = new List<Account>();
      List<Contact> conList = new List<Contact>();
      List<Contact> conList2 = new List<Contact>();
      Set<Id> AccountIds = new Set<Id>();
      //Account Creation
      for(Integer i=1;i<20;i++){
          accList.add(TestDataFactory.createSearchAccount(i,'Accenture'+ i,'USA'+i,'US'+i,'Customer - Direct'));
      }
       insert accList;
      
      //Contact Creation - multiple
       for(Integer x =0; x<10; x++){
              conList.add(TestDataFactory.createSearchAccRelCon(x, 'Haldos'+x, 'Kharla'+x, accList[x].Id));
          }
 
      insert conList;
 
      //Contact Creation
      conList2.add(TestDataFactory.createConNoAccRel(1, 'Ortega', 'Kharla'));
      insert conList2;
      
      //custom setting recorda creation
      FilterFieldsSearch__c cs = new  FilterFieldsSearch__c();
      cs.accSearch_LimitSize__c = '5';
      insert cs;
      
    }
    
    /*@Description: This is method dynamic for happy path for Account Name search
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 -testAccountNameSearch
    *           
    */   
    static testmethod void testAccountNameSearch(){
    
        AccountSearchController accNameSrch = new AccountSearchController();
        accNameSrch.accNameStr = 'Accenture1';
        
        for(Account accqry: [Select Name from Account]){
            system.debug('@@accNameStr' + accqry);
         }
        
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
        
       system.assertequals(1,accNameSrch.swList.size());
    }
 
    
    /*@Description: This is method dynamic for happy path for Account Name search with wildcard(*)
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 - testAccountNameWildCardSearch
    *           
    */   
    static testmethod void testAccountNameWildCardSearch(){
        AccountSearchController accNameSrch = new AccountSearchController();
        accNameSrch.accNameStr = 'Accent*';
        
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
        
       system.assertequals(5,accNameSrch.swList.size());
    }
    
    
    /*@Description: This is method dynamic for negative path for Account Name search
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 -testAccountNameSearchNegative
    *           
    */   
   static testmethod void testAccountNameSearchNegative(){
        AccountSearchController accNameSrch = new AccountSearchController();
        accNameSrch.accNameStr = 'A';
        
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
      
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('A minimum of 2 characters is required to search using the Account Name')) b = true;
        }
 
        system.assert(b);
    }
    
    /*@Description: This is method dynamic for happy path for Account - Country search
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 - testCountrySearch
    *           
    */   
    static testmethod void testAccCountrySearch(){
        AccountSearchController accNameSrch = new AccountSearchController();
        accNameSrch.accCountryStr = 'USA1';
        
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
        
       system.assertequals(1,accNameSrch.swList.size());
    }
    
    /*@Description: This is method dynamic for happy path for ContactName search
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 - testConNameSearch
    *           
    */   
    static testmethod void testConNameSearch(){
        AccountSearchController accNameSrch = new AccountSearchController();
        accNameSrch.conNameStr = 'Kharla';
        
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
        
        system.assertequals(5,accNameSrch.swList.size());
    }
    
    /*@Description: This is method dynamic for happy path for Account - Type search
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 - testAccTypeSearch
    *           
    */   
    static testmethod void testAccTypeSearch(){
        AccountSearchController accNameSrch = new AccountSearchController();
        accNameSrch.accTypeStr.Type = 'Customer - Direct';
        
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
       system.assertequals(5,accNameSrch.swList.size());
    }

       /*@Description: This is method search in all fields
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 - testAllSearchFieldsAreInputted
    *           
    */  
    static testmethod void testAllSearchFieldsAreInputted(){
        Boolean disPrev;
        Boolean disNext;
        AccountSearchController accNameSrch = new AccountSearchController();
        
        accNameSrch.accNameStr = 'Acc*';
        accNameSrch.accCountryStr= 'US1*';
        accNameSrch.conNameStr = 'Kharla1*';
        accNameSrch.accTypeStr.Type = 'Customer - Direct';
      
        test.startTest();
        
        //search button
        accNameSrch.findAcc();
        disPrev = accNameSrch.getDisabledPrevious();
        
        //Pagination part
        accNameSrch.firstPage();
        accNameSrch.previousPage();
        accNameSrch.nextPage();
        accNameSrch.lastPage();
        
        disNext = accNameSrch.getDisableNext();
        
        test.stopTest();
      system.assertequals(4,accNameSrch.swList.size());
    }
    
    /*@Description: This is method search for account name without a contact
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 - testAccWithoutCon
    *           
    */  
     static testmethod void testAccWithoutCon(){
        
        AccountSearchController accNameSrch = new AccountSearchController();
         for(contact con: [Select LastName, FirstName from Contact]){
            system.debug('@@ConList' + con);
         }
                 for(Account acc: [Select Name,BillingCountry, ShippingCountry,Type from Account]){
            system.debug('@@AccList' + acc);
         }
        accNameSrch.accNameStr = 'Accenture5';
        accNameSrch.accCountryStr= 'US6';
        accNameSrch.conNameStr = 'Ortega';
        accNameSrch.accTypeStr.Type = 'Customer - Direct';
      
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
        
      system.assertequals(5,accNameSrch.swList.size());
    }
    
    /*@Description: This is method holds Null values
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/22/2016
    * @History: 07/24/2016 - testAllFieldsIsEmpty
    *           
    */  
    static testmethod void testAllFieldsIsEmpty(){
        
        AccountSearchController accNameSrch = new AccountSearchController();
        
        accNameSrch.conNameStr = null;
        accNameSrch.accNameStr = null;
        accNameSrch.accCountryStr= null;
        accNameSrch.accTypeStr.Type = null;
      
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please provide a value for at least 1 of the available criteria.')) b = true;
        }
 
        system.assert(b);
    }
    
    /*@Description: This is method holds query exception during try/catch
    * @Author: Ma. Carla Haldos
    * @Created Date: 07/28/2016
    * @History: 07/28/2016 - testQueryException
    *           
    */  
   /* static testmethod void testQueryException(){
        integer limit
        AccountSearchController accNameSrch = new AccountSearchController();
  
        accNameSrch.= -1;
 
        test.startTest();
        accNameSrch.findAcc();
        test.stopTest();
         
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Query Exception:')) b = true;
        }
 
        system.assert(b);
    }*/
  
}