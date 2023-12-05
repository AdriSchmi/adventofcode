*&---------------------------------------------------------------------*
*& Report  /CPT/ADVENT1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent5_2.

TYPES tt_input TYPE TABLE OF string WITH EMPTY KEY.
TYPES: BEGIN OF ts_map,
         seed   TYPE numc10,
         result TYPE numc10,
       END OF ts_map,
       tt_map TYPE TABLE OF ts_map WITH EMPTY KEY.


DATA: lt_filetable TYPE filetable.
DATA: lv_rc        TYPE i.
DATA: lt_input     TYPE tt_input.

cl_gui_frontend_services=>file_open_dialog(
    CHANGING
      file_table              = lt_filetable
      rc                      = lv_rc ).

LOOP AT lt_filetable REFERENCE INTO DATA(lr_filetable).

  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename = CONV #( lr_filetable->filename )
    CHANGING
      data_tab = lt_input ).

  DATA(lt_split) = VALUE tt_input( ).
  SPLIT lt_input[ 1 ] AT space INTO TABLE lt_split.

  DATA(lv_result) = ||.

  LOOP AT VALUE tt_input( FOR i = 1 THEN i + 1 WHILE i <= lines( lt_split ) DIV 2
                        ( LINES OF VALUE #( FOR j = 0 THEN j + 1 WHILE j < lt_split[ ( i * 2 ) + 1 ]
                                          ( lt_split[ i * 2 ] + j ) ) ) ) REFERENCE INTO DATA(lr_seed).
    
    DATA(lv_found) = abap_false.

    LOOP AT lt_input REFERENCE INTO DATA(lr_input) FROM 2.
      IF lr_input->* CA '0123456789'.
        IF lv_found EQ abap_false.
          SPLIT lr_input->* AT space INTO DATA(lv_dest_start) DATA(lv_source_start) DATA(lv_range).

          IF lr_seed->* BETWEEN lv_source_start AND EXACT #( lv_source_start + lv_range - 1 ).
            lr_seed->* = ( lr_seed->* - lv_source_start ) + lv_dest_start.
            lv_found = abap_true.
          ENDIF.
        ENDIF.
      ELSE.
        lv_found = abap_false.
      ENDIF.
    ENDLOOP.

    lv_result = COND #( WHEN lr_seed->* <= lv_result OR lv_result IS INITIAL THEN lr_seed->* ELSE lv_result ).

  ENDLOOP.

  WRITE lv_result.
ENDLOOP.
