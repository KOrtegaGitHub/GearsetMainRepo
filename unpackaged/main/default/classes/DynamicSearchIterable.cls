global class  DynamicSearchIterable implements Iterator<list<AccountSearchController>>{

       list<AccountSearchController> swList {get; set;}
       list<AccountSearchController> ListRequested{get; set;}
    
       Integer i {get; set;} 
       public Integer setPageSize {get; set;} 
    
       public DynamicSearchIterable(List<AccountSearchController> lstAccWr)
       {
           swList = new list<AccountSearchController>(); 
           ListRequested = new list<AccountSearchController>();     
           swList = lstAccWr;
           setPageSize = 10;
           i = 0; 
       }   
    
       global boolean hasNext(){ 
           if(i >= swList.size()) {
               return false; 
           } else {
               return true; 
           }
       } 
       
       global boolean hasPrevious(){ 
           system.debug('I am in hasPrevious' + i);
           if(i <= setPageSize) {
               return false; 
           } else {
               return true; 
           }
       }   
    
       global list<AccountSearchController> next(){       
           system.debug('i value is ' + i);
           ListRequested = new list<AccountSearchController>(); 
           integer startNumber;
           integer size = swList.size();
           if(hasNext())
           {  
               if(size <= (i + setPageSize))
               {
                   startNumber = i;
                   i = size;
               }
               else
               {
                   i = (i + setPageSize);
                   startNumber = (i - setPageSize);
               }
               
               system.debug('i value is =====' + i);
               system.debug('i value is 2==== ' + (i - setPageSize));
               
               for(integer start = startNumber; start < i; start++)
               {
                   ListRequested.add(swList[start]);
               }
           } 
           return ListRequested;
       } 
       
       global list<AccountSearchController> previous(){      
           ListRequested = new list<AccountSearchController>(); 
           system.debug('i value is previous before =====' + i);
           integer size = swList.size(); 
           if(i == size)
           {
               if(math.mod(size, setPageSize) > 0)
               {    
                   i = size - math.mod(size, setPageSize);
               }
               else
               {
                   i = (size - setPageSize);
               } 
           }
           else
           {
               i = (i - setPageSize);
           }
           
           system.debug('i value is previous =====' + i);
           system.debug('i value is 2previous ==== ' + (i - setPageSize));
           
           for(integer start = (i - setPageSize); start < i; ++start)
           {
               ListRequested.add(swList[start]);
           } 
           return ListRequested;
       }   

}