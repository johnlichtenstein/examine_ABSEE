with maxrep as (
    select assetNumber, max(reportingPeriodBeginningDate) as lastRepDate
    from history
    group by 1
    )
    , maxhist as (
    select max(reportingPeriodBeginningDate) as maxRepDate
    from history
    )
    , earlylast as (
    select *
    from maxrep
    where lastRepDate < (select maxRepDate from maxhist)
    )
    , lastentry as (
    select earlylast.assetNumber, hist.reportingPeriodBeginningDate
        , hist.zeroBalanceCode, hist.currentDelinquencyStatus
    from earlylast
    inner join history hist
        on hist.reportingPeriodBeginningDate = earlylast.lastRepDate
	and hist.assetNumber = earlylast.assetNumber
    )
    , checker as (
    select '0maxrep' as cten, count(*) as n from maxrep
    union all select '1early' as cten, count(*) as n from earlylast
    union all select '2last' as cten, count(*) as n from lastentry
    )
    , report as (
    select zeroBalanceCode, count(*) as n
    from lastentry
    group by 1 order by 1
    )
{final}
-- select *
-- from report
-- from checker
-- order by cten
