public class AccountHandler {

    public static Account insertNewAccount(String accName){
        Account newAcc = new Account();
        newAcc.Name = accName;
        
        try{
            
            insert newAcc;

        }catch(Exception e){
            
            System.debug('A DML exception has occurred: ' + e.getMessage());
	        return null; 
        }
        
        return newAcc;
    }
}