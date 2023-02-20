drop function if exists transfer_funds(_from bigint, _to bigint, amount numeric);
create or replace function transfer_funds(_from bigint, _to bigint, amount numeric) returns bigint as
$$
declare
    tx_id bigint;
begin
    update accounts set balance = balance - amount where id = _from;
    update accounts set balance = balance + amount where id = _to;

    insert into transactions(from_account_id, to_account_id, amount)
    values (_from, _to, amount)
    returning id into tx_id;

    return tx_id;
end;
$$ language plpgsql;
