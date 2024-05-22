/**
@description - newAccountContactExt
@author Kharla Haldos
@date  July 13, 2016
@history Kharla Haldos July 14, 2016 - ExtensionClass [newAccountContactExt]  for VF page newAccountContactExt
**/


public with sharing class newAccountContactExt {

    //Retrieved and set the following values
    Public Account newAcc {get;set;}
    Public Contact newCon {get;set;}
    Public Id SubcRecTypeId {get;set;}
    Public string currentUser {get;set;}
    //Public string testStrValue {get;set;} - for debugging purposes
    
    /**
    @description - newAccountContactExt
    @author Kharla Haldos
    @date  July 13, 2016
    @history Kharla Haldos July 14, 2016 - newAccountContactExt Methods
    **/
    public newAccountContactExt(ApexPages.StandardController stdcontroller) {

        newAcc = new Account();
        newCon = new Contact();
        
        currentUser = Userinfo.getName();
        
        SubcRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Subscriber').getRecordTypeId();
    }
    
     /**
    @description - saveNewAccCon
    @author Kharla Haldos
    @date  July 13, 2016
    @history Kharla Haldos July 14, 2016 - saveNewAccCon - Method saved action for creation of Account and Contact
    **/
    public pageReference saveNewAccCon(){

        try{
            //Insert the record using the values from the Visualforce page for Account, to use in contact creation
            insert newAcc;
            
            //Contact Mapping of Values with Account
            newCon.AccountId = newAcc.Id;
            newCon.RecordTypeId = SubcRecTypeId;
            newCon.MailingStreet = newAcc.BillingStreet;
            newCon.MailingCity = newAcc.BillingCity;
            newCon.MailingState = newAcc.BillingState;
            newCon.MailingPostalCode = newAcc.BillingPostalCode;
            newCon.MailingCountry = newAcc.BillingCountry;
            
            //Insert newContact includes fields of mailing Address not fillout
            insert newCon;

            //Redirect the user in new Account's detail view page after saving the records.
            PageReference accPage = new ApexPages.StandardController(newAcc).view();
            accPage.setRedirect(true);
            //testStrValue ='Insert in Try'; debugging purposes
            return accPage;
            
        }catch(DMLException e){ //must have been an issue with the update
        
            ApexPages.addMessages(e); //display the error message to the User
            //testStrValue ='Insert in Catch'; debugging purposes
            return null; //return null so DMLException can be displayed to the User
     
        }
        
    }

}