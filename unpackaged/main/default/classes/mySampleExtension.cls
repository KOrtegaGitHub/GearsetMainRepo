public with sharing class mySampleExtension{
    

    Public String accId;
    Public Account acc {get;set;}
    Public string testStrValue {get;set;}
    
    public mySampleExtension(ApexPages.StandardController controller){
        accId= ApexPages.currentPage().getParameters().get('id');
        acc = new Account();
        
        if(accId!= null && accId !=''){
            acc= [Select Id, Name from Account Where id =: accId];
        }
    
        testStrValue='First values';
    }
    
    public pageReference updateAccount(){
    
        update acc;
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Updated Successfully');  
        ApexPages.addMessage(myMsg);
        
        PageReference accPage = new ApexPages.StandardController(acc).view();
        accPage.setRedirect(true);
        testStrValue='Second values';
        return accPage;
    }
    
}