SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
	
	runningboard int;
	
	amount int;
	amount2 int;
	
	stat site_boards.status%TYPE;
	

BEGIN
	SELECT MAX(bid) into runningboard FROM site_boards;
	SELECT bet into amount FROM site_boards WHERE bid=runningboard;
	SELECT bet into amount2 FROM server_boards@server61 WHERE bid=runningboard;
	
	SELECT status into stat FROM site_boards WHERE bid=runningboard;
	IF stat='win' THEN
		DBMS_OUTPUT.PUT_LINE('You won the board and earned '||amount2||'.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('You lose the board and lost '||amount||'.');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('SHUFFLE AGAIN to play another board of this special game.');
	
END;
/