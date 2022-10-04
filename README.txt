# 3-CardsGame
Date- 19 September, 2021.
ID: 170204061
NAME: Mohammad Najrul Islam
Project: Simple 3 cards game.

cards52 has deckofcards table which is only in server.

boards and si_boards have the boards table.

Run sequence::

server-> cards52.sql
server-> boards.sql
site-> si_boards.sql
server/site -> suffle.sql/si_suffle.sql

then, where suffle run we will run blindcall_see_pack.sql on other.
then, after call other will run the same.

if "see cards" then we will run seencall_show_pack.sql
if "pack" then we can run after_stat.sql on both side

if "show" then run there for_show.sql
