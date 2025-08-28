trigger AccountTrigger on Account (after update) {
    
    //【简单版】

    // 获取发生更新的 Account
    Account acct = Trigger.new[0];
    
    // 查询所有相关联的 Opportunity，得到 Opportunity 列表
    List<Opportunity> opportunityList = [
    	SELECT Id
    	FROM   Opportunity
     	WHERE  AccountId = :acct.Id
    ];

    // 更改 Opportunity 列表中的 Opportunity Priority 为 "Primary"
    for (Opportunity oppty : opportunityList) {
        if (acct.SLA__c == 'Platinum') { oppty.Priority__c = 'Primary'; }
    }
    
    // 更新所有变更的 Opportunity
    update opportunityList;
}