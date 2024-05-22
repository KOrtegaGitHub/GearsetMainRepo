trigger HelloWorldTrigger on Account (before insert) {
	System.debug('Hello World Account!' );
    
    for(Account accLoop :  Trigger.New){
        accLoop.Description ='new description';
    }
    System.debug('@@With new Description:' + Trigger.New);
}