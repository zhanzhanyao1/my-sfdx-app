public with sharing class OpportunityRecordsControllers {
	//isUniqueIdAlreadySet prevents recursion in ProjectAccountTrigger

	@AuraEnabled(cacheable=true)
	public static List<Opportunity> getOpportunityProjectAccounts(
		String oppId
	) {
		return [
			SELECT Id, End_Year__c FROM Opportunity WHERE Id = :oppId
		];
	}

}