import { LightningElement, wire } from 'lwc';
import getOppRecords from '@salesforce/apex/testLightingWebComponentController.getOppRecords';

const columns = [
    {label : "id", fieldName : "id"},
    {label : "test field", fieldName : "StartDate"}
]

export default class TestLightingWebComponent extends LightningElement {
    columns = columns;
    mappedData = [];

    // @wire(getOppRecords)
    // getOpp({ error, data }){
    //     if (data) {
    //         this.mappedData = data.map((element) => {
    //             return {
    //                 id: element.Id,
    //                 testField : element.TestField__c
    //             };
    //         });
    //     }else if(error){
    //         console.log(error);
    //     }
    // }

    // @wire(getOppRecords)
	// getOpp({ error, data }) {
	// 	if (data) {
	// 		this.mappedData = data.map((element) => {
	// 			return {
	// 				id: element.Id,
	// 				StartDate:element.TestField__c
	// 			};
	// 		});
	// 	} else if (error) {
	// 		console.error(error);
	// 	}
	// }

    @wire(getOppRecords)
    getopps({error, data}){
        if(data){
            this.mappedData = data.map((element) => {
                return {
                    id : element.Id,
                    StartDate : element.TestField__c
                }
            }
            );
        }else if(error){
            console.log(error);

        }

    }
}