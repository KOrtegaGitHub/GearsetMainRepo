public class NewCaseListController {

    public List<Case> getNewCases(){
          
        String stat = 'New';
        List<Case> results = Database.query(
            'SELECT Id, CaseNumber FROM Case Where Status =:stat LIMIT 10'
        );
        return results;
    }
}