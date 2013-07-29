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


global class ProcessSalsaData implements Database.Batchable<sObject> {
    
    public String datatype;
    public String nextdatatype;
    public String query;
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
    
    List<Salsa_Data_Import__c> sdtoprocess = (List<Salsa_Data_Import__c>)scope;
    
    if (datatype == 'Supporters') {
    processSalsaSupporters pss = new processSalsaSupporters();
    pss.executeMatch(sdtoprocess);
    }   

    else if (datatype == 'Donations') {
    //Salsa_UpdateDistricts icSS = new Salsa_UpdateDistricts();
    //icSS.executeMatch(sdtoprocess);
    }

    }
    
    global void finish(Database.BatchableContext BC) {
    
    /*
    if (nextdatatype == 'Donations') {
    ProcessSalsaData psd = new ProcessSalsaData();
    psd.query =  ' Select Id, Supporter_Key__c, Last_Name__c,'+
                 ' District_Type__c,District_Code__c'+
                 ' FROM Salsa_Data_Import__c '+
                 ' WHERE Data_Type__c = \'Districts\' '+
                 ' AND Status__c =\'Requires Processing\' ';
    psd.datatype = 'Districts';
    psd.nextdatatype = 'Actions';
    if (!test.IsRunningTest()) {
        database.executebatch(psd); 
    }        
    }
    */

    //Else finish

    }
    
}