public with sharing class AcordXMLHelper {
    
    String acordStandardsURI = 'http://ACORD.org/Standards/Life/2';
    Opportunity opp;
    XmlStreamWriter xml;

    Map<String,String> planCodeMap = new Map<String,String>{
        'Plan A'=>'FE0100'
        ,'Plan B'=>'FE0200'
        ,'Child Rider'=>'CR00FE'
    };

    Map<String,String> paymentCodeMap = new Map<String,String>{
        'Monthly'=>'4'
        ,'Bi-Weekly'=>'7'
    };

    Map<String,String> paymentMethodMap = new Map<String,String>{
        'EFT'=>'7'
    };    

    Map<String,String> genderMap = new Map<String,String>{
        'Male'=>'1'
        ,'Female'=>'2'
    };

    Map<String,String> acctTypeMap = new Map<String,String>{
        'Checking'=>'1'
        ,'Savings'=>'2'
        ,'Credit Card'=>'3'
    };

    Map<String,String> phoneTypeMap = new Map<String,String>{
        'Home'=>'1'
        ,'Business'=>'2'
        ,'Cell'=>'12'
    };

    Map<String,String> prefCommMap = new Map<String,String>{
        'Home Phone'=>'1'
        ,'Business Phone'=>'2'
        ,'eMail'=>'3'
        ,'Regular Mail'=>'4'
        ,'Do Not Contact'=>'5'
        ,'Cell Phone'=>'1999900001'
    };

    Map<String,String> relationCodeMap = new Map<String,String>{
        'Child'=>'1999900003'
        ,'Domestic Partner'=>'1999900006'
        ,'Ex-Spouse'=>'9'
        ,'Parent'=>'1999900014'
        ,'Self'=>'91'
        ,'Spouse'=>'1999900016'
        ,'Other'=>'2147483647'
    };

    List<Policy_Participants__c> participants = new List<Policy_Participants__c>();
    Map<String,State__c> stateMap;

    public AcordXMLHelper(Opportunity opp, List<PolicyParticipantWrapper> participantWrappers) {
        this.opp = opp;
        
        for(PolicyParticipantWrapper parWrapper : participantWrappers){
            participants.add(parWrapper.par);
        }

        xml = new XmlStreamWriter();

        stateMap = new Map<String,State__c>();

        for(State__c state : [SELECT Id
                ,Acord_Number_tc__c
                ,Census_Division_Name__c
                ,Census_Region_Name__c
                ,Country__c
                ,State_Abbreviation__c
                ,State_Id__c
                ,State_Name__c
                ,Type__c
                FROM State__c
                WHERE Active__c = true]){
            stateMap.put(state.State_Abbreviation__c,state);
        }
    }

    public String getXml(){
        write();
        return xml.getXmlString();
    }

    public XmlStreamWriter write(){
        xml.writeStartDocument('utf-8','1.0');
            
            /*
            <soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' 
            xmlns:soapenc='http://schemas.xmlsoap.org/soap/encoding' 
            xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' 
            xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
            */
            startElementWithAttributes('soapenv:Envelope',null,new Map<String,String>{'xmlns:soapenv'=>'http://schemas.xmlsoap.org/soap/envelope/'
                                                                                    ,'xmlns:web'=>'http://schema/webservices.elink.solcorp.com'
                                                                                    ,'xmlns:xsi'=>'http://www.w3.org/2001/XMLSchema-instance'
                                                                                    ,'xmlns:xsd'=>'http://www.w3.org/2001/XMLSchema'});
                //<soapenv:Body>
                xml.writeStartElement(null,'soapenv:Body',null);
                    
                    //<callTXLifeRequest xmlns='http://schema/webservices.elink.solcorp.com'><![CDATA[

                    startElementWithAttributes('callTXLifeRequest',null,new Map<String,String>{'xmlns'=>'http://schema/webservices.elink.solcorp.com'});
                        
                        xml.writeStartElement(null,'CDATA',null);

                        //<TXLife xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">   
                        startElementWithAttributes('TXLife',null,new Map<String,String>{'xmlns:xsi'=>'http://www.w3.org/2001/XMLSchema-instance',
                                                                                            'xmlns:xsd'=>'http://www.w3.org/2001/XMLSchema'});
                        writeAuth();
                        writebody();
                        xml.writeEndElement(); //Close TXLife element

                        xml.writeEndElement(); //Close CDATA

                    xml.writeEndElement(); //Close CallTxLifeRequest
                xml.writeEndElement(); //Close Soap body
            xml.writeEndElement(); //Close Soap envelope
        xml.writeEndDocument(); //Close XML document
        return xml;
    }

    public XmlStreamWriter writeAuth(){
        /*  <UserAuthRequest xmlns="http://ACORD.org/Standards/Life/2">
                <UserLoginName>TXLIFEGL</UserLoginName>
                    <UserPswd>
                        <CryptType>NONE</CryptType>
                        <Pswd>TXGLD916</Pswd>
                    </UserPswd>
            </UserAuthRequest>
        */  
        xml.writeStartElement(null,'UserAuthRequest',null);
        xml.writeAttribute(null,null,'xmlns',acordStandardsURI);
                //***SBLI UserName***
            xml.writeStartElement(null,'UserLoginName',null);
                xml.writeCharacters('TXLIFEGL');
            xml.writeEndElement(); //Close UserLoginName
            xml.writeStartElement(null,'UserPswd',null);
                xml.writeStartElement(null,'CryptType',null);
                    xml.writeCharacters('NONE');
                xml.writeEndElement();//Close CryptType
                xml.writeStartElement(null,'Pswd',null);
                    //***SBLI Password***
                    xml.writeCharacters('TXGLD916');
                xml.writeEndElement();//Close CryptType
            xml.writeEndElement(); //Close UserPswd
        xml.writeEndElement(); //Close UserAuthRequest
        return xml;
    }

    public XmlStreamWriter writeBody(){
        //<TXLifeRequest xmlns="http://ACORD.org/Standards/Life/2">
        startElementWithAttributes('TXLifeRequest',null,new Map<String,String>{'xmlns'=>acordStandardsURI});
        //<TransRefGUID>12345670</TransRefGUID>
            addSingleElement('TransRefGUID',opp.Tracking_Id__c);
            //<TransType tc="103" />
            startElementWithAttributes('TransType',null,new Map<String,String>{'tc'=>'103'});
            xml.writeEndElement(); //Close TransType

            //<OLifE>
            xml.writeStartElement(null,'OLifE',null);
                /*
                <SourceInfo>
                    <CreationDate>2011-06-23</CreationDate>
                    <CreationTime>13:01:06.4473751-04:00</CreationTime>
                    <SourceInfoName>GLD</SourceInfoName>
                </SourceInfo>
                */
                xml.writeStartElement(null,'SourceInfo',null);                
                    addSingleElement('CreationDate',formatDate(date.today()));
                    addSingleElement('CreationTime',formatDateTime(DateTime.now()));
                    addSingleElement('SourceInfoName','GLD');
                xml.writeEndElement(); // close SourceInfo

                //<Holding id="Holding_1">
                startElementWithAttributes('Holding',null,new Map<String,String>{'id'=>'Holding_1'});
                    
                    //<HoldingSysKey SystemCode="12345670" />
                    startElementWithAttributes('HoldingSysKey',null,new Map<String,String>{'SystemCode'=>opp.Tracking_Id__c});
                    
                    //<HoldingTypeCode tc="2" />
                    startElementWithAttributes('HoldingTypeCode',null,new Map<String,String>{'tc'=>'2'});
                    xml.writeEndElement();

                    //<HoldingStatus tc="3" />
                    startElementWithAttributes('HoldingStatus',null,new Map<String,String>{'tc'=>'3'});
                    xml.writeEndElement();

                    //<Purpose tc="31"></Purpose>
                    startElementWithAttributes('Purpose',null,new Map<String,String>{'tc'=>'31'});
                    xml.writeEndElement(); //Close Purpose

                    writePolicy();
                
                xml.writeEndElement(); //Close Holding

                writeParties();
                //writeAttachment();
                writeRelations();

            xml.writeEndElement(); // close OLifE

        xml.writeEndElement(); //Close TXLifeRequest
        return xml;
    }

    public XMLStreamWriter writePolicy(){
        //<Policy>
        xml.writeStartElement(null,'Policy',null);
            //<LineOfBusiness tc="1" />
            startElementWithAttributes('LineOfBusiness',null,new Map<String,String>{'tc'=>'1'});
            xml.writeEndElement();

            //<ProductCode>FE0100</ProductCode>
            addSingleElement('ProductCode',planCodeMap.get(opp.ProductCode__c));

            //<CarrierCode>SBLI</CarrierCode>
            addSingleElement('CarrierCode','SBLI');

            //<PlanName>FE0100</PlanName>
            addSingleElement('PlanName',planCodeMap.get(opp.ProductCode__c));

            //<PolicyStatus tc="1" />
            startElementWithAttributes('PolicyStatus',null,new Map<String,String>{'tc'=>'1'});
            xml.writeEndElement();

            //<IssueType tc="2" />
            startElementWithAttributes('IssueType',null,new Map<String,String>{'tc'=>'2'});
            xml.writeEndElement();

            //<Jurisdiction tc="26">Massachusetts</Jurisdiction>
            startElementWithAttributes('Jurisdiction',stateMap.get(opp.Account.BillingStateCode).State_Name__c,new Map<String,String>{'tc'=>String.valueOf(stateMap.get(opp.Account.BillingStateCode).Acord_Number_tc__c)});
            xml.writeEndElement();

            for(Policy_Participants__c par : participants){
                if(par.Role__c == 'Payor'){
                    // <PaymentMode tc="4">Monthly</PaymentMode>
                    startElementWithAttributes('PaymentMode','Monthly',new Map<String,String>{'tc'=>paymentCodeMap.get('Monthly')});
                    xml.writeEndElement();
                    //<PaymentMethod tc="7">EFT</PaymentMethod>  
                    startElementWithAttributes('PaymentMethod',par.Account__r.Payment_Method__c,new Map<String,String>{'tc'=>paymentMethodMap.get(par.Account__r.Payment_Method__c)});
                    xml.writeEndElement();
                    //<AccountNumber>9876543210</AccountNumber>  
                    addSingleElement('AccountNumber',par.Account__r.Bank_Account_Number__c);
                    //<RoutingNumber>555555555</RoutingNumber> 
                    addSingleElement('RoutingNumber',par.Account__r.Bank_Routing_Number__c);
                    //<AcctHolderName>John T. MoneyMan</AcctHolderName> 
                    String fullName = par.Account__r.FirstName + ' ' + par.Account__r.MiddleName + ' ' + par.Account__r.LastName;
                    addSingleElement('AcctHolderName',fullName);
                    //<BankAcctType tc="2">Checking</BankAcctType> 
                    startElementWithAttributes('BankAcctType',par.Account__r.Bank_Account_Type__c,new Map<String,String>{'tc'=>acctTypeMap.get(par.Account__r.Bank_Account_Type__c)});
                    xml.writeEndElement();
                     //<PaymentDraftDay>27</PaymentDraftDay> 
                    addSingleElement('PaymentDraftDay',String.valueOf(par.Account__r.Payment_Draft_Day__c));
                    //<BankName>The Piggy Bank</BankName> 
                    addSingleElement('BankName',par.Account__r.Bank_Name__c);
                }
            }
            writeLife();
            writeApplicationInfo();

        xml.writeEndElement();//Close Policy

        return xml;
    }

    public XMLStreamWriter writeLife(){
        
        //<Life>
        xml.writeStartElement(null,'Life',null);

            //<FaceAmt>20000.00</FaceAmt>
            addSingleElement('FaceAmt',String.valueOf(opp.Initial_Coverage_Amount__c));

            

            Double coverageIdCount = .01;
            Boolean hasChildRider = false;
            for(Policy_Participants__c par : participants){
                
                //<Coverage id="CVG_01">
                    if(par.Role__c=='Primary Insured'){
                    //<PlanName>FE0100//</PlanName>
                    //<ProductCode>FE0100//</ProductCode>
                    //<LifeCovTypeCode tc="28" />
                    //<IndicatorCode tc="1" />
                        String coverageId = 'CVG_' + String.valueOf(coverageIdCount).right(2);
                        startElementWithAttributes('Coverage',null,new Map<String,String>{'id'=>coverageId});
                            addSingleElement('PlanName',planCodeMap.get(opp.ProductCode__c));
                            addSingleElement('ProductCode',planCodeMap.get(opp.ProductCode__c));
                            startElementWithAttributes('LifeCovTypeCode',null,new Map<String,String>{'tc'=>'28'});
                            xml.writeEndElement();
                            startElementWithAttributes('IndicatorCode',null,new Map<String,String>{'tc'=>'1'});
                            xml.writeEndElement();
                            //<InitCovAmt>200000.00//</InitCovAmt>
                            addSingleElement('InitCovAmt',String.valueOf(opp.Initial_Coverage_Amount__c));
                            //<LifeParticipant PartyID="Party_Ins">
                                //<LifeParticipantRoleCode tc="1" />
                                //<IssueAge>49//</IssueAge>
                                //<IssueGender tc="1" />
                            //</LifeParticipant>
                            startElementWithAttributes('LifeParticipant',null,new Map<String,String>{'PartyID'=>'Party_Ins'});
                                startElementWithAttributes('LifeParticipantRoleCode',null,new Map<String,String>{'tc'=>'1'});
                                xml.writeEndElement(); //Close LifeParticipantRoleCode        
                                addSingleElement('IssueAge',String.valueOf(par.Account__r.Age__c));
                                startElementWithAttributes('IssueGender',null,new Map<String,String>{'tc'=>genderMap.get(par.Account__r.Gender__c)});
                                xml.writeEndElement();
                            xml.writeEndElement(); //Close LifeParticipant
                        xml.writeEndElement(); // Close Coverage
                        coverageIdCount += .01;
                    }else if(par.Role__c=='Child' && hasChildRider == false){
                        //<Coverage id="CVG_02">
                            //<PlanName>CR00FE//</PlanName>
                            //<ProductCode>CR00FE//</ProductCode>
                            //<LifeCovTypeCode tc="116">Child Rider//</LifeCovTypeCode>
                            //<IndicatorCode tc="2">Rider//</IndicatorCode>
                            //<InitCovAmt>5000.00//</InitCovAmt>
                        //</Coverage>
                        String coverageId = 'CVG_' + String.valueOf(coverageIdCount).right(2);
                        startElementWithAttributes('Coverage',null,new Map<String,String>{'id'=>coverageId});
                            addSingleElement('PlanName',planCodeMap.get('Child Rider'));
                            addSingleElement('ProductCode',planCodeMap.get('Child Rider'));
                            startElementWithAttributes('LifeCovTypeCode','Child Rider',new Map<String,String>{'tc'=>'116'});
                            xml.writeEndElement();
                            startElementWithAttributes('IndicatorCode','Rider',new Map<String,String>{'tc'=>'2'});
                            xml.writeEndElement();
                            addSingleElement('InitCovAmt',String.ValueOf(opp.Child_Rider_Cover_Amount__c));
                        xml.writeEndElement(); // Close Coverage
                        coverageIdCount += .01;
                        hasChildRider = true;
                    }
            }  
        //</Coverage>   
        xml.writeEndElement(); // End Life       
        return xml;
    }
        
    
    public XMLStreamWriter writeApplicationInfo(){
        /*          
              <ApplicationInfo>
                <TrackingID>12345670</TrackingID>
                <ApplicationType tc="1" />
                <ApplicationJurisdiction tc="26">Massachusetts</ApplicationJurisdiction>
                <FormalAppInd tc="1" />
                <SignedDate>2011-06-27</SignedDate>
                <ReqPolicyDeliveryMethod tc="“2147483647”"/>
                <OLifEExtension VendorCode="SBLI_AppInfo">
                    <InflationFighter tc="0">No</InflationFighter>
                </OLifEExtension>           
              </ApplicationInfo>
                
            */
                xml.writeStartElement(null,'ApplicationInfo',null);
                    //***this needs to be from some custom field that isn't made yet.
                    addSingleElement('TrackingID',opp.Tracking_Id__c);
                    startElementWithAttributes('ApplicationType',null,new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                    startElementWithAttributes('ApplicationJurisdiction',stateMap.get(opp.Account.BillingStateCode).State_Name__c,new Map<String,String>{'tc'=>String.valueOf(stateMap.get(opp.Account.BillingStateCode).Acord_Number_tc__c)});
                    xml.writeEndElement();
                    startElementWithAttributes('FormalAppInd',null,new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                    addSingleElement('SignedDate',formatDate(date.today()));
                    startElementWithAttributes('ReqPolicyDeliveryMethod',null,new Map<String,String>{'tc'=>'2147483647'});
                    xml.writeEndElement();
                    startElementWithAttributes('OLifEExtension',null,new Map<String,String>{'VendorCode'=>'SBLI_AppInfo'});
                        String inflationFighterString = opp.Inflation_Fighter__c == true ? 'Yes' : 'No';
                        String inflationFighterCode = opp.Inflation_Fighter__c == true ? '1' : '0';
                        startelementwithAttributes('InflationFighter',inflationFighterString,new Map<String,String>{'tc'=>inflationFighterCode});
                        xml.writeEndElement();
                    xml.writeEndElement(); //close OLifEExtension
                xml.writeEndElement(); // close ApplicationInfo
            return xml;
        }

    public XMLStreamWriter writeAttachment(){
        
        for(Attachment att :[SELECT Id, Body,ContentType,Description,Name FROM Attachment WHERE ParentId = :opp.Id]){
            if(att.Name.contains('pdf') || att.Name.contains('tif')){
                String descriptionString = opp.Tracking_Id__c;
                String fileTypeSuffix;
                String mimeTypeTC;
                if(att.Name.contains('pdf')){
                    mimeTypeTC = '17';
                    fileTypeSuffix = '.pdf';
                }else{
                    mimeTypeTC = '11';
                    filetypeSuffix='.tif';
                }

                xml.writeStartElement(null,'Attachment',null);
                    
                    descriptionString += '_APP';
                    if(att.Name.contains('Application 1')){
                        descriptionString += 'I';
                    }else if(att.Name.contains('Application 2')){
                        descriptionString += 'II';
                    }
                    descriptionString += '_' + att.id + dateTime.now().gettime() + fileTypeSuffix;

                    addSingleElement('Description',descriptionString);
                    addSingleElement('AttachmentData',EncodingUtil.Base64Encode(att.Body));
                    startElementWithAttributes('AttachmentType',null,new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                    
                    startElementWithAttributes('MimeTypeTC',null,new Map<String,String>{'tc'=>mimeTypeTC});
                    xml.writeEndElement();
                    startElementWithAttributes('AttachmentLocation',null,new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                xml.writeEndElement(); // Close Attachment
            }
        }
        /*
            <Attachment>
              <Description>12345670_APPI_20110824090237.pdf</Description>
              <AttachmentData>Binary encoded using Base64 to a string of PDF Data Goes Here</AttachmentData>
              <AttachmentType tc="1"/>
              <MimeTypeTC tc="17"/>
              <AttachmentLocation tc="1"/>
            </Attachment>
        */
        return xml;
    }

    public XMLStreamWriter writeParties(){
        
        Integer childNumber = 1;
        String addressNumber = 'Address_1';
        for(Policy_Participants__c par : participants){
            if(par.Role__c=='Primary Insured' || par.Role__c =='Owner'){
                //<Party id="Party_Ins"> or <Party id="Party_Own">
                String partyId;
                if(par.Role__c=='Primary Insured'){
                    partyId = 'Party_Ins';
                }else if(par.Role__c=='Owner'){
                    partyId = 'Party_Own';
                }
                startElementWithAttributes('Party',null,new Map<String,String>{'id'=>partyId});

                    /*
                    <PartyTypeCode tc="1">Person</PartyTypeCode>
                    <GovtID>123456789</GovtID>
                    <GovtIDTC tc="1" />
                    <ResidenceState tc="26">Massachusetts</ResidenceState>
                    <ResidenceCountry tc="1">United States of America</ResidenceCountry>
                    <PrefComm tc="3">EMail</PrefComm>
                    */
                    startElementWithAttributes('PartyTypeCode','Person',new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                    addSingleElement('GovtID',par.Account__r.SSN__c);
                    startElementWithAttributes('GovtIDTC',null,new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                    startElementWithAttributes('ResidenceState',par.Account__r.BillingStateCode,new Map<String,String>{'tc'=>String.valueOf(stateMap.get(par.Account__r.BillingStateCode).Acord_Number_tc__c)});
                    xml.writeEndElement();
                    startElementWithAttributes('ResidenceCountry',par.Account__r.BillingCountry,new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                    startElementWithAttributes('PrefComm',par.Account__r.Preferred_Communication__c,new Map<String,String>{'tc'=>prefCommMap.get(par.Account__r.Preferred_Communication__c)});
                    xml.writeEndElement();

                    /*
                    <Person>
                      <FirstName>Mark</FirstName>
                      <MiddleName>U</MiddleName>
                      <LastName>Test</LastName>
                      <Gender tc="1" />
                      <BirthDate>1966-02-27</BirthDate>
                      <Age>49</Age>
                     </Person>
                     */
                    xml.writeStartElement(null,'Person',null);
                        addSingleElement('FirstName',par.Account__r.FirstName);
                        addSingleElement('MiddleName',par.Account__r.MiddleName);
                        addSingleElement('LastName',par.Account__r.LastName);
                        startElementWithAttributes('Gender',null,new Map<String,String>{'tc'=>genderMap.get(par.Account__r.Gender__c)});
                        xml.writeEndElement();
                        addSingleElement('BirthDate',formatDate(par.Account__r.PersonBirthdate));
                        addSingleElement('Age',String.valueOf(par.Account__r.Age__c));
                    xml.writeEndElement(); //close Person
                    
                    /*
                    <Address id="Address_1">
                      <AddressTypeCode tc="30">Residence</AddressTypeCode>
                      <Line1>1 Linscott Road</Line1>
                      <City>Woburn</City>
                      <AddressStateTC tc="26">Massachusetts</AddressStateTC>
                      <Zip>01801</Zip>
                      <AddressCountryTC tc="1">United States of America</AddressCountryTC>
                    </Address>
                    */
                    startElementWithAttributes('Address',null,new Map<String,String>{'id'=>addressNumber});
                        startElementWithAttributes('AddressTypeCode','Residence',new Map<String,String>{'tc'=>'30'});
                        xml.writeEndElement();
                        addSingleElement('Line1',par.Account__r.BillingStreet.replaceAll('\r',' ').replaceAll('\n',''));
                        addSingleElement('City',par.Account__r.BillingCity);
                        startElementWithAttributes('AddressStateTC',par.Account__r.BillingStateCode,new Map<String,String>{'tc'=>String.valueOf(stateMap.get(par.Account__r.BillingStateCode).Acord_Number_tc__c)});
                        xml.writeEndElement();
                        addSingleElement('Zip',par.Account__r.BillingPostalCode);
                        startElementWithAttributes('AddressCountryTC',par.Account__r.BillingCountry,new Map<String,String>{'tc'=>'1'});
                        xml.writeEndElement();
                    xml.writeEndElement(); // close Address
                    addressNumber += '1';

                    /*
                    <Phone>
                      <PhoneTypeCode tc="1" />
                      <AreaCode>123</AreaCode>
                      <DialNumber>4567890</DialNumber>
                    </Phone>
                    */
                    xml.writeStartElement(null,'Phone',null);
                        startElementWithAttributes('PhoneTypeCode',par.Account__r.Phone_1_Type__c,new Map<String,String>{'tc'=>phoneTypeMap.get(par.Account__r.Phone_1_Type__c)});
                        xml.writeEndElement();
                        String cleanPhone = par.Account__r.Phone.replace('(','').replace(')','').replace('-','').trim();
                        String areaCode = cleanPhone.left(3);
                        String dialNumber = cleanPhone.subString(3,cleanPhone.length()).trim();
                        addSingleElement('AreaCode',areaCode);
                        addSingleElement('DialNumber',dialNumber);
                    xml.writeEndElement(); //Close Phone

                    /*
                     <EMailAddress id="Email_1">
                      <EMailType tc="5" />
                      <AddrLine>mtest@yahoo.com</AddrLine>
                    </EMailAddress>
                    */
                    startElementWithAttributes('EMailAddress',null,new Map<String,String>{'id'=>'Email_1'});
                        startElementWithAttributes('EMailType',null,new Map<String,String>{'tc'=>'5'});
                        xml.writeEndElement();
                        addSingleElement('AddrLine',par.Account__r.PersonEmail);
                    xml.writeEndElement(); //Close Email
                
                //</Party> 
                xml.writeEndElement(); //close Party
            }else if(par.Role__c=='Beneficiary'){
                //<Party id="Beneficiary_1">
                startElementWithAttributes('Party',null,new Map<String,String>{'id'=>'Beneficiary_1'});
                    //<PartyTypeCode tc="1">Person</PartyTypeCode>
                    startElementWithAttributes('PartyTypeCode','Person',new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                  /*
                  <Person>
                    <FirstName>Penelope</FirstName>
                    <MiddleName>T</MiddleName>
                    <LastName>Lane</LastName>
                   </Person>
                   */
                    xml.writeStartElement(null,'Person',null);
                        addSingleElement('FirstName',par.Account__r.FirstName);
                        addSingleElement('MiddleName',par.Account__r.MiddleName);
                        addSingleElement('LastName',par.Account__r.LastName);
                    xml.writeEndElement(); //close Person
                //</Party>        
                xml.writeEndElement();
            }else if(par.Role__c=='Payor'){
                
                //<Party id="Payor">
                startElementWithAttributes('Party',null,new Map<String,String>{'id'=>'Payor'});
                    //<PartyTypeCode tc="1">Person</PartyTypeCode>
                    startElementWithAttributes('PartyTypeCode','Person',new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                /*                
                  <Person>
                    <FirstName>John</FirstName>
                    <MiddleName>T</MiddleName>
                    <LastName>MoneyMan</LastName>
                   </Person>
                */
                    xml.writeStartElement(null,'Person',null);
                        addSingleElement('FirstName',par.Account__r.FirstName);
                        addSingleElement('MiddleName',par.Account__r.MiddleName);
                        addSingleElement('LastName',par.Account__r.LastName);
                    xml.writeEndElement(); //close Person
                    /*
                   <Address id="Address_111">
                    <AddressTypeCode tc="30">Residence</AddressTypeCode>
                    <Line1>1 Main St.</Line1>
                    <City>Woburn</City>
                    <AddressStateTC tc="26">Massachusetts</AddressStateTC>
                    <Zip>01801</Zip>
                    <AddressCountryTC tc="1">United States of America</AddressCountryTC>
                  </Address>
                    */
                    startElementWithAttributes('Address',null,new Map<String,String>{'id'=>addressNumber});
                        startElementWithAttributes('AddressTypeCode','Residence',new Map<String,String>{'tc'=>'30'});
                        xml.writeEndElement();
                        addSingleElement('Line1',par.Account__r.BillingStreet.replaceAll('\r',' ').replaceAll('\n',''));
                        addSingleElement('City',par.Account__r.BillingCity);
                        startElementWithAttributes('AddressStateTC',par.Account__r.BillingStateCode,new Map<String,String>{'tc'=>String.valueOf(stateMap.get(par.Account__r.BillingStateCode).Acord_Number_tc__c)});
                        xml.writeEndElement();
                        addSingleElement('Zip',par.Account__r.BillingPostalCode);
                        startElementWithAttributes('AddressCountryTC',par.Account__r.BillingCountry,new Map<String,String>{'tc'=>'1'});
                        xml.writeEndElement();
                    xml.writeEndElement(); // close Address
                    addressNumber += '1';
                //</Party>      
                xml.writeEndElement(); //close Party  
            }else if(par.Role__c=='Child'){
                /*
                <Party id="PartyChild_1">
                  <PartyTypeCode tc="1">Person</PartyTypeCode>
                  <Person>
                      <FirstName >Jack</FirstName>
                      <MiddleName >N</MiddleName>
                      <LastName >Test</LastName>
                      <Gender tc="1" />
                      <BirthDate >2000-01-03</BirthDate>
                  </Person>
                </Party>
                */
                String partyId = 'PartyChild_' + String.valueOf(childNumber);
                startElementWithAttributes('Party',null,new Map<String,String>{'id'=>partyId});
                    startElementWithAttributes('PartyTypeCode','Person',new Map<String,String>{'tc'=>'1'});
                    xml.writeEndElement();
                    xml.writeStartElement(null,'Person',null);
                        addSingleElement('FirstName',par.Account__r.FirstName);
                        addSingleElement('MiddleName',par.Account__r.MiddleName);
                        addSingleElement('LastName',par.Account__r.LastName);
                        startElementWithAttributes('Gender',null,new Map<String,String>{'tc'=>genderMap.get(par.Account__r.Gender__c)});
                        xml.writeEndElement();
                        addSingleElement('BirthDate',formatDate(par.Account__r.PersonBirthdate));
                    xml.writeEndElement(); //close Person
                xml.writeEndElement(); //close Party
                childNumber++;
            }
        }

        /*
        <Party id="Party_AGT">
          <IDReferenceNo>33117 </IDReferenceNo>
        </Party>
        <Party id="Party_GA">
           <IDReferenceNo>01886</IDReferenceNo>
        </Party>
        */
        
        startElementWithAttributes('Party',null,new Map<String,String>{'id'=>'Party_AGT'});
            addSingleElement('IDReferenceNo','33117');
        xml.writeEndElement(); // Close Party
        startElementWithAttributes('Party',null,new Map<String,String>{'id'=>'Party_GA'});
            addSingleElement('IDReferenceNo','01886');
        xml.writeEndElement(); // Close Party
        return xml;
    }

    public XMLStreamWriter writeRelations(){

        Integer relationNumber = 0;
        Integer childNumber = 0;
        Integer beneficiaryNumber = 0;

        Boolean isFirstChild = true;
        for(Policy_Participants__c par : participants){
            
            if(par.Role__c == 'Primary Insured'){
                relationNumber++;
                String relationId = 'Relation_' + String.valueOf(relationNumber);
                /*
                <Relation id="Relation_1"  OriginatingObjectID="Holding_1" RelatedObjectID="Party_Ins">
                    <OriginatingObjectType tc="4" />
                    <RelatedObjectType tc="6" />
                    <RelationRoleCode tc="32" />
                </Relation>
                */
                startElementWithAttributes('Relation',null,new Map<String,String>{'id'=>relationId
                    ,'OriginatingObjectID'=>'Holding_1'
                    ,'RelatedObjectID'=>'Party_Ins'
                });
                    addRelationStaticElements();
                    startElementWithAttributes('RelationRoleCode',null,new Map<String,String>{'tc'=>'32'});
                    xml.writeEndElement();
                xml.writeEndElement();

            }else if(par.Role__c == 'Child'){
                relationNumber++;
                childNumber++;
                String relationId = 'Relation_' + String.valueOf(relationNumber);
                String childId = 'PartyChild_' + String.valueOf(childNumber);
                /*
                <Relation id="Relation_6" OriginatingObjectID="Holding_1" RelatedObjectID="PartyChild_1">
                    <OriginatingObjectType tc="6" />
                    <RelatedObjectType tc="6" />
                    <RelationRoleCode tc="2" />
                </Relation>
                <Relation id="Relation_6" OriginatingObjectID="Holding_1" RelatedObjectID="PartyChild_2">
                    <OriginatingObjectType tc="6" />
                    <RelatedObjectType tc="6" />
                    <RelationRoleCode tc="2" />
                </Relation>
                */
                startElementWithAttributes('Relation',null,new Map<String,String>{'id'=>relationId
                    ,'OriginatingObjectID'=>'Holding_1'
                    ,'RelatedObjectID'=>childId
                });
                    addRelationStaticElements();
                    startElementWithAttributes('RelationRoleCode',null,new Map<String,String>{'tc'=>'2'});
                    xml.writeEndElement();
                xml.writeEndElement();
            }else if(par.Role__c == 'Owner'){
                relationNumber++;
                String relationId = 'Relation_' + String.valueOf(relationNumber);
                /*
                <Relation id="Relation_2" OriginatingObjectID="Holding_1" RelatedObjectID="Party_Own">
                    <OriginatingObjectType tc="4" />
                    <RelatedObjectType tc="6" />
                    <RelationRoleCode tc="8">Owner</RelationRoleCode>
                    <RelationDescription tc="1999900016">Spouse</RelationDescription>
                </Relation>
                */
                startElementWithAttributes('Relation',null,new Map<String,String>{'id'=>relationId
                    ,'OriginatingObjectID'=>'Holding_1'
                    ,'RelatedObjectID'=>'Party_Own'
                });
                    addRelationStaticElements();
                    startElementWithAttributes('RelationRoleCode','Owner',new Map<String,String>{'tc'=>'8'});
                    xml.writeEndElement();
                    startElementWithAttributes('RelationDescription',par.Relation_To_Primary_Insured__c,new Map<String,String>{'tc'=>relationCodeMap.get(par.Relation_To_Primary_Insured__c)});
                    xml.writeEndElement();
                xml.writeEndElement();
            }else if(par.Role__c == 'Beneficiary'){
                relationNumber++;
                beneficiaryNumber++;
                String relationId = 'Relation_' + String.valueOf(relationNumber);
                String beneficiaryId = 'Beneficiary_' + String.valueOf(beneficiaryNumber);
                /*
                <Relation id="Relation_5" OriginatingObjectID="Holding_1" RelatedObjectID="Beneficiary_1">
                    <OriginatingObjectType tc="4" />
                    <RelatedObjectType tc="6" />
                    <RelationRoleCode tc="34" >Beneficiary</RelationRoleCode>
                    <RelationDescription tc="1999900016">Spouse</RelationDescription>
                    <InterestPercent >100</InterestPercent>
                </Relation>
                */
                startElementWithAttributes('Relation',null,new Map<String,String>{'id'=>relationId
                    ,'OriginatingObjectID'=>'Holding_1'
                    ,'RelatedObjectID'=>beneficiaryId
                });
                    addRelationStaticElements();
                    startElementWithAttributes('RelationRoleCode','Beneficiary',new Map<String,String>{'tc'=>'34'});
                    xml.writeEndElement();
                    startElementWithAttributes('RelationDescription',par.Relation_To_Primary_Insured__c,new Map<String,String>{'tc'=>relationCodeMap.get(par.Relation_To_Primary_Insured__c)});
                    xml.writeEndElement();
                    addSingleElement('InterestPercent','100');
                xml.writeEndElement();
            }else if(par.Role__c == 'Payor'){
                relationNumber++;
                String relationId = 'Relation_' + String.valueOf(relationNumber);
                /*
                <Relation id="Relation_6" OriginatingObjectID="Holding_1" RelatedObjectID="Payor">
                    <OriginatingObjectType tc="4" />
                    <RelatedObjectType tc="6" />
                    <RelationRoleCode tc="31">Payor</RelationRoleCode>
                </Relation>
                */
                startElementWithAttributes('Relation',null,new Map<String,String>{'id'=>relationId
                    ,'OriginatingObjectID'=>'Holding_1'
                    ,'RelatedObjectID'=>'Payor'
                });
                    addRelationStaticElements();
                    startElementWithAttributes('RelationRoleCode','Payor',new Map<String,String>{'tc'=>'31'});
                    xml.writeEndElement();
                xml.writeEndElement();
            }
        }

        /*
        <Relation id="Relation_3"  OriginatingObjectID="Holding_1" RelatedObjectID="Party_AGT">
            <OriginatingObjectType tc="4" />
            <RelatedObjectType tc="6" />
            <RelationRoleCode tc="38">Agent</RelationRoleCode>
        </Relation>
        */
        relationNumber++;
        String relationId = 'Relation_' + String.valueOf(relationNumber);
        startElementWithAttributes('Relation',null,new Map<String,String>{'id'=>relationId
            ,'OriginatingObjectID'=>'Holding_1'
            ,'RelatedObjectID'=>'Party_AGT'
        });
            addRelationStaticElements();
            startElementWithAttributes('RelationRoleCode','Agent',new Map<String,String>{'tc'=>'38'});
            xml.writeEndElement();
        xml.writeEndElement();

        /*
        <Relation id="Relation_4" OriginatingObjectID="Holding_1" RelatedObjectID="Party_GA">
            <OriginatingObjectType tc="4" />
            <RelatedObjectType tc="6" />
            <RelationRoleCode tc="48">General Agent</RelationRoleCode>
        </Relation>
        */
        relationNumber++;
        relationId = 'Relation_' + String.valueOf(relationNumber);
        startElementWithAttributes('Relation',null,new Map<String,String>{'id'=>relationId
            ,'OriginatingObjectID'=>'Holding_1'
            ,'RelatedObjectID'=>'Party_GA'
        });
            addRelationStaticElements();
            startElementWithAttributes('RelationRoleCode','General Agent',new Map<String,String>{'tc'=>'48'});
            xml.writeEndElement();
        xml.writeEndElement();
       
        return xml;
    }

    public XMLStreamWriter addRelationStaticElements(){
        startElementWithAttributes('OriginatingObjectType',null,new Map<String,String>{'tc'=>'4'});
        xml.writeEndElement();
        startElementWithAttributes('RelatedObjectType',null,new Map<String,String>{'tc'=>'6'});
        xml.writeEndElement();
        return xml;
    }

    public XMLStreamWriter addSingleElement(String name,String content){
        xml.writeStartElement(null,name,null);
            if(content!=null) xml.writeCharacters(content);
        xml.writeEndElement();
        return xml;
    }

    public XMLStreamWriter startElementWithAttributes(String name,String content,Map<String,String> attributeMap){
        xml.writeStartElement(null,name,null);

        for(String s : attributeMap.keyset()){
            if(attributeMap.get(s)!=null) xml.writeAttribute(null,null,s,attributeMap.get(s));
        }
        if(content!=null) xml.writeCharacters(content);

        return xml;
    }

    public String formatDate(Date d){
        String formattedDate = '';
        formattedDate += d.year();
        formattedDate += '-';
        String monthText = String.valueOf(d.month());
        if(monthText.length()==1){
            monthText = '0' + monthText;
        }
        formattedDate += monthText;
        formattedDate += '-';
        String dayText = String.valueOf(d.day());
        if(dayText.length()==1){
            dayText = '0' + dayText;
        }
        formattedDate += dayText;
        return formattedDate;
    }

    public String formatDateTime(DateTime dt){
        String dateTimeString = dateTime.now().format('HH:mm:ss');
        Integer offsetMS = UserInfo.getTimeZone().getOffset(date.today());
        Integer hoursOffset = offsetMS/1000/60/60;
        dateTimeString += String.valueOf(hoursOffset) +':00';
        return dateTimeString;
    }
}