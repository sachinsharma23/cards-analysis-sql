-- step 1) validation checks
-- total rows loaded (data load confirm)
select count(*) as total_rows
from cards;

-- preview data (columns dekhne ke liye)
select *
from cards
limit 10;

-- check null client ids (ideally 0)
select count(*) as null_client_ids
from cards
where client_id is null;

-- distinct card types (dataset me kya types hain)
select distinct card_type
from cards;

-- credit limit preview (format check: $ and comma hai ya nahi)
select credit_limit
from cards
limit 10;

-- brand distribution test (kaunsa brand zyada common hai)
select
  card_brand,
  count(*) as total_cards
from cards
group by card_brand
order by total_cards desc;

-- step 2) Data prep
alter table cards
add column if not exists credit_limit_num numeric;

update cards
set credit_limit_num = translate(credit_limit, '$,', '')::numeric
where credit_limit_num is null;

-- quick verify: $1,648 = 1648 ? 
select credit_limit, credit_limit_num
from cards
limit 10;

-- step 3) analysis queries
-- q1) total cards and unique clients
select
  count(*) as total_cards,
  count(distinct client_id) as unique_clients
from cards;

-- q2) cards distribution by card brand
select
  card_brand,
  count(*) as total_cards
from cards
group by card_brand
order by total_cards desc;

-- q3) cards distribution by card type
select
  card_type,
  count(*) as total_cards
from cards
group by card_type
order by total_cards desc;

-- q4) average credit limit by brand
select
  card_brand,
  avg(credit_limit_num) as avg_credit_limit
from cards
group by card_brand
order by avg_credit_limit desc;

-- q5) top 10 clients by total credit exposure
select
  client_id,
  count(*) as total_cards,
  sum(credit_limit_num) as total_credit_exposure
from cards
group by client_id
order by total_credit_exposure desc
limit 10;

-- q6) clients holding multiple cards (2 or more)
select
  client_id,
  count(*) as total_cards
from cards
group by client_id
having count(*) >= 2
order by total_cards desc;

-- q7) credit limit segmentation (low / medium / high)
select
  case
    when credit_limit_num < 5000 then 'low'
    when credit_limit_num between 5000 and 10000 then 'medium'
    else 'high'
  end as credit_bucket,
  count(*) as total_cards,
  avg(credit_limit_num) as avg_limit
from cards
group by credit_bucket
order by total_cards desc;

-- q8) card issuance distribution (readable labels)
select
  case
    when num_cards_issued = 1 then 'single card issued'
    when num_cards_issued = 2 then 'two cards issued'
    else 'multiple cards issued (3+)'
  end as issuance_category,
  count(*) as total_records
from cards
group by issuance_category
order by total_records desc;

-- q9) chip vs non-chip comparison
select
  has_chip,
  count(*) as total_cards,
  avg(credit_limit_num) as avg_credit_limit
from cards
group by has_chip
order by total_cards desc;

-- q10) rank brands by total credit exposure (window function)
with brand_exposure as (
  select
    card_brand,
    sum(credit_limit_num) as total_credit_exposure
  from cards
  group by card_brand
)
select
  card_brand,
  total_credit_exposure,
  rank() over (order by total_credit_exposure desc) as brand_rank
from brand_exposure
order by brand_rank;

  total_credit_exposure,
  rank() over (order by total_credit_exposure desc) as brand_rank
from brand_exposure
order by brand_rank;
