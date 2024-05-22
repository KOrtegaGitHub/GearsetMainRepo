/**
@trigger : Contact Trigger
@Description : Make sure no logic with it and all logic will be handle by related Handler
@created by : Kharla Haldos
@created date: 07/06/2016
**/

trigger ContactTrigger on Contact (before insert, after update) {

    ContactTriggerHandler trigHandler = new ContactTriggerHandler();

    if(trigger.IsBefore && trigger.IsInsert){
        trigHandler.onBeforeInsert(trigger.new);
    }
    
    if(trigger.isAfter && trigger.IsUpdate){
        trigHandler.onAfterUpdate(trigger.new, trigger.old);
    
    }
}