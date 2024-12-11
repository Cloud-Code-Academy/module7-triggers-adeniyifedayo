trigger AccountTrigger on Account (before insert, after insert) {
    if (Trigger.isInsert){
        if (Trigger.isBefore){
            for (Account acc : Trigger.new){  
                if (acc.Type == null){
                    acc.Type = 'Prospect';
                }
     
                if (acc.ShippingCity != null || acc.ShippingState != null ||acc.ShippingStreet != null ||acc.ShippingPostalCode != null || acc.ShippingCountry != null  ) {
                    acc.BillingCity = acc.ShippingCity;
                    acc.BillingState = acc.ShippingState;
                    acc.BillingStreet = acc.ShippingStreet;
                    acc.BillingPostalCode = acc.ShippingPostalCode;
                    acc.BillingCountry = acc.ShippingCountry;
                }

                if (acc.Phone != null && acc.Fax != null && acc.Website != null){
                acc.Rating = 'Hot';
                }
            }
        }
    }
    
    List <Contact> newContact = new List <Contact> ();
    if (Trigger.isInsert){
        if (Trigger.isAfter){
            for (Account acc : Trigger.new){
                newContact.add(new Contact(
                    AccountId = acc.Id,
                    LastName = 'DefaultContact',
                    Email = 'default@email.com'));
            }
        }
   }
   insert newContact;
}