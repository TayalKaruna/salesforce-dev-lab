import { LightningElement, track } from 'lwc';

export default class TrackProperty extends LightningElement {
    fullName="Karuna Tayal"
    title = "sfdc"
    @track address = {
        city:"Noida",
        state:"UP",
        country:"India"
    }
    handleChange(event){
         // WITH TRACK PROPERTY
        //  this.address.city = event.target.value
       //   WITHOUT TRACK PROPERTY
       console.log('before'+JSON.stringify(this.address));
       this.address = {...this.address,"city":event.target.value}
       console.log('after'+JSON.stringify(event.target.value));
    }
}