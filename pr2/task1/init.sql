drop table if exists accounts cascade;
create table if not exists accounts
(
    id      bigserial primary key,
    name    text                                          not null,
    balance numeric
        constraint balance_gt_zero check ( balance >= 0 ) not null
);

drop table if exists transactions cascade;
create table if not exists transactions
(
    id              bigserial primary key,
    from_account_id bigserial references accounts (id)  not null,
    to_account_id   bigserial references accounts (id)  not null,
    amount          numeric
        constraint amount_gt_zero check ( amount >= 0 ) not null
);

truncate accounts cascade;
insert into accounts
values (1, 'alice', 1000.00),
       (2, 'bob', 100.00),
       (3, 'bob', 900.00);

