create or replace PROCEDURE generate_workers (pool NUMBER, first_post NUMBER, second_post NUMBER, third_post NUMBER, fourth_post NUMBER, fifth_post NUMBER, sixth_post NUMBER, seventh_post NUMBER) AS
type numbers IS VARRAY(7) OF NUMBER;
posts numbers;
sex NUMBER;
auxiliary NUMBER;
first_name VARCHAR2(4000);
last_name VARCHAR2(4000);
id_number NUMBER;
id_employee NUMBER;
login VARCHAR2(4000);
password_hash VARCHAR2(4000);
employment_date DATE;
pool_count NUMBER(2);

BEGIN

    posts := numbers(first_post, second_post, third_post, fourth_post, fifth_post, sixth_post, seventh_post);

    SELECT COUNT(*) into id_number FROM DANE_DO_LOGOWANIA;
    id_number := id_number+1;
    
    SELECT COUNT(*) into id_employee FROM PRACOWNICY;
    id_employee := id_employee+1;
	
	SELECT COUNT(*) into pool_count FROM BASENY;
	pool_count := pool_count - 1;

    IF pool=0 THEN
        FOR counter in 1..pool_count
        LOOP
        
            SELECT Data INTO employment_date FROM
            ( SELECT Data FROM PRZEGLADY WHERE Baseny_numer_obiektu = counter ORDER BY Data )
            WHERE rownum = 1;

            employment_date := employment_date - INTERVAL '2' YEAR;
            
            auxiliary := 1;
            FOR i in 1..7
            LOOP
                FOR j in 1..posts(auxiliary)
                LOOP
                    SELECT LOGIN into login FROM (SELECT LOGIN, ROWNUM AS RN FROM GENERATOR_LOGINS) WHERE RN = id_number;
                    SELECT PASSWORD_HASH into password_hash FROM (SELECT PASSWORD_HASH, ROWNUM AS RN FROM GENERATOR_PASSWORD_HASHES) WHERE RN = id_number;
    
                    sex := floor(DBMS_RANDOM.VALUE(0,2));
    
                    IF sex=0 THEN
                        SELECT IMIE into first_name FROM
                        ( SELECT IMIE FROM GENERATOR_MEN_NAMES ORDER BY dbms_random.value )
                        WHERE rownum = 1;
    
                        SELECT NAZWISKO into last_name FROM
                        ( SELECT NAZWISKO FROM GENERATOR_MEN_LASTS ORDER BY dbms_random.value )
                        WHERE rownum = 1;
                    ELSE
                        SELECT IMIE into first_name FROM
                        ( SELECT IMIE FROM GENERATOR_WOMEN_NAMES ORDER BY dbms_random.value )
                        WHERE rownum = 1;
    
                        SELECT NAZWISKO into last_name FROM
                        ( SELECT NAZWISKO FROM GENERATOR_WOMEN_LASTS ORDER BY dbms_random.value )
                        WHERE rownum = 1;
                    END IF;
    
                    INSERT INTO PRACOWNICY
                    VALUES (id_employee, first_name, last_name, 0, employment_date, null, i, counter);
    
                    INSERT INTO OSOBY
                    VALUES (id_number, null, null, id_employee);
    
                    INSERT INTO DANE_DO_LOGOWANIA
                    VALUES (id_number, login, password_hash, id_number);
    
                    id_number := id_number+1;
                    id_employee := id_employee+1;
                END LOOP;
            auxiliary := auxiliary+1;
            END LOOP;
        END LOOP;
    ELSE
    
        SELECT Data INTO employment_date FROM
        ( SELECT Data FROM PRZEGLADY WHERE Baseny_numer_obiektu = pool ORDER BY Data )
        WHERE rownum = 1;

        employment_date := employment_date - INTERVAL '2' YEAR;
    
        auxiliary := 1;
        FOR i in 1..7
        LOOP
            FOR j in 1..posts(auxiliary)
            LOOP
                SELECT LOGIN into login FROM (SELECT LOGIN, ROWNUM AS RN FROM GENERATOR_LOGINS) WHERE RN = id_number;
                SELECT PASSWORD_HASH into password_hash FROM (SELECT PASSWORD_HASH, ROWNUM AS RN FROM GENERATOR_PASSWORD_HASHES) WHERE RN = id_number;
    
                sex := floor(DBMS_RANDOM.VALUE(0,2));
    
                IF sex=0 THEN
                    SELECT IMIE into first_name FROM
                    ( SELECT IMIE FROM GENERATOR_MEN_NAMES ORDER BY dbms_random.value )
                    WHERE rownum = 1;
    
                    SELECT NAZWISKO into last_name FROM
                    ( SELECT NAZWISKO FROM GENERATOR_MEN_LASTS ORDER BY dbms_random.value )
                    WHERE rownum = 1;
                ELSE
                    SELECT IMIE into first_name FROM
                    ( SELECT IMIE FROM GENERATOR_WOMEN_NAMES ORDER BY dbms_random.value )
                    WHERE rownum = 1;
    
                    SELECT NAZWISKO into last_name FROM
                    ( SELECT NAZWISKO FROM GENERATOR_WOMEN_LASTS ORDER BY dbms_random.value )
                    WHERE rownum = 1;
                END IF;
    
                INSERT INTO PRACOWNICY
                VALUES (id_employee, first_name, last_name, 0, employment_date, null, i, pool);
    
                INSERT INTO OSOBY
                VALUES (id_number, null, null, id_employee);
    
                INSERT INTO DANE_DO_LOGOWANIA
                VALUES (id_number, login, password_hash, id_number);
    
                id_number := id_number+1;
                id_employee := id_employee+1;
            END LOOP;
        auxiliary := auxiliary+1;
        END LOOP;        
    END IF;
END;