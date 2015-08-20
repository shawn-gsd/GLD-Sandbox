public class Quotes_code_csv{
    
  public static String StateCodigo(string Code){
        Map<String, String> mapStateCodigo = new Map<String, String>();

        mapStateCodigo.put('AL','1');
        mapStateCodigo.put('AK','2');
        mapStateCodigo.put('AZ','3');
        mapStateCodigo.put('AR','4');
        mapStateCodigo.put('CA','5');
        mapStateCodigo.put('CO','6');
        mapStateCodigo.put('CT','7');
        mapStateCodigo.put('DE','8');
        mapStateCodigo.put('FL','9');
        mapStateCodigo.put('GA','10');
        mapStateCodigo.put('HI','11');
        mapStateCodigo.put('ID','12');
        mapStateCodigo.put('IL','13');
        mapStateCodigo.put('IN','14');
        mapStateCodigo.put('IA','15');
        mapStateCodigo.put('KS','16');
        mapStateCodigo.put('KY','17');
        mapStateCodigo.put('LA','18');
        mapStateCodigo.put('ME','19');
        mapStateCodigo.put('MD','20');
        mapStateCodigo.put('MA','21');
        mapStateCodigo.put('MI','22');
        mapStateCodigo.put('MN','23');
        mapStateCodigo.put('MT','26');
        mapStateCodigo.put('NE','27');
        mapStateCodigo.put('NV','28');
        mapStateCodigo.put('NH','29');
        mapStateCodigo.put('NJ','30');
        mapStateCodigo.put('NM','31');
        mapStateCodigo.put('NY','32');
        mapStateCodigo.put('NC','33');
        mapStateCodigo.put('ND','34');
        mapStateCodigo.put('OH','35');
        mapStateCodigo.put('OK','36');
        mapStateCodigo.put('OR','37');
        mapStateCodigo.put('PA','38');
        mapStateCodigo.put('MS','24');
        mapStateCodigo.put('MO','25');
        mapStateCodigo.put('RI','39');
        mapStateCodigo.put('SC','40');
        mapStateCodigo.put('SD','41');
        mapStateCodigo.put('TN','42');
        mapStateCodigo.put('TX','43');
        mapStateCodigo.put('UT','44');
        mapStateCodigo.put('VT','45');
        mapStateCodigo.put('VA','46');
        mapStateCodigo.put('WA','47');
        mapStateCodigo.put('WV','48');
        mapStateCodigo.put('WI','49');
        mapStateCodigo.put('WY','50');
        mapStateCodigo.put('DC','51');
        
         


        return mapStateCodigo.get(Code);
    }
    
     public static String GenderCod(string Code){
     
        Map<String, String> mapGenderCod = new Map<String, String>();
        
        mapGenderCod.put('M','Male');
        mapGenderCod.put('F','Female');


        return mapGenderCod.get(Code);
        
    
    }
}