public with sharing class processSalsaSupporters {

public map<Id,Contact> MatchedContactRecords {get;set;}

public void executeMatch(List<Salsa_Data_Import__c> slisttomatch) {

MatchedContactRecords  = new Map<Id, Contact> ();

Map<String, Salsa_Data_Import__c> EmailList = new Map<String, Salsa_Data_Import__c> ();
Map<String, Salsa_Data_Import__c> SupporterIds = new Map<String, Salsa_Data_Import__c> ();
Map<String, Salsa_Data_Import__c> SalsaKeyMap = new Map<String, Salsa_Data_Import__c> ();
List<Salsa_Data_Import__c> SuccessfulUpdates = new List<Salsa_Data_Import__c> ();

Set<String> MatchedSupporters = new Set<String> ();


for (Salsa_Data_Import__c s: slisttomatch) {

            SalsaKeyMap.put(s.Supporter_Key__c, s);

            if (s.Validated_Email__c != null) {
            EmailList.put(s.Validated_Email__c, s);
            }

            if (s.Supporter_Key__c != null) {
            SupporterIds.put(s.Supporter_Key__c, s);
            }

}

for (Contact c: [
                Select Id, LastName, FirstName,Email, Salsa_Supporter_Id__c, 
                Phone, MailingStreet, MailingCity, MailingState, MailingPostalCode 
                FROM Contact 
                WHERE 
                    (Email IN : EmailList.keyset() OR
                    Salsa_Supporter_Id__c IN :SupporterIds.keyset())
                    ORDER By CreatedDate ASC]) {

                if (c.Salsa_Supporter_Id__c != null) {

                    if (SupporterIds.containskey(c.Salsa_Supporter_Id__c)) {
                        MatchedContactRecords.put(SupporterIds.get(c.Salsa_Supporter_Id__c).Id, c);
                        MatchedSupporters.add(c.Salsa_Supporter_Id__c);
                    continue;
                    }

                }

                if (c.Email != null) {

                    if (EmailList.containskey(c.Email)) {
                            //only add if currently no match
                            if (!MatchedContactRecords.containskey(EmailList.get(c.Email).Id)) {  
                             Salsa_Data_Import__c simport = EmailList.get(c.Email);
                             if (c.Salsa_Supporter_Id__c == null && simport.Supporter_Key__c != null) {
                                    c.Salsa_Supporter_Id__c = simport.Supporter_Key__c;
                                }
                                MatchedContactRecords.put(EmailList.get(c.Email).Id, c);
                                MatchedSupporters.add(simport.Supporter_Key__c);
                            continue;
                            }
                        }
                }


}//end contact loop

List<Contact> newContactsforcreation = new List<Contact> ();
 for (Salsa_Data_Import__c s: slisttomatch) {
        if (!MatchedSupporters.contains(s.Supporter_Key__c)) {//need to create it
            newContactsforcreation.add(Utilities_bfc.setupNewContact(s));
        }
    }

    try{
        Salsa_Data_Import__c su;

        if (newContactsforcreation.size() > 0) {
            insert newContactsforcreation;
            for (Contact c: newContactsforcreation) {
                    su =  SalsaKeyMap.get(c.Salsa_Supporter_Id__c);      
                    su.Processed_Date__c = system.today();
                    su.Status__c = 'Processed';
                    SuccessfulUpdates.add(su);
            }
        }

        update MatchedContactRecords.values();
        for (Contact c: MatchedContactRecords.values()) {
                    su=  SalsaKeyMap.get(c.Salsa_Supporter_Id__c);      
                    su.Processed_Date__c = system.today();
                    su.Status__c = 'Processed';
                    SuccessfulUpdates.add(su);
        }

    }

    catch (Exception Ex) {
    system.debug('Update Process Failed' + ex.getmessage());
    }

    update SuccessfulUpdates;

} //end processing


}