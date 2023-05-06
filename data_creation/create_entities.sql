
CREATE OR REPLACE PROCEDURE CreateEntityTypes IS
BEGIN
	DELETE FROM entity_types;
	
	INSERT INTO entity_types VALUES ('player');
    INSERT INTO entity_types VALUES ('npc');
    INSERT INTO entity_types VALUES ('mob');
    INSERT INTO entity_types VALUES ('chest');
    INSERT INTO entity_types VALUES ('marketplace');
    INSERT INTO entity_types VALUES ('boss');
END;

CREATE OR REPLACE FUNCTION GetRandomEntityType RETURN VARCHAR2 IS
	v VARCHAR2(64);
	vv NUMBER;
BEGIN
	vv := dbms_random.value(0, 1000);
	IF vv < 800 THEN
		IF vv < 300 THEN
			RETURN 'npc';
		ELSE
			RETURN 'player';
		END IF;
	ELSE
		SELECT type INTO v FROM entity_types ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
		return v;
	END IF;
END;

CREATE OR REPLACE PROCEDURE CreateEntities(
	entities_count IN NUMBER) IS
BEGIN
	FOR i in 1..entities_count LOOP
		INSERT INTO entities VALUES (GenerateRandomEntityName, GetRandomEntityType());
	END LOOP;
END;

BEGIN
	CreateEntityTypes();
	CreateEntities(10);
END;

SELECT * FROM SYS.USER_ERRORS;

