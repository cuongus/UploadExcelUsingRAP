CLASS lhc_file DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR file
        RESULT result,

      getexceldata FOR DETERMINE ON SAVE
        IMPORTING keys FOR file~getexceldata,

      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE file,
      setstatustoopen FOR DETERMINE ON MODIFY
        IMPORTING keys FOR file~setstatustoopen,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR file RESULT result.

    CONSTANTS:
      BEGIN OF file_status,
        open      TYPE c LENGTH 1 VALUE 'M', "Not process
        accepted  TYPE c LENGTH 1 VALUE 'A', "Accepted
        rejected  TYPE c LENGTH 1 VALUE 'X', "Rejected
        completed TYPE c LENGTH 1 VALUE 'D', "Done
      END OF file_status.
ENDCLASS.


CLASS lhc_file IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD getexceldata.
    TYPES: BEGIN OF ty_excel,
             entrysheet TYPE string, " lblni,
             ebeln      TYPE ebeln,  " ebeln,
             ebelp      TYPE ebelp,  " ebelp,
             ext_number TYPE string, " lblne1,
             begdate    TYPE string, " lzvon,
             enddate    TYPE string, " lzbis,
             quantity   TYPE string, " mengev,
             fin_entry  TYPE string, " final,
           END OF ty_excel,
           tt_row TYPE STANDARD TABLE OF ty_excel.

    DATA lt_rows   TYPE tt_row.
    DATA lt_data   TYPE HASHED TABLE OF zuser_data_file WITH UNIQUE KEY ebeln ebelp.
    DATA lt_insert TYPE TABLE FOR CREATE zr_user_upload\\file\_datafile.
    DATA lt_update TYPE TABLE FOR UPDATE zr_user_upload\\datafile.
    DATA lt_create_preview TYPE TABLE FOR CREATE zr_user_upload\\file\_previewdata.

    " Read the parent instance
    READ ENTITIES OF zr_user_upload IN LOCAL MODE
         ENTITY file
         ALL FIELDS WITH
         CORRESPONDING #( keys )
         RESULT FINAL(lt_inv).

    " Get attachment value from the instance
    IF lt_inv IS INITIAL.
      RETURN.
    ELSE.
      FINAL(lv_attachment) = lt_inv[ 1 ]-attachment.
    ENDIF.

    FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
    FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

    FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
      )->row_stream(
      )->operation->write_to( REF #( lt_rows ) ).

    lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
               )->if_xco_xlsx_ra_operation~execute( ).

    IF lt_rows IS INITIAL.
      RETURN.
    ELSE.

      DELETE lt_rows INDEX 1.
      SORT lt_rows BY ebeln ebelp.
      DELETE ADJACENT DUPLICATES FROM lt_rows COMPARING ebeln ebelp.

      SELECT ebeln,
             ebelp
        FROM zuser_data_file
        FOR ALL ENTRIES IN @lt_rows
        WHERE ebeln = @lt_rows-ebeln
          AND ebelp = @lt_rows-ebelp
        INTO CORRESPONDING FIELDS OF TABLE @lt_data.

    ENDIF.

    CLEAR: lt_insert,
           lt_update,
           lt_create_preview.

    LOOP AT lt_inv ASSIGNING FIELD-SYMBOL(<f_file>).

      LOOP AT lt_rows INTO FINAL(ls_row).
        FINAL(lv_tabix) = sy-tabix.
       " DATA(lv_uuid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).


        APPEND VALUE #(
                        %is_draft = <f_file>-%is_draft
                        enduser   = <f_file>-enduser
                        zcount    = <f_file>-zcount
                        uuid      = <f_file>-Uuid
                        %target   = VALUE #( ( %cid     = lv_tabix
                                             %is_draft  = <f_file>-%is_draft
                                             "uuid       = <f_file>-Uuid
                                             uploaduuid = <f_file>-uuid
                                             enduser    = <f_file>-enduser
                                             zcount     = <f_file>-zcount
                                             ebeln      = ls_row-ebeln
                                             ebelp      = ls_row-ebelp
                                             entrysheet = ls_row-entrysheet
                                             extnumber  = ls_row-ext_number
                                             begdate    = ls_row-begdate
                                             enddate    = ls_row-enddate
                                             quantity   = ls_row-quantity
                                             finentry   = ls_row-fin_entry
                                             createdby  = <f_file>-createdby
                                             createdat  = <f_file>-createdat
                                             locallastchangedby = <f_file>-locallastchangedby
                                             locallastchangedat = <f_file>-locallastchangedat
                                             lastchangedat      = cl_abap_context_info=>get_system_time( ) ) ) )
            TO lt_create_preview.


        READ TABLE lt_data
            WITH TABLE KEY
            ebeln = ls_row-ebeln
            ebelp = ls_row-ebelp
            TRANSPORTING NO FIELDS.

        IF sy-subrc = 0.

          APPEND VALUE #( %is_draft          = <f_file>-%is_draft
                          ebeln              = ls_row-ebeln
                          ebelp              = ls_row-ebelp
                          entrysheet         = ls_row-entrysheet
                          extnumber          = ls_row-ext_number
                          begdate            = ls_row-begdate
                          enddate            = ls_row-enddate
                          quantity           = CONV menge_d( ls_row-quantity )
                          uuid               = <f_file>-uuid
                          enduser            = <f_file>-enduser
                          filename           = <f_file>-filename
                          zcount             = <f_file>-zcount
                          createdby          = <f_file>-createdby
                          createdat          = <f_file>-createdat
                          locallastchangedby = <f_file>-locallastchangedby
                          locallastchangedat = <f_file>-locallastchangedat
                          lastchangedat      = cl_abap_context_info=>get_system_time( ) )
                 TO lt_update.

        ELSE.

          APPEND VALUE #( %is_draft = <f_file>-%is_draft
                          uuid      = <f_file>-uuid
                          enduser   = <f_file>-enduser
                          zcount    = <f_file>-zcount
                          %target   = VALUE #( ( %cid               = lv_tabix
                                                 %is_draft          = <f_file>-%is_draft
                                                 ebeln              = ls_row-ebeln
                                                 ebelp              = ls_row-ebelp
                                                 entrysheet         = ls_row-entrysheet
                                                 extnumber          = ls_row-ext_number
                                                 begdate            = ls_row-begdate
                                                 enddate            = ls_row-enddate
                                                 quantity           = CONV menge_d( ls_row-quantity )
                                                 uuid               = <f_file>-uuid
                                                 enduser            = <f_file>-enduser
                                                 filename           = <f_file>-filename
                                                 zcount             = <f_file>-zcount
                                                 createdby          = <f_file>-createdby
                                                 createdat          = <f_file>-createdat
                                                 locallastchangedby = <f_file>-locallastchangedby
                                                 locallastchangedat = <f_file>-locallastchangedat
                                                 lastchangedat      = cl_abap_context_info=>get_system_time( ) ) ) )
                 TO lt_insert.

        ENDIF.

      ENDLOOP.
    ENDLOOP.

    IF lt_insert IS NOT INITIAL.
      MODIFY ENTITIES OF zr_user_upload IN LOCAL MODE
             ENTITY file
             CREATE BY \_datafile
             FIELDS ( ebeln ebelp
                      entrysheet extnumber
                      begdate enddate
                      quantity baseuom
                      finentry filename
                      uuid enduser zcount
                      createdby createdat
                      locallastchangedat
                      locallastchangedby
                      lastchangedat )
             WITH lt_insert.
    ENDIF.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_user_upload IN LOCAL MODE
             ENTITY datafile
             UPDATE FIELDS (
                      entrysheet extnumber
                      begdate enddate
                      quantity baseuom
                      finentry filename
                      uuid enduser zcount
                      createdby createdat
                      locallastchangedat
                      locallastchangedby
                      lastchangedat )
             WITH lt_update.

    ENDIF.

    IF lt_create_preview IS NOT INITIAL.
      "Step 3: Update new data
      MODIFY ENTITIES OF zr_user_upload IN LOCAL MODE
          ENTITY file
          CREATE BY \_previewdata
          FIELDS ( baseuom begdate createdat
                   createdby ebeln ebelp
                   enduser enddate entrysheet
                   extnumber finentry zcount
                   uploaduuid quantity
                   locallastchangedby locallastchangedat
                   lastchangedat  ) WITH lt_create_preview
                   MAPPED DATA(lt_pre_map)
                   REPORTED DATA(lt_pre_report)
                   FAILED DATA(lt_pre_fail).
    ENDIF.

    "Update Status C for table Header
    MODIFY ENTITIES OF zr_user_upload IN LOCAL MODE
      ENTITY file
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR ls_inv IN lt_inv (
                           %tky      = ls_inv-%tky
                           status    = file_status-completed ) ).


*    "Step 1: Read table preview data.
*    READ ENTITIES OF zr_user_upload IN LOCAL MODE
*        ENTITY file BY \_previewdata
*        ALL FIELDS WITH
*        CORRESPONDING #( keys )
*        RESULT DATA(lt_preview).
*
*    "Step 2: Delete data existed in table
*    MODIFY ENTITIES OF zr_user_upload IN LOCAL MODE
*        ENTITY previewdata
*        DELETE FROM VALUE #( FOR ls_preview IN lt_preview
*                                        (  %is_draft = ls_preview-%is_draft
*                                           %key      = ls_preview-%key  ) )
*        MAPPED DATA(lt_map_delete)
*        REPORTED DATA(lt_report_delete)
*        FAILED DATA(lt_fail_delete).


  ENDMETHOD.

  METHOD earlynumbering_create.
    LOOP AT entities
         ASSIGNING FIELD-SYMBOL(<f_entities>)
         WHERE uuid IS NOT INITIAL.

      APPEND CORRESPONDING #( <f_entities> ) TO mapped-file.

    ENDLOOP.

    DATA(lt_file) = entities.
    DELETE lt_file WHERE uuid IS NOT INITIAL.

    IF lt_file IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_file ASSIGNING <f_entities>.

      TRY.
          <f_entities>-uuid = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
          LOOP AT lt_file ASSIGNING <f_entities>.
            APPEND VALUE #( %cid      = <f_entities>-%cid
                            %key      = <f_entities>-%key
                            %is_draft = <f_entities>-%is_draft )
                   TO reported-file.
            APPEND VALUE #( %cid      = <f_entities>-%cid
                            %key      = <f_entities>-%key
                            %is_draft = <f_entities>-%is_draft )
                   TO failed-file.
          ENDLOOP.
          EXIT.
      ENDTRY.
      <f_entities>-enduser = sy-uname.

      " Get max requirement no
      SELECT SINGLE FROM zuser_upload
        FIELDS MAX( cnt ) + 1
        WHERE end_user = @sy-uname
        INTO @FINAL(max_cnt).

      SELECT SINGLE FROM zuser_upload_d
        FIELDS MAX( zcount ) + 1
        WHERE enduser = @sy-uname
        INTO @FINAL(max_cnt_d).

      IF max_cnt = max_cnt_d.
        <f_entities>-zcount = max_cnt + 1.
      ELSEIF max_cnt_d > max_cnt.
        <f_entities>-zcount = max_cnt_d.
      ELSE.
        <f_entities>-zcount = max_cnt.
      ENDIF.

      APPEND VALUE #( %cid      = <f_entities>-%cid
                      %key      = <f_entities>-%key
                      %is_draft = <f_entities>-%is_draft )
             TO mapped-file.
    ENDLOOP.
  ENDMETHOD.

  METHOD setstatustoopen.
    READ ENTITIES OF zr_user_upload IN LOCAL MODE
     ENTITY file
       FIELDS ( status )
       WITH CORRESPONDING #( keys )
     RESULT DATA(lt_file).

    "If Status is already set, do nothing
    DELETE lt_file WHERE status IS NOT INITIAL.
    CHECK lt_file IS NOT INITIAL.

    MODIFY ENTITIES OF zr_user_upload IN LOCAL MODE
      ENTITY file
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR ls_file IN lt_file ( %tky  = ls_file-%tky
                                              status = file_status-open ) ).
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zr_user_upload IN LOCAL MODE
            ENTITY file
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT FINAL(lt_header)
            FAILED failed.

    result = VALUE #(
        FOR ls_header IN lt_header
        ( %tky          = ls_header-%tky
          %action-edit  = COND #( WHEN ls_header-status = file_status-completed
                                  THEN if_abap_behv=>fc-o-disabled
                                  ELSE if_abap_behv=>fc-o-enabled )
          %delete = COND #( WHEN ls_header-status = file_status-completed
                                  THEN if_abap_behv=>fc-o-disabled
                                  ELSE if_abap_behv=>fc-o-enabled )
          %update = COND #( WHEN ls_header-status = file_status-completed
                                  THEN if_abap_behv=>fc-o-disabled
                                  ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

ENDCLASS.
