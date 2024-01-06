with base as (
    select *
    from history
    where reportingPeriodBeginningDate = '{sd}'
    )
    , comp as (
    select * 
    from history
    where reportingPeriodBeginningDate = '{cd}'
    )
    , dropped as (
    select * 
    from base
    where assetNumber not in (select assetNumber from comp)
    )
select *
from dropped
