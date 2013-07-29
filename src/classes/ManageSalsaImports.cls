public with sharing class ManageSalsaImports {

public static void beforeInsert(Salsa_Data_Import__c[] newrecords) {

for (Salsa_Data_Import__c sdi: newrecords) {
    if (sdi.Entered_Email__c != null) {

            if (Utilities_BFC.checkEmail(sdi.Entered_Email__c) ) {
                    sdi.Validated_Email__c = sdi.Entered_Email__c;    
            }
            else {
                    sdi.Error_Code__c = 'Bad Email';
            }
    } //end email check

    if (sdi.Phone__c != null) {
            sdi.Phone__c = Utilities_bfc.formatphonenumber(sdi.Phone__c);
    }

} //end loop    

} //end method

} //end class