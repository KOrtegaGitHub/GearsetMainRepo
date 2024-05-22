global without sharing class AccountDetails

{

 public String results { get; set; }

 public String filterid { get; set; }

 public String fetchRecords { get; set; }

 public String PageSize { get; set; }

 public List<Account> accts = new List<Account>();

 public List<Contact> listContacts {get;set;}

 public List<Case> listCases {get;set;}

 public List<Opportunity> listOpptys {get;set;}

 public String selectedAcctId {get;set;}



 public AccountDetails()

 {

  

 }

  

 public List<SelectOption> AccountList

 {

     get

     {

         accts = [Select u.name, u.Id From Account u];

          

         AccountList = new List<SelectOption>();

          

         for(Account tempacct: accts)

         {

             AccountList.add(new SelectOption(tempacct.Id, tempacct.Name));

         }

         return AccountList;

     }

     set;

 }

 @RemoteAction

 global static String fetchRecords() {

     return 'done';

 }   

}