/**
@description - TestDataFactory - collection of all test data
@author Kharla Haldos
@date  July 14, 2016
@history Kharla Haldos July 14, 2016 - TestDataFactory [added : createAccount, createContact]
**/

public class TestDataFactory {


    /**@description - Handling creation of test data for account
       @author Kharla Haldos
       @date  July 14, 2016 - create createAccount
    **/
    public static Account createAccount(integer i, string acctname){

        Account newacc = new Account();
        newacc.name = acctname;
        
        return newacc;
    
    }
    
    /**@description - Handling creation of test data for contact
       @author Kharla Haldos
       @date  July 14, 2016 - create createContact
    **/
    public static Contact createContact(integer i, string lastname, string email, id accId)
    {
        Contact newCon = new Contact();
        newCon.LastName = lastname;
        newCon.Email = email;
        newCon.AccountId = accId;  
        return newCon;
    
    }
    
    /**@description - Handling creation of test data for Account Search
       @author Kharla Haldos
       @date  July 14, 2016 - create createContact
    **/
    public static Account createSearchAccount(integer i, string accountName, string accBCountry, string accSCountry, string Type)
    {
        Account newAccSrch = new Account();
        newAccSrch.Name = accountName;
        newAccSrch.ShippingCountry = accBCountry;
        newAccSrch.BillingCountry = accSCountry;
        newAccSrch.Type = Type;
     
        return newAccSrch;
    
    }
    
    /**@description - Handling creation of test data for  Contact search related to account
       @author Kharla Haldos
       @date  July 14, 2016 - create createContact
    **/
    public static Contact createSearchAccRelCon(integer i, string lastname, string firstname, id accId)
    {
        Contact newConSearch = new Contact();
        newConSearch.FirstName = lastname;
        newConSearch.LastName = firstname;
        newConSearch.AccountId = accId;  
        return newConSearch;
    
    }
    
    /**@description - Handling creation of test data for  Contact search NO related to account
       @author Kharla Haldos
       @date  July 25, 2016 - create createConNoAccRel
    **/
    public static Contact createConNoAccRel(integer i, string lastname, string firstname)
    {
        Contact newConSearch = new Contact();
        newConSearch.FirstName =lastname;
        newConSearch.LastName =firstname;
        return newConSearch;
    
    }
        
}