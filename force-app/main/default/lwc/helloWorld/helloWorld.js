import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    name = "Zero to Hero"
    title = "Salesforce"
    
    handleChange(event){
        this.title = event.target.value;
    }
}