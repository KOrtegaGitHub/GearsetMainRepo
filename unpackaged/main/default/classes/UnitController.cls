public with sharing class UnitController {
	
    @AuraEnabled
    public static List<TrailPackage__Unit__c> getSuggestedUnit(Id recordId){
        
        //Collate lead details to relate to UNIT
        List<TrailPackage__Unit__c> unitList = new List<TrailPackage__Unit__c>();
        Lead leadList = new Lead();
        system.debug('Before Lead list: ' + leadList);
        leadList = [SELECT id, Name, TrailPackage__Bathroom__c, TrailPackage__Bedroom__c, TrailPackage__Selected_Unit__c
                   from Lead
                   WHERE Id =: recordId];
        system.debug('After Lead list: ' + leadList);
        
        //Checker for Unit fields
        String[] fieldChecker = new String[]{
            'Price__c','Property_Type__c','Bathroom__c',
            'Bedroom__c','Area_sqm__c'
        };
        
        /*Map<String, Schema.SObjectField> fieldDescMap = Schema.SObjectType.Unit__c.fields.getMap();
        
        for(String flds : fieldChecker){
            if(!fieldDescMap.get(flds).getDescribe().isAccessible()){
                throw new System.NoAccessException();
                
                return null;
            }
        }  
        */
        system.debug('Before query list: ' + leadList.Bathroom__c + '' +leadList.Bedroom__c);
        system.debug('Before query list: ' + leadList.Bathroom__c + '' +leadList.Bedroom__c);
       
        
        if(leadList.Bathroom__c != NULL || leadList.Bedroom__c != NULL){
          
 
         unitList = [SELECT Id, Name,TrailPackage__Price__c, TrailPackage__Property_Type__c, TrailPackage__Bathroom__c, 
               TrailPackage__Bedroom__c, TrailPackage__Area_sqm__c 
                FROM TrailPackage__Unit__c
                WHERE TrailPackage__Bathroom__c =: leadList.TrailPackage__Bathroom__c 
                     OR TrailPackage__Bedroom__c =: leadList.TrailPackage__Bedroom__c];
            
            system.debug('Result Unit query list: ' + unitList);
        }
        
    	return unitList;
        
     }
        
    	@AuraEnabled
        public static void updateLeadSelectUnit(String recordId, String unitId){
            
           //Lead leadRec = new Lead();
           //Lead newLeadRec = new Lead(); 
           
            Lead leadRec = [SELECT Id, TrailPackage__Selected_Unit__c 
                       FROM Lead where Id =: recordId];
            
            system.debug('Existing Record' +  leadRec);
            leadRec.TrailPackage__Selected_Unit__c = unitId;
            system.debug('Update'  + leadRec );
            
            update leadRec;

        }
    
    	@AuraEnabled
        public static List<TrailPackage__Unit__c> searchAllUnit(Id recordId, String searchItem){
			   
            List<TrailPackage__Unit__c> unitList = new List<TrailPackage__Unit__c>();
            Lead leadList = new Lead();
            leadList= [SELECT id, Name, TrailPackage__Bathroom__c, TrailPackage__Bedroom__c, TrailPackage__Selected_Unit__c
                   from Lead
                   WHERE Id =: recordId ];
				system.debug('SearALl Checker'  + leadList );
            system.debug('searchItem'  + searchItem );
             if(searchItem != NULL){
                  system.debug('Pasok searchItem'  + searchItem );
                unitList = [SELECT Id, Name,TrailPackage__Price__c, TrailPackage__Property_Type__c, TrailPackage__Bathroom__c, 
                                    TrailPackage__Bedroom__c, TrailPackage__Area_sqm__c 
                                    FROM TrailPackage__Unit__c
                                    WHERE 
                            		TrailPackage__Property_Type__c =: searchItem];
                 
                 system.debug('Pasok unitList'  + unitList );
              }
                
             return unitList;
        }
}