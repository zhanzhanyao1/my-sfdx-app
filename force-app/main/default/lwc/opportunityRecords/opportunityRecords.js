import { LightningElement, api, wire } from "lwc";
import getOpportunityProjectAccounts from "@salesforce/apex/OpportunityRecordsControllers.getOpportunityProjectAccounts";

const columns = [
	{
		label: "id",
		fieldName: "id"
	},
	{
		label: "start date",
		fieldName: "StartDate",
	}
];

export default class OpportunityProjectTeamTable extends LightningElement {
	@api recordId;

	columns = columns;
	mappedData = [];


	@wire(getOpportunityProjectAccounts, { oppId: "$recordId" })
	populateMappedData({ error, data }) {
		if (data) {
			this.mappedData = data.map((element) => {
				return {
					id: element.Id,
					StartDate:element.End_Year__c
				};
			});
		} else if (error) {
			console.error(error);
		}
	}
}