----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- facility
----------------------------------------------------------------------------------
-- spec
create or replace package preference_curd_package
is
--    FUNCTION sel_pre_poc(pn_facility_id preference.facility_id%TYPE)
--    RETURN SYS_REFCURSOR;
    FUNCTION sel_pre_me_fun(pn_facility_id preference.facility_id%TYPE, pn_users_id preference.users_id%TYPE)
    RETURN SYS_REFCURSOR;
    PROCEDURE ins_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_facility_id preference.facility_id%TYPE,
        pn_users_id preference.users_id%TYPE
    );
    PROCEDURE upd_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_id preference.id%TYPE
    );
end preference_curd_package;
-- body
create or replace package body preference_curd_package
is  
--    FUNCTION sel_pre_poc(pn_facility_id preference.facility_id%TYPE)
--    RETURN SYS_REFCURSOR;
    FUNCTION sel_pre_me_fun(pn_facility_id preference.facility_id%TYPE, pn_users_id preference.users_id%TYPE)
    RETURN SYS_REFCURSOR
    IS preference_cur SYS_REFCURSOR;
    BEGIN
        OPEN preference_cur FOR
        select * from preference where facility_id = pn_facility_id AND users_id = pn_users_id;
        return preference_cur;
    END sel_pre_me_fun;
    
    PROCEDURE ins_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_facility_id preference.facility_id%TYPE,
        pn_users_id preference.users_id%TYPE
    )
    IS
    BEGIN
        INSERT INTO preference (liked, facility_id, users_id)
        VALUES (pc_liked, pn_facility_id, pn_users_id);
    END ins_pre_poc;
    
    PROCEDURE upd_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_id preference.id%TYPE
    )
    IS
    BEGIN
        UPDATE preference
        SET liked = pc_liked
        WHERE id = pn_id;
    END upd_pre_poc;
end preference_curd_package;
-- test
set serveroutput on
DECLARE
    v_facility_cur SYS_REFCURSOR;
    v_facility facility%ROWTYPE;
BEGIN
    v_facility_cur := facility_crud_package.sel_fac_fun;
    LOOP
        FETCH v_facility_cur INTO v_facility;
        EXIT WHEN v_facility_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('User ID: ' || v_facility.name);
    END LOOP;
    CLOSE v_facility_cur;
END;










----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- facility_info
----------------------------------------------------------------------------------
-- spec
CREATE OR REPLACE PACKAGE facility_info_crud_package IS
    FUNCTION sel_fac_info_fun (p_facility_id facility_info.facility_id%type) RETURN SYS_REFCURSOR;
END facility_info_crud_package;
/
-- body
CREATE OR REPLACE PACKAGE BODY facility_info_crud_package IS
    FUNCTION sel_fac_info_fun (p_facility_id facility_info.facility_id%type)
    RETURN SYS_REFCURSOR
    IS v_facilities_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_facilities_cursor FOR 
        SELECT * FROM facility_info WHERE facility_id = p_facility_id;
        RETURN v_facilities_cursor;
    END sel_fac_info_fun;
END facility_info_crud_package;
/
-- test
set serveroutput on
DECLARE
    v_facility_cur SYS_REFCURSOR;
    v_facility facility_info%ROWTYPE;
BEGIN
    v_facility_cur := facility_info_crud_package.sel_fac_info_fun(1);
    LOOP
        FETCH v_facility_cur INTO v_facility;
        EXIT WHEN v_facility_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('User ID: ' || v_facility.name);
    END LOOP;
    CLOSE v_facility_cur;
END;










----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- users
----------------------------------------------------------------------------------
-- spec
create or replace package users_crud_package
is
    procedure register_user(
        ps_userid users.userid%TYPE,
        ps_username users.username%TYPE,
        ps_email users.email%TYPE,
        ps_password users.password%TYPE
    );
    function authenticate_user(
        ps_userid users.userid%type,
        ps_password users.password%type
    ) return SYS_REFCURSOR;
    procedure validate_exist_user(
        ps_userid users.userid%type
    );
end users_crud_package;
/
-- body
create or replace package body users_crud_package
is
    procedure register_user(
        ps_userid users.userid%TYPE,
        ps_username users.username%TYPE,
        ps_email users.email%TYPE,
        ps_password users.password%TYPE
    )
    is
    begin
        validate_exist_user(ps_userid);
        INSERT INTO users (userid, username, email, password)
        VALUES (ps_userid, ps_username, ps_email, ps_password);
    end register_user;
    
    function authenticate_user(
        ps_userid users.userid%type,
        ps_password users.password%type
    ) return SYS_REFCURSOR
    is pc_user_info SYS_REFCURSOR;
    begin
        open pc_user_info for
        select * from users where userid = ps_userid and password = ps_password;
        return pc_user_info;
    end authenticate_user;
    
    procedure validate_exist_user(
        ps_userid users.userid%type
    )
    is
        v_count number;
    begin
        select count(*) into v_count
        from users
        where userid = ps_userid;
        
        if v_count > 0 then
            RAISE_APPLICATION_ERROR(-20001, 'This user already exists.');
        end if;
    exception
        when NO_DATA_FOUND then
            null;
    end validate_exist_user;
end users_crud_package;
/
-- test
set serveroutput on
DECLARE
    v_user_info SYS_REFCURSOR;
    v_user users%ROWTYPE;
BEGIN
-- register test    
--    users_crud_package.register_user('good1id', 'good1name', 'good1@example.com', 'good1pass');
    
-- login test
    v_user_info := users_crud_package.authenticate_user('jiyoonid', 'jiyoonpass');
    LOOP
        FETCH v_user_info INTO v_user;
        EXIT WHEN v_user_info%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('User ID: ' || v_user.userid);
        DBMS_OUTPUT.PUT_LINE('Username: ' || v_user.username);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_user.email);
        END LOOP;
    
    CLOSE v_user_info;
END;










----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- comments
----------------------------------------------------------------------------------
-- spec
CREATE OR REPLACE PACKAGE comments_curd_package
is
    FUNCTION sel_com_fun (pn_facility_id comments.facility_id%TYPE)
    RETURN SYS_REFCURSOR;
    PROCEDURE ins_com_poc (
        ps_content IN comments.content%TYPE,
        ps_createdby IN comments.createdby%TYPE,
        pn_facility_id IN comments.facility_id%TYPE,
        pn_users_id IN comments.users_id%TYPE
    );
    PROCEDURE upd_com_poc (
        ps_content IN comments.content%TYPE,
        pn_id IN comments.id%TYPE
    );
    PROCEDURE del_com_poc(pn_id comments.id%TYPE);
    PROCEDURE validate_exist_user(ps_users_id comments.users_id%TYPE);
    PROCEDURE validate_exist_facility(pn_facility_id comments.facility_id%TYPE);
end comments_curd_package;
-- body
CREATE OR REPLACE PACKAGE BODY comments_curd_package
IS
    FUNCTION sel_com_fun (pn_facility_id comments.facility_id%TYPE)
    RETURN SYS_REFCURSOR
    IS p_comment_list SYS_REFCURSOR;
    BEGIN
        OPEN p_comment_list FOR
        SELECT * FROM comments WHERE facility_id = pn_facility_id;
        RETURN p_comment_list;
    END sel_com_fun;

    PROCEDURE ins_com_poc (
        ps_content comments.content%TYPE,
        ps_createdby comments.createdby%TYPE,
        pn_facility_id comments.facility_id%TYPE,
        pn_users_id comments.users_id%TYPE
    )
    IS
    BEGIN
        INSERT INTO comments (content, createdat, createdby, modifiedat, facility_id, users_id)
        VALUES (ps_content, SYSDATE, ps_createdby, SYSDATE, pn_facility_id, pn_users_id);
    END ins_com_poc;
    
    PROCEDURE upd_com_poc (
        ps_content IN comments.content%TYPE,
        pn_id IN comments.id%TYPE
    )
    IS
    BEGIN
        UPDATE comments
        SET content = ps_content,
            modifiedat = SYSDATE
        WHERE id = pn_id;
    END upd_com_poc;
    
    PROCEDURE del_com_poc(pn_id comments.id%TYPE)
    IS
    BEGIN
        DELETE FROM comments
        WHERE id = pn_id;
    END del_com_poc;

    PROCEDURE validate_exist_user(ps_users_id comments.users_id%TYPE)
    IS
        v_count NUMBER;
    BEGIN
        SELECT count(*) INTO v_count
        FROM users
        WHERE id = ps_users_id;
        
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Userid does not exist.');
        END IF;
    EXCEPTION
        when NO_DATA_FOUND THEN
            null;
    END validate_exist_user;
    
    PROCEDURE validate_exist_facility(pn_facility_id comments.facility_id%TYPE)
    IS
        v_count NUMBER;
    BEGIN
        SELECT count(*) INTO v_count
        from facility
        where id = pn_facility_id;
        
        if v_count = 0 then
            RAISE_APPLICATION_ERROR(-20001, 'This facility does not exist.');
        end if;
    exception
        when NO_DATA_FOUND then
            null;
    end validate_exist_facility;

end comments_curd_package;
-- test
set serveroutput on
DECLARE
    v_comment_list SYS_REFCURSOR;
    v_comment comments%ROWTYPE;
BEGIN
--    comments_curd_package.ins_com_poc(
--        'this is comment',
--        'goodid',
--        999999999,
--        1);
    v_comment_list := comments_curd_package.sel_com_fun(3);
    LOOP
        FETCH v_comment_list INTO v_comment;
        EXIT WHEN v_comment_list%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('User ID: ' || v_comment.content);
        END LOOP;
    CLOSE v_comment_list;
    
--    comments_curd_package.upd_com_poc(
--        'this is comment',
--        1,
--        1);
--    comments_curd_package.del_com_poc(1, 1);
END;










----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- preference
----------------------------------------------------------------------------------
-- spec
create or replace package preference_curd_package
is
    FUNCTION sel_pre_poc(pn_facility_id preference.facility_id%TYPE)
    RETURN SYS_REFCURSOR;
    FUNCTION sel_pre_me_fun(pn_facility_id preference.facility_id%TYPE, pn_users_id preference.users_id%TYPE)
    RETURN preference.liked%TYPE;
    PROCEDURE ins_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_facility_id preference.facility_id%TYPE,
        pn_users_id preference.users_id%TYPE
    );
    PROCEDURE upd_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_id preference.id%TYPE
    );
end preference_curd_package;
-- body
create or replace package body preference_curd_package
is  
--    FUNCTION sel_pre_poc(pn_facility_id preference.facility_id%TYPE)
--    RETURN SYS_REFCURSOR;
    FUNCTION sel_pre_me_fun(pn_facility_id preference.facility_id%TYPE, pn_users_id preference.users_id%TYPE)
    RETURN preference.liked%TYPE
    IS v_liked preference.liked%TYPE;
    BEGIN
        select liked into v_liked from preference where facility_id = pn_facility_id AND users_id = pn_users_id;
        return v_liked;
    END sel_pre_me_fun;
    
    PROCEDURE ins_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_facility_id preference.facility_id%TYPE,
        pn_users_id preference.users_id%TYPE
    )
    IS
    BEGIN
        INSERT INTO preference (liked, facility_id, users_id)
        VALUES (pc_liked, pn_facility_id, pn_users_id);
    END ins_pre_poc;
    
    PROCEDURE upd_pre_poc(
        pc_liked preference.liked%TYPE,
        pn_id preference.id%TYPE
    )
    IS
    BEGIN
        UPDATE preference
        SET liked = pc_liked
        WHERE id = pn_id;
    END upd_pre_poc;
end preference_curd_package;
-- test
set serveroutput on
DECLARE
    v_pre_count NUMBER;
    v_liked preference.liked%TYPE;
BEGIN
    v_liked := preference_curd_package.sel_pre_me_fun(2, 1);
--    preference_curd_package.sel_pre_poc(1, v_pre_count);
    DBMS_OUTPUT.PUT_LINE(v_liked);
--    
--    preference_curd_package.upd_pre_poc('F', 1, 1);
END;