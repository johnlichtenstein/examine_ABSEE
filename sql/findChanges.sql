-- count changes in a field from one table to next
with overlap as (
    select base.{keyn} as akey
        , base.{fn} as xbase
	, comp.{fn} as xcomp
    from {base} base
    inner join {comp} comp
        on comp.{keyn} = base.{keyn}
    )
    , unchanged as (
    select akey
    from overlap
    where xbase is NOT NULL
      and xcomp is NOT NULL
      and xbase = xcomp
       or xbase is NULL and xcomp is NULL
    )
    , fromnull as (
    select akey
    from overlap
    where xbase is NULL
      and xcomp is NOT NULL
    )
    , tonull as (
    select akey
    from overlap
    where xbase is NOT NULL
      and xcomp is NULL
    )
    , changed as (
    select akey
    from overlap
    where xbase is NOT NULL
      and xcomp is NOT NULL
      and xbase <> xcomp
    )
select '0: observations'        as cten, count(*) as n from overlap
union all select '1: unchanged' as cten, count(*) as n from unchanged
union all select '2: fromnull'  as cten, count(*) as n from fromnull
union all select '3: tonull'    as cten, count(*) as n from tonull
union all select '4: changed'   as cten, count(*) as n from changed
