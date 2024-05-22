public class SelectAllExt {
    public List<Case> caseList{get;set;}
    public SelectAllExt() {
        caseList = [SELECT Id,CaseNumber, Status FROM case];
    }
}