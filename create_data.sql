
CREATE OR REPLACE FUNCTION RandomString(
		p_Characters IN VARCHAR2,
		p_length IN NUMBER) RETURN VARCHAR2 IS
	l_res VARCHAR2(256);
	vvvv NUMBER;
BEGIN
	FOR i in 1..p_length LOOP
		vvvv := round(dbms_random.value(0, length(p_Characters)-1));
		l_res := l_res || SUBSTR(p_Characters, vvvv, 1);
---		DBMS_OUTPUT.put_line(imi.cnt || ' imie: '||imi.imie||' ('||imi.nr||')');
	END LOOP;
	
---	SELECT
---		substr(
---			listagg(
---				substr(p_Characters, LEVEL, 1)
---			) WITHIN
---				GROUP(ORDER BY dbms_random.value),
---			1, p_length)
---	INTO l_res
---	FROM dual
---	CONNECT BY LEVEL <= length(p_Characters);
	RETURN l_res;
END;
/

CREATE OR REPLACE FUNCTION GenerateRandomName(
		min_chars IN NUMBER,
		max_chars IN NUMBER) RETURN VARCHAR2 IS
	value_ret VARCHAR2(1024);
	chars_count NUMBER;
BEGIN
	value_ret := RandomString('QWERTYUIOPASDFGHJKLZXCVBNMEYUIOA', 1) ||
		RandomString('qwertyuiopasdfghjklzxcvbnmaeoiuy', max_chars-1);
	return value_ret;
END;
/


SELECT GenerateRandomName(4, 10) FROM DUAL;
/

CREATE OR REPLACE PROCEDURE ClearAllData(
	entities_count IN NUMBER) IS
BEGIN
	DELETE FROM entities;
	DELETE FROM items;
	DELETE FROM transactions;
	DELETE FROM transaction_entries;
	DELETE FROM locations;
	DELETE FROM entities_entered_location;
END;



CREATE OR REPLACE PROCEDURE CreateEntities(
	entities_count IN NUMBER) IS
BEGIN
	INSERT INTO Tablice VALUES (valll);
END;











BEGIN
	etap1();
END;


SELECT * FROM V$PARAMETER WHERE name='nls_date_format';
ALTER SESSION SET nls_date_format = 'YYYY-MM-DD';

SELECT SYSDATE FROM DUAL;


DECLARE
	i INTEGER;
BEGIN
	INSERT INTO Tablice VALUES (45);
END;



CREATE OR REPLACE PROCEDURE InsertIntoTablice(
	valll IN int) IS
BEGIN
	INSERT INTO Tablice VALUES (valll);
END;

DECLARE
	i INTEGER;
BEGIN
	InsertIntoTablice(0);
END;




CREATE OR REPLACE FUNCTION InsertAndSumAll(
		valll IN NUMBER) RETURN NUMBER IS
	sumlll NUMBER := 13;
BEGIN
	INSERT INTO Tablice (VAL) VALUES (valll);
	--- SELECT sum(T.VAL) INTO sumlll FROM TABLICE AS T GROUP BY 1;
	RETURN valll;
END;

select * from SYS.USER_ERRORS where NAME = 'INSERTANDSUMALL' and type = 'FUNCTION';

DECLARE
	i NUMBER;
BEGIN
	dbms_output.enable();
	i := InsertAndSumAll(7);
	--- SELECT InsertAndSumAll(7) INTO i FROM DUAL;
	dbms_output.put_line('Sum all = '||i);
END;

SELECT*FROM Tablice;



DECLARE
	i INTEGER;
	r1 NUMBER;
	rseed NUMBER(20);
	ssv VARCHAR(128);
	xd Tablice%ROWTYPE;
BEGIN
	SELECT 12354 INTO rseed FROM DUAL;
	dbms_random.initialize(rseed);
	r1 := 123;
	

	SELECT 'Elo text from select:  ' INTO ssv FROM DUAL;
	SELECT * INTO xd FROM Tablice WHERE val=3;

	dbms_output.enable();

	FOR i IN 1 .. 10 LOOP
		r1 := dbms_random.value(1,10);
		dbms_output.put_line(ssv||xd.val||'      '||r1);
---		dbms_output.put_line(i);
	END LOOP;

	dbms_random.terminate;
END;




SELECT * FROM TABLICE t1 INNER JOIN TABLICE t2 ON t1.val = t2.val+2 OR t1.val = t2.val;j



---SELECT 2+2 FROM DUAL;

---SELECT :var+2 FROM dual;

---CREATE TABLE Tablice ( val INT);
---SELECT 2*2 INTO Tablice FROM DUAL;


---SELECT * FROM Tablice;






--INSERT INTO Tablice VALUES (3);

--SELECT * FROM TABLICE;







--- utl_file.fopen('student/temp', )































-- CREATE GLOBAL TEMPORARY TABLE
--	imiona_buf
--	(
--	 nr INTEGER,
--	 imie VARCHAR(20)
--	)
--ON COMMIT DELETE ROWS;

CREATE OR REPLACE PROCEDURE etap1 IS
--- DECLARE
	rseed NUMBER(20);
	r number;
	r1 number;
	r2 number;
	nr INTEGER;
	type va_imiona is varray(100) of VARCHAR2(10);
	imiona va_imiona := va_imiona();
	cursor c_imiona is SELECT count(imie) cnt, imie, min(nr) nr FROM imiona_buf GROUP BY imie ORDER BY cnt DESC;
BEGIN
	 DBMS_OUTPUT.enable();
	 DBMS_OUTPUT.put_line('losowanie');
	 SELECT to_number(to_char(sysdate, 'SSSSS')) INTO rseed FROM dual;
	 dbms_random.initialize(rseed);
	
	 FOR i IN 1 .. 100 LOOP
		 imiona.extend;
		 imiona(imiona.last) := DBMS_RANDOM.string('L',TRUNC(DBMS_RANDOM.value(4,8)));
	 END LOOP;
	
	 FOR i IN 1 .. 200 LOOP
		 r1 := dbms_random.value(0,50); -- od 1 do 100 bo 0+1 = 1 oraz 50 + 50 = 100
		 r2 := dbms_random.value(1,50);
		 nr := ROUND(r1+r2);
		 INSERT INTO imiona_buf VALUES(nr, imiona(nr));
	 END LOOP;
	
	 FOR imi in c_imiona LOOP
	 	DBMS_OUTPUT.put_line(imi.cnt || ' imie: '||imi.imie||' ('||imi.nr||')');
	 END LOOP;
	
	 dbms_random.terminate;
END;


BEGIN
	etap1();
END;
