CLASS zcl_delete_data_table_d DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_DELETE_DATA_TABLE_D IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT * FROM zses_file_tabled
      INTO TABLE @FINAL(lt_draft).

    TRY.
        DELETE zses_file_tabled FROM TABLE @lt_draft.
        COMMIT WORK.
        out->write( |Delete  Success: zses_file_tabled| ).

      CATCH cx_sy_open_sql_db INTO FINAL(lx_sql).
        out->write( |Error  text: { lx_sql->get_text( ) } | ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
