public with sharing class CaseCreateReportController {

 private Case cas {get;set;}
 
 public CaseCreateReportController(ApexPages.StandardController controller){
       this.cas =(Case)controller.getRecord();   
    }
    
    /**
    *  Description of the purpose of the classthe method. 
    *  @name <method-name>
    *  @param <parameter-name> <description>
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
    */
    public PageReference getRedir() {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
            Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtByName = rtMapByName.get('Contact Record');
            String recTypeId = (String)rtByName.getRecordTypeId();
            RecordTypeId = recTypeId;
            return null;
    }
    
    private final ApexPages.StandardController controller;
    public String RecordTypeId{get;set;}

}