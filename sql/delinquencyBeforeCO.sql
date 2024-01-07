with mindate as (select min(reportingPeriodBeginningDate) as mind from history)
    , chargeoff as (
    select distinct assetNumber, zeroBalanceCode
    from history
    where zeroBalanceCode = '4.0'
    )
    , repurchase as (
    select distinct assetNumber, zeroBalanceCode
    from history
    where zeroBalanceCode = '3.0'
    )
    , sold as (
    select distinct assetNumber, zeroBalanceCode
    from history
    where zeroBalanceCode = '2.0'
    )
    , overlap as (
    select '00 accounts' as cten, count(*) as n
        from history
	inner join mindate
	    on mindate.mind = history.reportingPeriodBeginningDate
    union all select '01 chargeoff' as cten, count(*) as n from chargeoff  
    union all select '02 repurchase' as cten, count(*) as n from repurchase
    union all select '03 third party' as cten, count(*) as n from sold
    union all select '12 co and rep' as cten, count(*) as n
        from chargeoff
	inner join repurchase
	    on chargeoff.assetNumber = repurchase.assetNumber
    union all select '13 co and sold' as cten, count(*) as n
        from chargeoff
	inner join sold
	    on chargeoff.assetNumber = sold.assetNumber
    union all select '23 repurchase and sold' as cten, count(*) as n
        from repurchase
	inner join sold
	    on repurchase.assetNumber = sold.assetNumber
    union all select '30 just everything' as cten, count(*) as n
        from repurchase
	inner join sold
	    on repurchase.assetNumber = sold.assetNumber
	inner join chargeoff
    )
    , cohist as (
    select hist.assetNumber, hist.reportingPeriodBeginningDate
        , hist.zeroBalanceCode
	, hist.currentDelinquencyStatus
        , hist.totalActualAmountPaid, hist.modificationtypecode
        , hist.reportingPeriodModificationIndicator
	, hist.repossessedIndicator, hist.recoveredAmount
    from chargeoff
    inner join history hist
        on hist.assetNumber = chargeoff.assetNumber
    )

{final}
