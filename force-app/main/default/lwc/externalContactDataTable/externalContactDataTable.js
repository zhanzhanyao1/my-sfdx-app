import { LightningElement, wire } from 'lwc';
import getContactRecords from '@salesforce/apex/externalContactDataTableController.getContactRecords';

const columns = [
    {label : "Shipping City", fieldName : "ShippingCity"},
    {label : "Year Started", fieldName : "YearStarted"}
]

export default class ExternalContactDataTable extends LightningElement {
    columns = columns;
    data = [];

    @wire(getContactRecords)
    getContact({error, data}){
        if(data){
            this.data = data.map((element) => {
                return {
                    ShippingCity : element.ShippingCity__c,
                    YearStarted : element.YearStarted__c
                }
            })
        }else if(error){
            console.log(error);
        }
    }

    handleRowAction(event){
        console.log('===============');
        const row = event.detail.row;
        console.log(JSON.stringify(row));

    }
}