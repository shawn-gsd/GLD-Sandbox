public with sharing class AcordIntegrationManager {
    /* NEW FIELDS
        Opportunity.Spouse Coverage Amount
        Opportunity.Submitted to SBLI checkbox
        Opportunity.Submission Retry Count number
        Opportunity.Policy Number text
        Opportunity.Confirmation Number text
        Quote.Quote Nickname
        policy_participant.Relation_to_insured__c
    */

    final String CLIENT_CERT = 'MIIVBAIBAzCCFMAGCSqGSIb3DQEHAaCCFLEEghStMIIUqTCCA+IGCSqGSIb3DQEHAaCCA9MEggPPMIIDyzCCA8cGCyqGSIb3DQEMCgECoIICtjCCArIwHAYKKoZIhvcNAQwBAzAOBAi1Zvl0w689MwICB9AEggKQlexW6qyrG2KQLCeeYDf1Q/3kj5HXtL1egepZDheEk3xIU5kNagkqVmMwm61TUAk0yDIouAj19YLl8sX7z/k+sHPzd76GWzX6XLhmtC3aPJ9Gy4sAPMX8z/3LusEYcmvQWfafXQKFMnhZ1ozn1Xv7FAuEKpAIDz7DdN+6A8f7nqO50155iV/Oo/gB06nBs58JfBpsQoGR4h6KWCo3Trescsqdxtt/KJGHhmySApw5UL4u6jO4fnBeI4fJjJiZmbZZlGO6euaA3XRUdtwZJX0lQPiOwZJe1YI3sPK3D2ag9duH0dIUe2F9Xo1S4ZA4A17J/kMuiidLqKxwpiDdzdGwy8uOdt8fKj51hhHAzk0aw2PB/ci3EI8Y+FVBy0lpalgLFIS1alEbXCkFdcF3aDdSCgZXp1aLLWDScLhkyV8sfcgVJZHrsdSiITII+07aIv7aRqdRkcnJbqwVrLHcbs4uhGLhVCPe2UVQgw1Q1KP0+QrMqiH3dqu3V28LclBEw9hwSysr9GNCU5XInMuYr+1UzEZwJj3pivd9CfCqBA+lSl0/g7+0kLNW+080n7MAeqnp2uXZ7m34Ey/XuvYScHY1MhFP4hQCGob91gAVawx9NuPsJZZ18OwznW/fYzP2zCM8rl2CLkbhlSGJtOTdm/iS3G9urjvOR0FcUiqxnCR4piDiH/RT62ZMDK92HINuPSPqLJXoo/eFyNZ2O71cSxwm4jsbtQCh41BbHlbJiOCdbBSkqCD0SOhXv739WqtQhi/0Bj0DzzBrl4dcmpMH2evGpplki2UyvC9rLlbIswzw67HiR1eP9BkHWzobGSsn13JINPAF8NkDLNpcC0uZEqXmMwzH4VLaG+jOad9JKLo8XGIxgf0wEwYJKoZIhvcNAQkVMQYEBAEAAAAwawYJKwYBBAGCNxEBMV4eXABNAGkAYwByAG8AcwBvAGYAdAAgAEUAbgBoAGEAbgBjAGUAZAAgAEMAcgB5AHAAdABvAGcAcgBhAHAAaABpAGMAIABQAHIAbwB2AGkAZABlAHIAIAB2ADEALgAwMHkGCSqGSIb3DQEJFDFsHmoAbABlAC0AUwBCAEwASQBQAFIAVwBlAGIAQQB1AHQAaAAtAGEAMwBmADkANwA2AGYAOAAtADYAMgAxADAALQA0ADUAYgAxAC0AYgBiADYAZQAtADEAYwAzAGMAMQBhADcANgAxADgAZQBkMIIQvwYJKoZIhvcNAQcGoIIQsDCCEKwCAQAwghClBgkqhkiG9w0BBwEwHAYKKoZIhvcNAQwBBjAOBAjAykfPdS7WfQICB9CAghB4pA+YSX7HI4kq6abKCKHTiWjr0XAfXKb0d8qIPH2l00qOKrBIcIdCiGlH24Gvli0TB0a2Gx1BFxwtdJ/ohnJg4d5wfXKbyoAY5e8OhPMGaULLkhxsG7ZYz4sdl6j+vG8VFzJ6LVgFPnr94iTbrkaX7ezOHyxFqma7zq0TqX5E6k/DhMzAhV50GiiuTEANCu2dgszK1YM25s+D27MxHv+fDdMpn1T7ZWO7mFMhKDI6NjwImHp7dWsx92Lpg5s6hz+9uZjPSc93grcNdT2r/4xKUM5HbxBNlb0aPZ2UlWPSmywrrnZrHUpVmke8YQW6vxGTxcCUdxdQ4YK2GvtF7odiGrk2mJ703VW6agmXV3ndeIWxlqtpgynzV0sQnJdLHmklcR3nDhFfcIUhtgwSA0zZmXEQMT/hG3J3Ymf0XQQ8oPqHQiw6IIDiyp0evi5GgLoj3w/jN+Eag1ezIgyzoGmsgegVdp0yk/xDw/gTWKK4NJAz839UOLc1FdKKRH8grcdXWT6+oqzHvG5SwhPefad3TJxjaoIBp3QQZveOKn0diiKqXrnj8uucVT3EeHJAzikKhS3PtPlVN9K5PiwWhRGBz31KQgbOUkZA1SElrxyqvbS8daZH76I7t09/3a5j5J+Eq17R/MhjsjC7EJX/y5OWQTH1Ai0hUjxR4sgHKXLviLmXTWeqoGZ0tSN4BCqEyW8IAII6ujXsrYROIqD5hicb+6VLZ33Po8NY306vr8M5BtX5zZaHe17fMiZCEg4oJxb1hOnCBfVRpjq6ruzFqM9phKbQX2wlWg+XaSdFO2TtdNN6vseE2KkpCMGhgn4+mUeiuKP5Z5Mld1OaDOux0Eovsl7DXS2GjLGYqxOnyC8lpFkaKt/7ueYW1XugQDo+6KKFXBza64zXFqr69LO5liWzdlqo4UXgVI+D5czzNdRk2XvFbv02a6AA+ktBsuQwy5M9XjyRuDJ7UwIwdFmgs0expuJT1OihC9G40ctrRadLq63bcaqh8ZNoEvKayv3yjGg/WPgEcVwZp/vMF0vFMQdDgGhpio8UrYadl/QlI4F4KRdku3K6UjmFhnbvKYY6vdGiA31Hju1eTxBbKWWO5n+SYYMFBACIWyNWKZYBKSS1NPq6gHS7CYw0Vrs4fD5v3ETpEU/H4n6Oa0luNgWIQeA6SW/TyybgcISZcufuKAKno+vZJGRFA0Al1devDucsnscqKsbFtOuGVnxE4kxXzEtK6rNRk18/3WsZqdHmBPnQTiELuWOeUP8z+yHGN3MIdXcNqqRWnHTiCA+eIT7f2SUhooRrFpmlEGCThCFLaHV0QescLwDw34oYfSHR3mNEvjaZMYncubgAS1vDQH/oRhonf68GWny78Jz0W9oL11X9ii9IFLFjwteTf9V+xSjYdUditeUMpQKBPTuv630jqo8OkKxXLabJ9Uceg7zobjSilsZ/vDiZwKDuu4puMcfclFacNLOyVgiVkbFPGJhNYVLaGo7R5Tkwux2HexsoB8vprNZE7DOs7xeHKCjxoGYZujZvIzWZUuHTHYEHCsUTX+T/8CRxnsfMbrG0JyksMoi9iQCeg5U1EZQRyi7wckiAV9vlfak6HwuoVpzBalVD8RmwY1/a6rt4UeKikI7MpRwP5GPH5Js6ctHRBnRIrC1IJ+eArHRZAQSS3l8x7J6rJGuKfjf3/i++HMN82EwAtArO7UaanQ7dc5NdEVtkxyOscNFJqC7d7x1F94WubGqs7A7zNvIf49rFqLa9tbtVm0+7LUvzt87KsJ28xcmRKXcLkvxpindcQuzjp+JcxJR5pD0CmzAoWm+4O9Qetu8neMy2gVw+7L0Ylnknwk0gB7vbmfKMoscs3aBCnbwFZZ44VDo1LYXqGsTYdDXdAEp2iGp2W2vl6DW6V6M5bjlm7HakiaPNFxoYpObWcOEGUnQAce65HXZXuaXsy6p499xUMmlU+3a//7aWrRPuTnZBRlr7vKIliL0sIfnGAaXWc0KfalAyXuUCsnGmV0gAT9S/Vc7gbh80clL068L4C6dt3PpdXvZUayBapatt6J11t/zYp2wm4ZOdz+8vF3s1btKJbJ2RfVLS7+T23hunuAjfMBuVmWM5UbsFhvVTSrOzbzkkcmiYXxgaM+2WKqU57xdk+dqszzuzRUnWTKNz4LYlWp6WGAfy+qbyR9lswg+gCVJCx1hxxm+fPOzzxxielOAqaKANkmAvZSKvh2VAcWgvHkWQP9lUzMY89PW71ohtzGdLUGvCEF5+XXbQzQtz7SUX+tlmqgjypfzD9khB2KcyIGefPAwgbbkR2BzAZHxOMWrXl6o9cGvosCfsnCenbWHW3Og4LM+lk3iiZxcNdfUNIUUNNbMI//ZRLwmzVVPeNEQNqfu5Ci/PyvYeZkRAvZv5x2kyOo/rJaqpprLjGTVdunAPZI3kZzMFk+FBu/aysdOJBzGkOj+xT/gKczorLbP5kZ9sBlgN8wXBat4lJQNXiefP3FcCLSOdkvPkE/HpcMl86mLemVo4IGcUqsWcB0bJaA94cu++n07wNfKo2BMBzUswgzF7MHr1uG7IBws2mnPHXKu0lifbEEoCsJH2tyBKz/heYrp804pFPS016dG+w/9rEU6NI3OqyJv8s2o1OTtQMl10lhhSmzhYsgdMXw2gCVs5cKhN0ehnmOHydwyhYTpucOuc0zAxM40clnY3cVm4ss0MMDF2jw5vF1XbYLM/nQarqngP/IkClEvRfsXqUdBlNZXfbEkYOigy7OmiLnwkZgSNlcNJ/5ve8R7aE8lyeMNNdpqosO8XDbxPLPgBI9Sia+z61yDUBHH9IBlmzDanBOtdoS3hNauo6ZfI/kvmHFOzsn7tHLatNBGwIW5AoXcSELd/AoAnRvbUw3hunwCAJbcxkth3mIm3JUwsgUPcVesv1UPnt5/kZOChOq/EhELLeDDRiXHzeLboahLUvzrXqSSGhh9feTnCf7QLsTm1joAGupiP+h8ZsFI1PtnaiKevXpbzWXLwMCN9g4igMFfjqqTTMn7r+KD6k++UilbK60bz4GyvwaGyswkbdIbPKpnqJEPAi4aSIYOgH7qL640lq6Fkqjq27739GUVdP6pKNlr3TnvFVFa/mWF93MfqVUmVZbJ8WbIqYM02ZK7UhmJkum3hXuGWOtsoTLWE20/9rfUjz1kI4NqbSHdQx2y3n6KXqv8ZiyjKSFSzkP52KXkG4+hwKLNga3xDWqhkFcqoGSAtQzussvhMnCVACruXH6piss3Vl7eRQOleoZjDF88fd8RQ3bwpXbZ+LoLgicN7JlCIKStqGyIF8FpywZE/kzbos8wggERp+ocmWsKGP9PckR4kFHIafIk83ZUZKS8ep0hz3G6yS+7z/bWG4S1UQY7wASHEpqeYmDKqrXJGYrx+gwQc5/NA/sfrmzV1rd3CLSwjg+szckVhB8qjkt2Nf7eCFiKqxoGRp8zv22r2btdhHkL+F2MsXple69ch1AHlteGkCG+sohZFlJxDAVNt1WIAmMqjePt1Vkm+lRvRtJexU5tVVLWLIyRGCzHv36NYtRy1Nc/9S3ZqK8ceH0cOPDtzGycRMi4GzgAJQEG2SujERrtSE614Ue/q+WKL88DpeLyveb8iCzlOI+pig/JafWl7SzoiIraoLeKGf0F48eAvYMjX5sNhFpzWcyLcgQ85qHMvzP8lBrLugTiUAq5m0zIm6pMYrG4DAwlD3AT02bJ3XX21PvpWADzTXPF3eGiubAfKltCSdYNTnAwzPQ8WY1B++dfDwQUJkWgHdoOfdC87bbzWjMjF0E8p6jgSnJEVnU8XVN+Td/isAf/eH4zP/r6Xn4zDJu/h6a9UrfIpJyOtRLj4e/Acmq7+ydA02bdPtG/hMnOstwtfhmwtA/huB/iiu7F8IXugezadqe3dHiXLxtGFuS8fYKaJ39uBnD01NdTzj1ibUQcrZHy+ugOF7glJ8WwrmQyAUoR4QUJsEczBtr27VkQKESIXtVOfFnOb5be6Tr0zM3OVqsjJ+0fFMx0kVCaa0Qsz+61kNGqGjAPYasnffVhbG4KpfSkXkPMwUi6Izrs5dqYdZKqc5QGpbwfDA3mAqMRWM5k3x1nYcaesjN9a6ikx3cfxhJUqgLDKgG0jBYnOHrT6yA5qyVBx/aNLv2cIG9FSDU8cwOkSTJFGRPKklUS6TCqcsTwPivP0wboj5EfoWHVqMWWex4mLuVkKoeNCNK9h+/nJ0KlSqREdPPOmCvxn1cBxBDuFm7N2P0LrDEOeUgyjt2ktnR1an85cisWYhf+zfWDIXjDPjeEYc51JKOrdvhkmgtj25+RpSE6ynyS/HB6oYcquB6QOS2Bz9FXE3HcKav9UPvxt+w/byWXEzSUeLata31R5xIcHI9h9dME8rYTC+6OCg/Stm51FH5ri5KtSogamJS8pkK7mzGjgU2bx1hAaYlqtDK2LCWc7XCVwTd14WU9tWAxYSdhF9+uHLkax7FYa1fh84MATlIhromTZozdkTf1ffMT2T6jlJsAFOAmogK81nKAlHImrgVe2bc/RJT4IVJfPxLkhEUmb0/9pGzTjrniMbui/c9OsORYBJqq+MspzvkeEVrUVTmAjtv0KiWQKaRFRjJgIfOlG1fIwYi+dR2PZlfDAp7zL0mcE8v/Mpxii4JFUpbBAYYW9KWTSTFekOdTZiG0xa8OWvm+d9H9rbNzA7cTddtX6YHiZXKcNN4cnJobHRYu+wqhnPCGPTx+VG5plONFUaf2xsEI/l6qibsyplpNg5as+qesCgp4AquALFm4kfZN9wz8nwnjuocsWI4YxHJCxkKXtwxtKaQ5Ic3jYsFA9OHBslTgVKmeeaFcQ9gx5+YChzEjyTyyKnz4Z4PhBqbCVTWz7xsbCLLPFxYSo+E2LXPGgP3YHS4NMEvsYzl4ZyVRLynCI7YiJUB32FX7D+UnArijxTNyhw29gVeDJYYhcRaWY14FjFH/G4+B9QTvxDmAlJEXXmcaRS7lh4p+1t7hM3f1Sq+grMpQ6FwMfV9BHg3cbE3HvQJtzuefHox4e4FHtaAAQcpHa2C31SPYjsM4oiem1snMmsBErh/IVaFVSXn/QjoGRlAFQB3Gbf0FuFrF7At6gU3HdgKGHrC7eN+1kFFFXXT3Zog+7guAPeaWtortSQrUhhgmJrO46vfWX8D266bsPLeLnixgHqVMbqDo6uZFPWizsDvqZR6P+dLeRm8lzRFu+h7vEPekfJMSmapOpK47WssT4jERPVwjY/rQyLrlQaEBJSMPX8JzUlo3Rh+9xOphUGSzZS+qwH1DW6JEGdR7qumbyQtpVc6hWZ6m/Rg7yuPfxXA+ZzqrbLsX0zA0+EAcze07MQIca/iVpvB7t50Ds0jN/TQk2Z3vToAF0fP2Or6RGbdV1UNKKQ4eWWRd4IuRbbBzlaMGaYNz78fiy8JN4uCHAhp6YaQ2IVc51SrROtzCmHabYpUJcOKX9+wkMG/bBar7q2+d6eUjLpV+gJQU1QGDnepB1If2CJMK6C4sXx920hY4GzcqOh/1jL9LOdsrcNcLEzPLMT/Hhzeo75v/DmxBbYjJlHIg9STjDutOF7hIpLJw/+X8m2GTpD9nUuHghyTL9nBwQCzA7MB8wBwYFKw4DAhoEFOuWN3IsvhySLgJwpA4IkmkhbYrFBBTuHfEaH6wq1c1HGPvS6DfqsHjipwICB9A=';
    final String CERT_PASSWORD = 'S@ving$3xt';

    public String theXml;
    public String cleanedXml;
    public HttpResponse res;
    public HttpRequest req;

    //Constructor accepts an Opportunity and creates the required XML.
    public AcordIntegrationManager(Id oppId) {
        Opportunity opp = [SELECT Id
                    ,Name
                    ,Account.BillingStateCode
                    ,Account.BillingState
                    ,Account.BillingCity
                    ,Account.FirstName
                    ,Account.MiddleName
                    ,Account.LastName
                    ,Account.BillingStreet
                    ,Account.BillingCountry
                    ,Account.BillingPostalCode
                    ,Account.Phone
                    ,PaymentMode__c
                    ,ProductCode__c
                    ,Initial_Coverage_Amount__c
                    ,Child_Rider_Cover_Amount__c
                    ,Inflation_Fighter__c
                    ,Tracking_Id__c
                    ,Account.PersonEmail
                    ,(SELECT Id
                            ,Account__r.FirstName
                            ,Account__r.MiddleName
                            ,Account__r.LastName
                            ,Account__r.BillingStreet
                            ,Account__r.BillingStateCode
                            ,Account__r.BillingState
                            ,Account__r.BillingCity
                            ,Account__r.Gender__c
                            ,Account__r.Age__c
                            ,Account__r.PersonBirthdate
                            ,Role__c
                            ,Account__r.SSN__c
                            ,Account__r.Preferred_Communication__c
                            ,Account__r.PersonEmail
                            ,Account__r.BillingCountry
                            ,Account__r.BillingPostalCode
                            ,Account__r.Phone
                            ,Relation_To_Primary_Insured__c
                            ,Account__r.Bank_Account_Number__c
                            ,Account__r.Bank_Name__c
                            ,Account__r.Bank_Routing_Number__c
                            ,Account__r.Bank_Account_Type__c
                            ,Account__r.Payment_Method__c
                            ,Account__r.Payment_Draft_Day__c
                            ,Account__r.Phone_1_Type__c
                        FROM Policy_Participants__r)

                    FROM Opportunity
                    WHERE Id = :oppId
        ];
        List<PolicyParticipantWrapper> participants = new List<PolicyParticipantWrapper>();
        for(Policy_Participants__c par : opp.Policy_Participants__r){
            PolicyParticipantWrapper parWrapper = new PolicyParticipantWrapper(par);
            participants.add(parWrapper);
        }
        if(participants.size() > 0) participants.sort();

        theXml = getXml(opp,participants);
        cleanedXml = cleanXml(theXml);
        /*
        res = sendPolicy(buildRequest(cleanedXml));
        
        String sbliResponse = sendPolicy(cleanedXml);
        system.debug('***response: ' + sbliResponse.unescapeHtml4());
        */
    }

    public String getXml(Opportunity opp,List<PolicyParticipantWrapper> participants){
        AcordXMLHelper helper = new AcordXMLHelper(opp,participants);
        theXml = helper.getXml();
        return theXml;
    }

    public String cleanXml(String theXml){
        cleanedXml = theXml.replaceAll('<CDATA>','<![CDATA[').replaceAll('</CDATA>',']]>');
        system.debug('***theXml: ' + cleanedXml);
        return cleanedXml;
    }

    public String sendPolicy(String xmlBody){
        res = sendPolicy(buildRequest(xmlBody));
        return res.getBody();
    }

    public HttpResponse sendPolicy(HttpRequest req){
        Http http = new Http();
        HttpResponse res = http.send(req);

        return res;
    }

    public HttpRequest buildRequest(String xmlBody){
        req = new HttpRequest();
        req.setEndpoint('https://paservices.sbliagent.com/External/services/TXLifeService');
        req.setMethod('POST');
        req.setHeader('Content-Length',String.valueOf(xmlBody.length()));
        req.setHeader('Content-Type','text/xml');
        //req.setHeader('soapaction','callTXLife');
        req.setClientCertificate(CLIENT_CERT,CERT_PASSWORD);
        req.setBody(xmlBody);
        //req.setClientCertificateName('DocSampleCert');

        return req;
    }
}