/* With reference to Steve Andersen's post: http://gokubi.com/archives/two-interesting-ways-to-architect-apex-triggers */
 
trigger ManageSalsaImports on Salsa_Data_Import__c (before insert, before update) { 

    if(Trigger.isInsert && Trigger.isBefore){
        ManageSalsaImports.beforeInsert(Trigger.New); 
        }     
}