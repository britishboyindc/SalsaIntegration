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


global class importSalsaReports {
//importSalsaReports.salsaDataImport();
@future(callout=true)
public static void salsaDataImport (String sSettings) {
String DIAXML;
string sdatatype;
Integer totalrecords = 0;

//if running test, populate custom settings
salsa_integration__c si = salsa_integration__c.getInstance();
salsa_import_settings__c ss = salsa_import_settings__c.getInstance(sSettings);


if (!test.isrunningtest()) {
Web_Callouts_bfc b = new Web_Callouts_bfc();
DIAXML = b.webdiacalloutresponse ('GET', si.Login_URL__c, ss.Report_URL__c);
}

else {
//SalsaData_TEST.setTestSalsaSupporterDIAXML();
//Test_CallOutTesterXML_bfc d = new Test_CallOutTesterXML_bfc();
//DIAXML = d.webdiacalloutresponse ('GET', si.Login_URL__c, ss.Report_URL__c);
}

       Dom.Document docx = new Dom.Document();
       docx.load(DIAXML);

       dom.XmlNode diaroot = docx.getrootelement() ;
       dom.XmlNode xr = diaroot.getchildelement('report', null) ;
       dom.XmlNode [] diarows = xr.getchildelements() ;

        List<Salsa_Data_Import__c> dial = new List<Salsa_Data_Import__c > ();

       Map<String,salsa_import_map__c> salsamap = salsa_import_map__c.getall();
      
        for(Dom.XMLNode childrows : diarows) {
                
                Salsa_Data_Import__c salsarecord = new Salsa_Data_Import__c();
                sObject diar = salsarecord;
                
                totalrecords ++;
               
                dom.XmlNode [] diarecords = childrows.getchildelements() ;
                    for(Dom.XMLNode child : diarecords ) {
                
                           if (child.getName() != null) {
                                  String sText = child.getName();
                                  
                                   if (salsamap.containskey(sText) ) {
                                   
                                       if (salsamap.get(sText).Data_Type__c != 'String') {
                                           if (salsamap.get(sText).Data_Type__c == 'Decimal') {    
                                                   diar.put(salsamap.get(sText).Salsa_Import_Field__c, decimal.valueof(child.getText()) );
                                                   }
                                           else if (salsamap.get(sText).Data_Type__c == 'Boolean') {    
                                                   if (child.getText() == 'true') {
                                                   diar.put(salsamap.get(sText).Salsa_Import_Field__c, TRUE) ;
                                                   }
                                                  }
                                           
                                                }   
                                       else { 
                                             diar.put(salsamap.get(sText).Salsa_Import_Field__c, child.getText()) ;
                                       }
                                   
                                   } //end map key check
                                                   
                               } //end child name check
                            
                             } //end record loop
                              diar.put('Data_Type__c', ss.Data_Type__c);
                              dial.add( (Salsa_Data_Import__c)diar ); 
                            } //end rows
    try {
        upsert dial DIA_Key__c;    
    } catch (DmlException e) {
        System.debug(e.getMessage());
    }
    } //end import


} //end class