clear screen;
drop table site_boards;

create table site_boards(
bid 		integer, 
card1 		integer, 
card2 		integer, 
card3 		integer, 
crit1 		integer, 
crit2 		integer, 
bet 		integer, 
status 		varchar2(20), 
earnings 	integer,
			PRIMARY KEY (bid)
);


--Insert data into the site_boards database
insert into site_boards values(1,2,15,28,100,36,5,'lose',0);


commit;

select * from site_boards;