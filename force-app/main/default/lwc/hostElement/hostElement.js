import { LightningElement, api } from 'lwc';

export default class HostElement extends LightningElement {
    @api title = 'Hello Constructor'
    @api message
    isLoading = true;
    count = 0;
    
    constructor(){
         console.log('Component constructed');
         super();
         console.log('super in constructor');
         console.log('count in constructor'+this.count);
         console.log('isLoading in constructor'+this.isLoading);
         console.log('title in constructor'+this.title);
         console.log('message in constructor'+this.message);
         console.log('css selector in constructor',this.template.querySelector("lightning-button"));
    }
    connectedCallback(){
        console.log('Component connected');
        console.log('Host element:', this.template.host);
    }
}