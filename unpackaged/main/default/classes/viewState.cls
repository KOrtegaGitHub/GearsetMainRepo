public class viewState {

    
    public List<StaticResource> getHowToSearch {get;set;}
    
     public list<StaticResource>  getDocs()
     {
       getHowToSearch  = [Select body, name from StaticResource where Name = 'HowToSearch'];
    
        return getHowToSearch;
     } 

}