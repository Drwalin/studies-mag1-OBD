
Partycjonowanie po timestamp
dodanie tabeli ze stanem w momencie rozpoczęcia partycji
dodanie triggerów na insert
dodanie tabeli z użytkownikami zajętymi (tylko dla tej aplikacji)

zoptymalizowana baza danych 


najszybsze pobranie losowego elementu z tablicy - wydajność == 2 * count(\*)
SELECT name FROM (SELECT name, ROWNUM rn FROM entities) WHERE rn = (SELECT floor(dbms\_random.value(0, (SELECT count(*) FROM entities)-1)) FROM DUAL);


