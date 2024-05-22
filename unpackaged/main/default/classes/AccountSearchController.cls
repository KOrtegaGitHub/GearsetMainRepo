/**
@description - AccountSearchController dynamic searching for Account Object
@author Kharla Haldos
@date  July 20, 2016
@history Kharla Haldos July 20, 2016 - AccountSearchController
                       July 25, 2016 - Update Controller added updated pagination using wrapper list
                       July 26, 2016 - Update Controller remove  applied  pagination usingwrapperlist
**/

public class AccountSearchController {

    // Variables for search text
    public String conNameStr {get;set;}
    public String accNameStr {get;set;}
    public String accCountryStr {get;set;}
    public Account accTypeStr {get;set;}
    //List of Objects
    public List<Account> accList {get;set;}
    public List<Contact> conList {get;set;}
    //Map for account to contact relationship thru Id
    public map <id, id> accIdToConId {get; set;}
    public map <id, string> accIdToConName {get; set;}

    public Map<Integer, List<sampleWrapper>>  newWrapMap = new Map<Integer, List<sampleWrapper>>();
    public Map<Integer, List<sampleWrapper>> newWrapperMap = new Map<Integer, List<sampleWrapper>>();
    //RenderedCondition
    public Boolean ShowDetails {get;set;}
    
    List<string> searchFilter= new List<string>();
    
    private integer totalRecords {get;set;}
    private integer offSetSize {get;set;}//keeps track of the offset
    private integer limitSize; //sets the page size or number of rows
    public Integer pageNum = 1;
    
    //wrapper class
    public class sampleWrapper{
        public string acctName {get; set;}
        public Id acctId {get; set;}
        public string billingcountry {get; set;}
        public string shippingcountry {get; set;}
        public string contactName {get; set;}
        public ID contactID {get; set;}
        public string type {get; set;}
        public Datetime createdyear {get; set;}
    }
    
    public List<sampleWrapper> swList {get; set;}
    public List<sampleWrapper> initSMwrapper {get; set;}
    //Instantiate use searched fields and list
    public AccountSearchController()
    {
        conNameStr = '';
        accNameStr ='';
        accCountryStr ='';
        accTypeStr = new Account();
        accList = new List<Account>();
        conList = new List<Contact>();
        swList = new List<sampleWrapper>();
        searchFilter= new List<string>();
        initSMwrapper = new List<sampleWrapper>();
    }
 
    public void findAcc(){//user clicked beginning
        totalRecords = 0;//Initial Total record set
        offSetSize =0;//Initial OffSetSize set
        swList = new List<sampleWrapper>();//Instantiate wrapper list upon clicking the find button
        initSMwrapper = new List<sampleWrapper>();
        accountSearch();//run the accoun search method
        
    }
    /**
    @description - accountSearch: A button action once te Search Criteria section filled out
    @author Kharla Haldos
    @date  July 20, 2016
    @history Kharla Haldos July 20, 2016 - accountSearch
    **/
    public void accountSearch(){
        
        searchFilter.clear(); //Clear the searchList
    
        //get values of limitsize set by Sysad in Custom Settings
        FilterFieldsSearch__c customSet = FilterFieldsSearch__c.getInstance(UserInfo.getUserId());
        if(customSet.accSearch_LimitSize__c !=NULL){//Assure retrieved values in custom setting always has values
            limitSize = integer.valueOf(customSet.accSearch_LimitSize__c);
        }

        //Checking if searchtext has a values if not it will throw an error  
        if(String.isEmpty(conNameStr) && String.isEmpty(accNameStr) && String.isEmpty(accCountryStr) && String.isEmpty(accTypeStr.Type)){
            
            ApexPages.addmessage( new ApexPages.message(ApexPages.Severity.Error,'Please provide a value for at least 1 of the available criteria.'));
            ShowDetails = false;
            
        }else{
        
            ShowDetails = true;
        }
        
        //Setup main query
         String strQuery = '';
         strQuery ='SELECT Id,Name,BillingCountry,ShippingCountry, CreatedDate, Type, (Select FirstName,LastName From Contacts) From Account';
         
         
        //Add where clause if there's a search for an account Name
        if(accNameStr !=null && accNameStr !='')
        {
           if(accNameStr.length() < 2)
           {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A minimum of 2 characters is required to search using the Account Name'));
                ShowDetails = false;
                
           }
           
           if(accNameStr.contains('*')){
               accNameStr = accNameStr.replace('*','%');
           }else{
               accNameStr = accNameStr;
           }
           
          searchFilter.add('Name Like \'' + accNameStr +'\'');
          accNameStr = accNameStr.replace('%','*');  
        } 
        
        //Add where clause if there's a search for an Country for both Billing and Shipping Country
        if(accCountryStr !=null && accCountryStr !='')
        {
            if(accCountryStr.contains('*')){
                accCountryStr = accCountryStr.replace('*','');
             }else{
                accCountryStr = accCountryStr;
             }
            searchFilter.add('(BillingCountry Like\'' + accCountryStr +'\' OR ShippingCountry Like\'' + accCountryStr +'\')');
        }
        
        //Add where clause if there's a search for account Type
        if(accTypeStr.Type != null && accTypeStr.Type != '')
        {
            searchFilter.add('Type Like\'' + accTypeStr.Type + '\' ');
        }
         
        //Add where clause if there's a search for ContactName
        
        if(conNameStr != null && conNameStr != '')
        {
           
            string con = ''+ conNameStr +'';
            conList = [select id, accountid, Name from contact where name like :con];

            
            Set<Id> AccountIds = new Set<Id>();

            if(!conList.isEmpty()){
                for(Contact c : conList){
                    AccountIds.add(c.AccountId);
                    }
               }
             
             if(!AccountIds.isEmpty()){
                 searchFilter.add('ID IN :AccountIds');
             }
        }
 
        //Actual concatenation of all search fields
        if (!searchFilter.isEmpty()) 
        {
            
            strQuery += ' WHERE ' + searchFilter[0]; 
            for (Integer i = 1; i < searchFilter.size(); i++){
                strQuery += ' OR ' + searchFilter[i];
             }
               
        }
       
        if(totalRecords !=null && totalRecords == 0)
            {
                List<Account> accTmpList= Database.query(strQuery);
                totalRecords = (accTmpList !=null && (!accTmpList.isEmpty())) ? accTmpList.size() : 0;
            }

        // add sort and limits at the end  
        strQuery += ' ORDER BY Name ASC ';//LIMIT :limitSize OFFSET :offSetSize
          
        try{  
            
           
                accList = Database.query(strQuery);//Database query for Account   
                
                system.debug('@@AccList'+ accList);
                List<contact> conToShow = new list<contact>();
                string conQuery = '';
                set<id> accIds = new Set<Id>();
              
              if(!accList.isEmpty()){
                    for(Account a : accList){
                        accIds.add(a.Id);
                    }
                    conQuery = 'Select id, name, accountId from contact where accountId In :accIds';

                    if(conNameStr <> null){

                        conNameStr = conNameStr.replace('*','');
                        if(conNameStr.length() > 0){
                           conQuery += ' OR name like \'' + conNameStr + '\'';
                        }
                   
                    }

                    conToShow = Database.query(conQuery);//Database query for Contact with relates to accounts
    
    
                     system.debug('@@conQuery' + conQuery); 
                     system.debug('@@conToShow' + conToShow); 
                     
                    //A Wrapper list for values of account and contact to be display
                    List<sampleWrapper> initSMwrapper = new List<sampleWrapper>();
                    Set<Id> accWithContacts = new Set<Id>();
                    if(!accList.isEmpty() && !conToShow.isEmpty()){
                        for(Account acc : accList){
                            for(Contact con : conToShow){
                                if(con.AccountId == acc.Id){
                                    sampleWrapper sw = new sampleWrapper();
                                        sw.acctName = acc.name;
                                        sw.acctId = acc.Id;
                                        sw.billingcountry = acc.BillingCountry;
                                        sw.shippingcountry = acc.ShippingCountry;
                                        sw.contactName = con.Name;
                                        sw.contactID = con.Id;
                                        sw.type = acc.Type;
                                        sw.createdyear = acc.CreatedDate;
                                        initSMwrapper.add(sw);
                                        accWithContacts.add(acc.Id);
                                }  
                           }
                            //added the account in the wrapperlist without contact related
                            if(!accWithContacts.contains(acc.Id)){
                                sampleWrapper sw = new sampleWrapper();
                                    sw.acctName = acc.name;
                                    sw.acctId = acc.Id;
                                    sw.billingcountry = acc.BillingCountry;
                                    sw.shippingcountry = acc.ShippingCountry;
                                    sw.contactName = NULL;
                                    sw.contactID = NULL;
                                    sw.type = acc.Type;
                                    sw.createdyear = acc.CreatedDate;
                                    initSMwrapper.add(sw);
                           
                                }
                        }
                        
                    }
                    else if(!accList.isEmpty() && conToShow.isEmpty()){//Added the account without a contact in a wrapper list
                        
                        for(Account acc : accList){
                            system.debug('@@ContactEmptyWithAcc' + accList);
                                sampleWrapper sw = new sampleWrapper();
                                    sw.acctName = acc.name;
                                    sw.acctId = acc.Id;
                                    sw.billingcountry = acc.BillingCountry;
                                    sw.shippingcountry = acc.ShippingCountry;
                                    sw.contactName = NULL;
                                    sw.contactID = NULL;
                                    sw.type = acc.Type;
                                    sw.createdyear = acc.CreatedDate;
                                    initSMwrapper.add(sw);
                                    
                        }
                    }
                    //system.debug('@@iniWrapper1' + initSMwrapper);
                    system.debug('@@iniWrapperSize' + initSMwrapper.size());
                    if(!initSMwrapper.isEmpty()){
                            
                            Integer pageInd = 1;
                            Integer loopChecker =1;
                            List<sampleWrapper> newWrapperList = new List<sampleWrapper>();

                            for(sampleWrapper smp : initSMwrapper){
                            //system.debug('SMPlist' + smp);
                            //system.debug('limitSize' + limitSize);
                                if(newWrapperList.size() < limitSize){
                                    //system.debug('Pasok' + smp);
                                    newWrapperList.add(smp);
                                    //system.debug('PasokAddToList' + newWrapperList);
                                }
                                
                                if(newWrapperList.size() == limitSize){
                                    //system.debug('Pasok2');
                                    newWrapperMap.put(pageInd,newWrapperList.clone());
                                    //system.debug('Pasok2Map' + newWrapperMap.get(pageInd));
                                    pageInd++;
                                    newWrapperList.clear();
                                    //system.debug('Pasok22Map' + newWrapperMap);
                                }   
                                
                                //system.debug('@@CheckerPasok3_' + loopChecker + '__' +initSMwrapper.size());
                                if(loopChecker == initSMwrapper.size()){
                                    //system.debug('Pasok3');
                                    if(!newWrapperList.isEmpty())
                                    newWrapperMap.put(pageInd,newWrapperList.clone());
                                    //system.debug('Pasok3Map'+ pageInd + '_' + newWrapperMap.get(pageInd));
                                    newWrapperList.clear(); 
                                } 
                                          
                                loopChecker++;
                 
                            }
                      
                        swList = newWrapperMap.get(1);
                        system.debug('@@swList' + swList.size());
                        //swList = pageMapping(initSMwrapper).get(1);
                        //system.debug('@@Test1' + pageMapping(initSMwrapper));
                        //pageMapping pageMap = new pageMapping(initSMwrapper);
                        //swList =  pageMap.get(1);
                    } 
 
                }
                
           
            
        //Catch where the unexpected error in the query occurs and show it in a Error Message.
        }catch(QueryException e){
                //ApexPages.addMessages(e);  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Query Exception: ' + e.getMessage()));      
        }
    

        
     }
            
        public void firstPage(){//user clicked beginning
            swList = newWrapperMap.get(1);
        }
        
        public void previousPage(){//user clicked previous button
            pageNum--;
            swList = newWrapperMap.get(pageNum);
        }
        
        public void nextPage(){//user clicked next button
            pageNum++;
            swList =newWrapperMap.get(pageNum);
        }
        
        public void lastPage(){//user clicked end
            swList = newWrapperMap.get(newWrapperMap.size());  
        }
        
        public Boolean getDisabledPrevious(){
        
            //this will disable the previous and beginning buttons
            boolean res =  pageNum == 1 ? true : false;
    
            return res;
        }
        
        public Boolean getDisableNext() { //this will disable the next and end buttons
            
            boolean res2 = (pageNum == newWrapperMap.size()) ? true :  false;

            return res2;
       }
       
         /*//Method for PageFilter
          public Map<Integer, List<sampleWrapper>> pageMapping(List<sampleWrapper> smpWrp){
                
                Integer pageInd = 1;
                Integer loopChecker =1;
                List<sampleWrapper> newWrapperList = new List<sampleWrapper>();
               
                for(sampleWrapper smp : smpWrp){
                  //system.debug('SMPlist' + smp);
                  //system.debug('limitSize' + limitSize);
                  if(newWrapperList.size() < limitSize){
                      //system.debug('Pasok' + smp);
                      newWrapperList.add(smp);
                      //system.debug('PasokAddToList' + newWrapperList);
                  }
                                
                  if(newWrapperList.size() == limitSize){
                      //system.debug('Pasok2');
                      newWrapperMap.put(pageInd,smpWrp.clone());
                      //system.debug('Pasok2Map' + newWrapperMap.get(pageInd));
                      pageInd++;
                      newWrapperList.clear();
                      system.debug('Pasok22Map' + newWrapperMap);
                  }   
                                
                  //system.debug('@@CheckerPasok3_' + loopChecker + '__' +initSMwrapper.size());
                      if(loopChecker == smpWrp.size()){
                      //system.debug('Pasok3');
                      newWrapperMap.put(pageInd,newWrapperList.clone());
                      //system.debug('Pasok3Map'+ pageInd + '_' + newWrapperMap.get(pageInd));
                   } 
                                          
                 loopChecker++;
                 
               }
                 return newWrapperMap;
                
            }*/
}