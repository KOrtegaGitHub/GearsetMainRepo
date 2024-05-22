/**
@description - PopulateUltimateParentContactSchedulable
@author Kharla Haldos
@date  July 11, 2016
@history Kharla Haldos July 11, 2016 - addeed schedule setup for batch run
**/

global class PopulateUltimateParentContactSchedulable implements Schedulable {
    
    global void execute(SchedulableContext ctx)
    {
        Database.executeBatch(new PopulateUltimateParentContactBatchable(), 200);
    }
    
   

}