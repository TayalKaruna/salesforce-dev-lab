import { LightningElement, api } from 'lwc';
columns = [
    {label : "First Name", fieldName : 'FirstName', type :"text",  sortable : true},
    {label : "Last Name",  fieldName : 'LastName',  type :"text",  sortable : true},
    {label : "Email",      fieldName : 'Email',     type :"email", sortable : true},
    {label : "Phone",      fieldName : 'Phone',     type :"phone"}
];

export default class SelectedContactPrompt extends LightningElement {
    @api selectedRecs = [];
    @api selectedContactId = []
    @api showModal = false;
    columns = columns;

    connectedCallback() {
        console.log('selectedRecs received:', JSON.stringify(this.selectedRecs));
    }
    
    closeModal(){
        this.showModal = false;
        this.selectedContactId = [];
    }

    ViewRecord(event){
        this.selectedContactId = event.target.dataset.id;
        console.log('selected rec id'+this.selectedContactId);
        this.showModal = true;
    }
    get hasSelectedRecs() {
        return this.selectedRecs && this.selectedRecs.length > 0;
    }
}