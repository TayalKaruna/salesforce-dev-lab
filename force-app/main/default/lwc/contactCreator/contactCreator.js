import { LightningElement,api } from 'lwc';
import FNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import CON_OBJECT from '@salesforce/schema/Contact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactCreator extends LightningElement {
    fields = [FNAME_FIELD,LNAME_FIELD,EMAIL_FIELD];
    @api recordId;
    @api objectApiName;

    objectApiName = CON_OBJECT;

    handleSuccess(event){
        const contactId = event.detail.id;
        const evt = new ShowToastEvent({
            title: 'Success',
            message: `Contact created with Id: ${contactId}`,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}