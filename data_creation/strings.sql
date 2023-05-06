
CREATE OR REPLACE FUNCTION RandomChar(
		p_Characters IN VARCHAR2) RETURN VARCHAR2 IS
	l_res VARCHAR2(256);
	vvvv NUMBER;
BEGIN
	vvvv := round(dbms_random.value(0, length(p_Characters)-1));
	RETURN SUBSTR(p_Characters, vvvv, 1);
END;


CREATE OR REPLACE FUNCTION RandomString(
		p_Characters IN VARCHAR2,
		p_length IN NUMBER) RETURN VARCHAR2 IS
	l_res VARCHAR2(256);
BEGIN
	FOR i in 1..p_length LOOP
		l_res := l_res || RandomChar(p_Characters);
	END LOOP;
	RETURN l_res;
END;


CREATE OR REPLACE FUNCTION GenerateRandomName(
		min_chars IN NUMBER,
		max_chars IN NUMBER) RETURN VARCHAR2 IS
	value_ret VARCHAR2(1024);
	chars_count NUMBER;
	vvvv NUMBER;
BEGIN
	chars_count := dbms_random.value(min_chars, max_chars);
	value_ret := RandomChar('QWERTYUIOPASDFGHJKLZXCVBNMEYUIOA');
		
	FOR i in 1..chars_count/2 LOOP
		value_ret := value_ret || RandomChar('qwertyuiopasdfghjklzxcvbnm');
		value_ret := value_ret || RandomChar('qwertyuiopasdfghjklzxcvbnmaeoiuyaeoiuyaeoiuyaeoiuyaeoiuyaeoiuyaeoiuy');
	END LOOP;
	return value_ret;
END;


CREATE OR REPLACE FUNCTION SelectRandomName RETURN VARCHAR2 IS
	v VARCHAR2(64);
BEGIN
	SELECT first_name INTO v FROM imported_first_names ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	return v;
END;

CREATE OR REPLACE FUNCTION SelectRandomLastName RETURN VARCHAR2 IS
	v VARCHAR2(64);
BEGIN
	SELECT last_name INTO v FROM imported_last_names ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	return v;
END;

CREATE OR REPLACE FUNCTION GenerateRandomEntityName RETURN VARCHAR2 IS
	value_ret VARCHAR2(1024);
	names_count NUMBER;
	last_names_count NUMBER;
BEGIN
	
	names_count := round(dbms_random.value(1, 4));
	last_names_count := round(dbms_random.value(0, 2));
	
	value_ret := SelectRandomName();
	
	FOR i in 2..names_count LOOP
		value_ret := value_ret || ' ' || SelectRandomName();
	END LOOP;
	
	FOR i in 2..last_names_count LOOP
		value_ret := value_ret || ' ' || SelectRandomLastName();
	END LOOP;
	
	return value_ret;
END;


SELECT GenerateRandomEntityName FROM DUAL;

SELECT * FROM SYS.USER_ERRORS;

