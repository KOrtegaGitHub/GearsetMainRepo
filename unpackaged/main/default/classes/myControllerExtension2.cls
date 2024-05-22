public class myControllerExtension2 {

    private final Account acct;
    public myControllerExtension2(ApexPages.StandardController stdController)
    {
        this.acct =(Account)stdController.getRecord();
    }
    
    public String getGreeting2(){
    
        return '@@@@Hello Greetings' + acct.name;
    }
}