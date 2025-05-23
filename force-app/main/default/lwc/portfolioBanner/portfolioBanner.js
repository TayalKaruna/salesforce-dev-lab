import { LightningElement, wire,api } from 'lwc';
import PortfolioAssets from '@salesforce/resourceUrl/PortfolioAssets';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
import FULLNAME from '@salesforce/schema/Portfolio__c.Full_Name__c'
import COMPANY_NAME from '@salesforce/schema/Portfolio__c.Company_Name__c'
import DESIGNATION from '@salesforce/schema/Portfolio__c.Designation__c'
import COMPANY_LOC from '@salesforce/schema/Portfolio__c.Company_Location__c'
// Example :- import TRAILHEAD_LOGO from '@salesforce/resourceUrl/trailhead_logo';' 

export default class PortfolioBanner extends LightningElement {
   @api recordId// = 'a005j00000UDDDHAA5'
    userPic = `${PortfolioAssets}/PortfolioAssets/userPic.jpeg`
   @api linkedInUrl //= 'https://www.linkedin.com/in/karunatayal/'
   @api twitterUrl //= 'https://www.twitter.com/karunatayal03';
   @api trailheadUrl //= 'https://www.salesforce.com/trailblazer/karunatayal';
   @api githubUrl //='https://www.github.com/TayalKaruna' 

linkedin = `${PortfolioAssets}/PortfolioAssets/Social/linkedin.svg`
twitter = `${PortfolioAssets}/PortfolioAssets/Social/twitter.svg`
trailhead = `${PortfolioAssets}/PortfolioAssets/Social/trailhead1.svg`
github = `${PortfolioAssets}/PortfolioAssets/Social/github.svg`

    @wire(getRecord, {recordId:'$recordId', fields:[FULLNAME,COMPANY_LOC,COMPANY_NAME,DESIGNATION]})
    portfolioData
    // portfolioHandler({data, error}){
    //     if(data){
    //         console.log("record Data", JSON.stringify(data))
    //     }
    //     if(error){
    //         console.error("error", error)
    //     }
    // }

    get fullName(){
        return getFieldValue(this.portfolioData.data, FULLNAME)
    }
    get companyLocation(){
        return getFieldValue(this.portfolioData.data, COMPANY_LOC)
    }
    get companyName(){
        return getFieldValue(this.portfolioData.data, COMPANY_NAME)
    }
    get designation(){
        return getFieldValue(this.portfolioData.data, DESIGNATION)
    }
}