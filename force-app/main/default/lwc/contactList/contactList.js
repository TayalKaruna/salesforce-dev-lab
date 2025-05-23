import { LightningElement, wire, track, api } from 'lwc';
import FNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

import getContacts from '@salesforce/apex/ContactController.getContacts';
import deleteContacts from '@salesforce/apex/ContactController.deleteContact';
import getCount from '@salesforce/apex/ContactController.getContactsCount';
import updateContact from '@salesforce/apex/ContactController.updateSelectedContacts';
import emailValidation from '@salesforce/apex/EmailVerificationCallout.validateEmail';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import LightningModal from 'lightning/modal';

const columns = [
    { label: 'First Name', fieldName: FNAME_FIELD.fieldApiName, type: 'text', sortable: true },
    { label: 'Last Name', fieldName: LNAME_FIELD.fieldApiName, type: 'text', sortable: true },
    { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'email', sortable: true },
    { label: 'Phone', fieldName: PHONE_FIELD.fieldApiName, type: 'phone' },
    {
        type: 'button', initialWidth: 100,
        typeAttributes: { label: 'View', name: 'View', iconName: 'utility:preview', variant: 'brand' }
    },
    {
        type: 'button', initialWidth: 100,
        typeAttributes: { label: 'Edit', name: 'Edit', iconName: 'utility:edit', variant: 'success' }
    },
    {
        type: 'button', initialWidth: 150,
        typeAttributes: { label: 'Delete', name: 'Delete', iconName: 'utility:delete', variant: 'destructive' }
    },
    {
      type: 'button', initialWidth: 150,
      typeAttributes: { label: 'Validate', name: 'Validate', iconName: 'utility:check', variant: 'brand' }
    }
];

export default class ContactList extends LightningElement {
    columns = columns;
    totalRecords;
    @track selectedRecs = [];
    isModalOpen = false;
    isEditModal = false;
    isViewModal = false;
    firstNameValue = ''; 
    @track selectedRows;
    selectedContactId = [];
    @track contacts = [];
    @track isLoading = false;
    @track emailAddress;

    @wire(getContacts)
    wiredContacts(result) {
      this.contacts = result; 
      if (result.data) {
        this.contactsData = result.data;
      } else if (result.error) {
        this.showToast('Error', 'Failed to load contacts', 'error');
      }
    }

    @wire(getCount)
    wiredCountOfContacts({ error, data }) {
        if (data) this.totalRecords = data;
        else if (error) console.error('Error in getCount:', error);
    }

    handleRowSelection(event) {
      this.selectedContactId = event.detail.selectedRows.map(row => row.Id);
      }

    handleRowAction(event) {
        const action = event.detail.action.name;       
        const row = event.detail.row;
        this.isModalOpen = true;    

        if (action === 'View') {
            this.isViewModal = true;
            this.isEditModal = false;
        } else if (action === 'Edit') {
            this.selectedRecs = [{ ...row }];
            this.isViewModal = false;
            this.isEditModal = true;
        } else if (action === 'Delete') {
            this.deleteSelectedContacts([row.Id]);
        } else if (action === 'Validate') {
            this.validateEmail(row.Email);
            //console.log('Email ID passed in action:', row.Email);
        }
    }

    validateEmail(emailId){
      //console.log('Email ID passed to Apex:', emailId);
      emailValidation({emailAddress:emailId})
      .then((result) => {
        alert(result);
        if(result.data === 'Valid'){
        this.showToast('Success', 'Email is verified!', 'success');
      }else{
        this.showToast('Success', 'Email is not verified!', 'info');
      }
        refreshApex(this.contacts); 
      })
    .catch((error) => {
        this.showToast('Error',error.body.message, 'error');
    })
    }

     handleView() {
        const selected = this.template.querySelector('lightning-datatable').getSelectedRows();
        if (!selected.length) return this.showToast('No Selection', 'Please select at least one contact to view.', 'warning');
        this.selectedRecs = selected;
        this.isViewModal = true;
        this.isEditModal = false;
        this.isModalOpen = true;
    }

    handleEdit() {
        const selected = this.template.querySelector('lightning-datatable').getSelectedRows();
        if (selected.length === 0) return this.showToast('Warning','No Selection,Please select at least one contact to edit.', 'warning');
        this.selectedRecs = selected.map(row => ({ ...row }));
        this.isEditModal = true;        
        this.isViewModal = false;
        this.isModalOpen = true;
    }

    handleSave(event){
      //console.log('inside handle save button for update modal');
      this.isLoading = true;
      updateContact({ updatedContacts: this.selectedRecs })
                .then(() => {
                    this.showToast('Success', 'Records updated successfully!', 'success');
                    this.selectedRecs = [];
                    this.isModalOpen = false; 
                    this.isEditModal = false;
                    
                    //console.log('final contacts after save in handle save method'+JSON.stringify(this.contacts));
                    refreshApex(this.contacts); 
                  })
                .then(() =>{
                    const datatable = this.template.querySelector('lightning-datatable');
                    if (datatable) {
                        datatable.selectedRows = [];
                    }
                })
        .catch (error => {
          this.showToast('Error',error.body.message, 'error');
        })
        .finally(() => {
            this.isLoading = false;
        });
  }

    handleDeleteRecord() {
      const selected = this.template.querySelector('lightning-datatable').getSelectedRows();
      const idsToDelete = selected.map(row => row.Id);
      
      if(selected.length > 0){
        this.selectedRecs = selected;
        this.deleteSelectedContacts(idsToDelete);

      }else if(!selected || selected.length === 0){
         return this.showToast('Warning','No Selection, Please select at least one contact to delete.', 'warning');
        }
    }

    deleteSelectedContacts(ids) {
        deleteContacts({ contIds: ids })
            .then(() => {
                this.showToast('Success', 'Records deleted successfully!', 'success');
                refreshApex(this.contacts); 
            })
            .then(() =>{
              const datatable = this.template.querySelector('lightning-datatable');
              if (datatable) {
                  datatable.selectedRows = [];
              }
            })
            .catch(error => {
                this.showToast('Error', error.body?.message || 'Deletion failed.', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    closeModal() {
        this.isModalOpen = false;
        this.isEditModal = false;
        this.isViewModal = false;
        this.selectedRecs = [];
    }
    
    handleChange(event) {

      const field = event.target.name;
      const value = event.target.value;
      const recordId = event.target.dataset.id;

      this.selectedRecs = this.selectedRecs.map(rec => {
        if(rec.Id == recordId){
          return { ...rec, [field]: value}
        }
        return rec;
      });
  }
  showToast(title, message, variant) {
    this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
  }
}