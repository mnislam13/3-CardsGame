
SET SERVEROUTPUT ON;
SET VERIFY OFF;



CREATE OR REPLACE TRIGGER mytrig616
AFTER UPDATE 
OF bet
ON site_boards
FOR EACH ROW
DECLARE
BEGIN
	DBMS_OUTPUT.PUT_LINE('Call has been taken.');
END;
/

CREATE OR REPLACE TRIGGER mytrig617
AFTER UPDATE 
OF status
ON site_boards
FOR EACH ROW
DECLARE
BEGIN
	DBMS_OUTPUT.PUT_LINE('Result declared. Run si_after_stat on server.');
END;
/

CREATE OR REPLACE PROCEDURE showcards(board IN int)
IS


temp int;
c1 VARCHAR2(20);
c2 VARCHAR2(20);
c3 VARCHAR2(20);

BEGIN
	--dbms_output.put_line('Your cards: * * *');
	--SELECT MAX(bid) into runningboard FROM site_boards;
	
	SELECT card1 into temp FROM site_boards WHERE bid=board;
	SELECT name into c1 FROM deckofcards@server61 WHERE cid=temp;
	
	SELECT card2 into temp FROM site_boards WHERE bid=board;
	SELECT name into c2 FROM deckofcards@server61 WHERE cid=temp;
	
	SELECT card3 into temp FROM site_boards WHERE bid=board;
	SELECT name into c3 FROM deckofcards@server61 WHERE cid=temp;
	
	dbms_output.put_line('Your cards: '||c1||' '||c2||' '||c3);
	--DBMS_OUTPUT.PUT_LINE('Run si_seencall_show_pack.sql file.');
	
END showcards;
/

CREATE OR REPLACE PROCEDURE packcards(board IN int)
IS


betamount int;

BEGIN
	--SELECT MAX(bid) into runningboard FROM site_boards;
	SELECT bet into betamount FROM site_boards WHERE bid=board;
	
	UPDATE site_boards SET status = 'lose', earnings=0 WHERE bid=board;
	UPDATE server_boards@server61 SET status = 'win', earnings=betamount WHERE bid=board;
	
	commit;
	
	DBMS_OUTPUT.PUT_LINE('Run si_after_stat.sql file on both.');
	
END packcards;
/


DECLARE
	ID int := &blindcall_1_seecards_2_pack_3;
	presentbet int;
	runningboard int;
	Invalid_Value EXCEPTION;

BEGIN
	dbms_output.put_line('Your cards: * * *');
	SELECT MAX(bid) into runningboard FROM site_boards;
	
	IF ID = 1 THEN --blind call
		SELECT bet into presentbet FROM site_boards WHERE bid = runningboard;
		presentbet := presentbet+1;
		dbms_output.put_line('increased bet: '||presentbet);
		UPDATE site_boards SET bet = presentbet WHERE bid=runningboard;
		commit;
		IF presentbet > 4 THEN
			--see cards procedure
			DBMS_OUTPUT.PUT_LINE('Run si_seencall_show_pack.sql file after server call.');
		END IF;
	ELSIF ID = 2 THEN 
		--see cards procedure
		showcards(runningboard);
	ELSIF ID = 3 THEN
		--pack cards procedure 
		packcards(runningboard);
	ELSE
		RAISE Invalid_Value;
	END IF;
	

EXCEPTION

	WHEN Invalid_Value THEN
		DBMS_OUTPUT.PUT_LINE('choice should be in between 1 to 3.');
		DELETE FROM site_boards WHERE bid = runningboard;
		DELETE FROM server_boards@server61 WHERE bid = runningboard;
		commit;
		dbms_output.put_line('Board dismissed');

	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Unknown Error.');
	
END;
/


