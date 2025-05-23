import { LightningElement } from 'lwc';

export default class GetterMethod extends LightningElement {
    userList = ["Adam","Annie","John"]
    num1=30
    num2=10

    get firstUser(){
        return this.userList[0]    
    }

    get sum(){
        return this.num1+this.num2
    }

    get userNames(){
        return this.userList
    }
}