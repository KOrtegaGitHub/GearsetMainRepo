public class ContactSearch {
    
    public static List<Contact> searchForContacts(String lastname, String mailingpostalcode){
        
        List<Contact> conList = [SELECT Id, Name FROM Contact WHERE LastName =:lastname AND MailingPostalCode =:mailingpostalcode];
        
        return conList;
    }
}