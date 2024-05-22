public class ContactAndLeadSearch {

    public static List<List<SObject>> searchContactsAndLeads(String varName){
        
        List<List<SObject>> searchList = [FIND :varName IN ALL FIELDS RETURNING Contact(LastName,FirstName), Lead(LastName, FirstName)];
        
        return searchList;
    }
}