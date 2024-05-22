public class myControllerExtension {

    public Account acct {get; set;}
    
    
    public myControllerExtension(ApexPages.StandardController stdController)
    {
        this.acct =(Account)stdController.getRecord();
    }
    
    public String getGreeting(){
    
        return 'Hello' + acct.name + '(' + acct.id +')';
    }
}