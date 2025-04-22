CLASS zcl_add_data_table_d DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_ADD_DATA_TABLE_D IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lt_data TYPE STANDARD TABLE OF zuuid_data_file,
          ls_data TYPE zuuid_data_file.

    SELECT * FROM zuser_data_file
      INTO TABLE @DATA(lt_file).

    SELECT *
        FROM zuser_upload
        FOR ALL ENTRIES IN @lt_file
        WHERE end_user  = @lt_file-end_user
        AND cnt = @lt_file-zcount
        AND filename = @lt_file-filename
        INTO TABLE @DATA(lt_upload).

    LOOP AT lt_upload INTO DATA(ls_upload).

      LOOP AT lt_file INTO DATA(ls_file)
       WHERE end_user = ls_upload-end_user
       AND zcount = ls_upload-cnt.

        MOVE-CORRESPONDING ls_file TO ls_data.
        ls_data-uuid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        ls_data-upload_uuid = ls_upload-uuid.
        ls_data-end_user = ls_upload-end_user.
        ls_data-cnt = ls_upload-cnt.
        APPEND ls_data TO lt_data.
        CLEAR ls_data.


      ENDLOOP.

    ENDLOOP.




    TRY.
        MODIFY zuuid_data_file FROM TABLE @lt_data.
        COMMIT WORK.
        out->write( |Modify table is success.| ).

      CATCH cx_sy_open_sql_db INTO FINAL(lx_sql).
        out->write( |Error  text: { lx_sql->get_text( ) } | ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
