/**
 * Copyright (c) 2013, Bridge Farm Consulting Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/


public class Utilities_bfc {

public Static Id IndividualAccountId;

public static String formatphonenumber(String cphone) {
String fphone = cphone.replaceAll('\\D','');

if (fphone.length() == 10) {
fphone = formatphonenum(fphone);
return fphone;
}
else {
return cphone;
}

}

static String formatphonenum (String s) {
s = '(' + s.substring(0, 3) + ') ' + s.substring(3, 6) + '-' + s.substring(6);
return s;
}

public static Boolean checkEmail (String semail) { 
//With reference to this blog post
//http://salesforcesource.blogspot.com/2010/01/utilizing-apex-pattern-and-matcher.html  
String InputString = semail;
String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
Pattern MyPattern = Pattern.compile(emailRegex);

// Then instantiate a new Matcher object "MyMatcher"
Matcher MyMatcher = MyPattern.matcher(InputString);

if (!MyMatcher.matches()) {
return FALSE;
}
else {
return TRUE;
}

} //end email check


public static Contact setupNewContact(Salsa_Data_Import__c s) {

Contact c = new Contact();
	c.AccountId = Utilities_bfc.getIndividualAccountId(s.Data_Type__c);
	c.Salsa_Supporter_Id__c = s.Supporter_Key__c;
	c.lastname = s.Last_Name__c;
	c.firstname = s.First_Name__c;
	c.email= s.Validated_Email__c; 
	c.phone= s.Phone__c;
	c.MailingStreet= s.Street__c;
	c.MailingCity= s.City__c;
	c.MailingState=s.State__c;
	c.MailingPostalCode = s.Postal_Code__c;

return c;
}

public static Id getIndividualAccountId (String sSettings) {

if (IndividualAccountId == null) {

salsa_import_settings__c ss = salsa_import_settings__c.getInstance(sSettings);
String sName = ss.Default_Account_Name__c;

	Account [] accounts = [Select Id, Name from Account WHERE Name = :sName];
	if (accounts.size() > 0) {
		IndividualAccountId = accounts[0].Id;
	}
	else {
		Account a = new Account (Name = sName);
		insert a;
		IndividualAccountId = a.Id;	
		}

}
return IndividualAccountId;
}


}  //end class;