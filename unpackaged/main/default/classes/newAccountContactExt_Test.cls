@isTest
public class newAccountContactExt_Test {
            
    /**
    @description - testNewAccountContactExt - handling test scenario using test data
    @author Kharla Haldos
    @created date  July 14, 2016
    **/  
    static testmethod void testNewAccountContactExt(){
    
        newAccountContactExt myExtClass;
        Account newAcc;
        Contact newCon;

        //Test Data setup
        newAcc = new Account();
        newCon = new Contact();
        
        //Use the Test Method in TestDataFactory
        Account newAcc1 = TestDataFactory.createAccount(1, 'Test Account');
        Account newAcc2 = TestDataFactory.createAccount(1, 'Test Account2');
        insert newAcc2;
        
        Contact newCon1 = Testdatafactory.createContact(1, 'Test Last Name', 'TestEmail@yahoo.com', newAcc.Id);
        newCon1.MailingStreet ='Sample Street';
        newCon1.MailingCity = 'Sample City';
        newCon1.MailingState = 'Sample State';
        newCon1.MailingPostalCode = 'Sample Postal Code';
        newCon1.MailingCountry = 'Sample Count';
            
        insert newCon1;
        
        Contact newCon2 = Testdatafactory.createContact(1, 'Test Last Name2', 'TestEmail2@yahoo.com', newAcc2.Id);
        
        Test.startTest();
        
       //Call the controller methods
        pageReference pageRef = page.NewAcctAndContact;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',newAcc2.id);
        
        ApexPages.StandardController scAccount = new ApexPages.StandardController(newAcc2);
        myExtClass = new newAccountContactExt(scAccount);
        myExtClass.newAcc = newAcc1;
        myExtClass.newCon = newCon2;

       
        //call the save method
        pageReference response = myExtClass.saveNewAccCon();

        Test.stopTest();

        
        //Assertions checkings of values
        
        system.assert(myExtClass.newAcc.Id != null,'Checking if after clicking saved button account id should not be null');
   
        System.assert(myExtClass.newAcc != null, 'Expected the account in the controller to be non-null');
        String accId = String.valueOf (myExtClass.newAcc.Id);
       
 
        List<Account> insertedAcc = [Select Id from Account limit 1];
        System.AssertEquals(1, insertedAcc.size(), 'Expected to have 1 Account created in the system');
   
        List<Contact> insertedCon = [Select Id from Contact limit 1];
        System.AssertEquals(1, insertedCon.size(), 'Expected to have 1 Account created in the system');
    }

    /**
    @description - testNewAccountContactExt - handling test scenario using test data (For Negative Scenario)
    @author Kharla Haldos
    @created date  July 14, 2016
    **/  
    static testmethod void testNewAccountContactExtNegative(){
    
        newAccountContactExt myExtClass;
        Account newAcc;
        Contact newCon;

        //Test Data setup
        newAcc = new Account();
        newCon = new Contact();
        
        //Use the Test Method in TestDataFactory
        Account newAcc1 = TestDataFactory.createAccount(1, 'Test Account');
        Account newAcc2 = TestDataFactory.createAccount(1, 'Test Account2');
        insert newAcc2;
        
        Contact newCon1 = Testdatafactory.createContact(1, 'Test Last Name', 'TestEmail@yahoo.com', newAcc.Id);
        newCon1.MailingStreet ='Sample Street';
        newCon1.MailingCity = 'Sample City';
        newCon1.MailingState = 'Sample State';
        newCon1.MailingPostalCode = 'Sample Postal Code';
        newCon1.MailingCountry = 'Sample Count';
            
        insert newCon1;
        
        Contact newCon2 = Testdatafactory.createContact(1, 'Test Last Name2', 'TestEmail2@yahoo.com', newAcc2.Id);
        
        Test.startTest();
        
        //Call the controller methods
        pageReference pageRef = page.NewAcctAndContact;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',newAcc2.id);
        
        //Use the Test Method in TestDataFactory
        ApexPages.StandardController scAccount = new ApexPages.StandardController(newAcc2);
        myExtClass = new newAccountContactExt(scAccount);
        myExtClass.newAcc = newAcc1;

        //call the save method
        pageReference response = myExtClass.saveNewAccCon();

        Test.stopTest();

        
        //Assertions checkings of values
        
        system.assert(myExtClass.newAcc.Id != null); //Checking if after clicking saved button account id should not be null

        System.assert(myExtClass.newAcc != null, 'Expected the account in the controller to be non-null');
        String accId = String.valueOf (myExtClass.newAcc.Id);

        List<Account> insertedAcc = [Select Id from Account limit 1];
        System.AssertEquals(1, insertedAcc.size(), 'Expected to have 1 Account created in the system');
   
        List<Contact> insertedCon = [Select Id from Contact limit 1];
        System.AssertEquals(1, insertedCon.size(), 'Expected to have 1 Account created in the system');
    }   
}