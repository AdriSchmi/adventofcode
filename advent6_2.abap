*&---------------------------------------------------------------------*
*& Report  /CPT/ADVENT1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent6_1.

TYPES tt_input TYPE TABLE OF string WITH EMPTY KEY.

DATA: lt_filetable TYPE filetable.
DATA: lv_rc        TYPE i.
DATA: lt_input     TYPE tt_input.

DATA: start        TYPE timestampl.
DATA: ende         TYPE timestampl.

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

  GET TIME STAMP FIELD start.

  SPLIT condense( lt_input[ 1 ] ) AT space INTO DATA(lv_desc_time) DATA(lv_time).
  SPLIT condense( lt_input[ 2 ] ) AT space INTO DATA(lv_desc_dist) DATA(lv_dist).

  CONDENSE lv_time NO-GAPS.
  CONDENSE lv_dist NO-GAPS.

  DATA(lv_result) = ( round( val = ( ( lv_time / 2 ) + sqrt( ( lv_dist * -1 ) + ( ( lv_time * lv_time ) / 4 ) ) - 1 ) dec = 0 mode = cl_abap_math=>round_up )
                    - round( val = ( ( lv_time / 2 ) - sqrt( ( lv_dist * -1 ) + ( ( lv_time * lv_time ) / 4 ) ) + 1 ) dec = 0 mode = cl_abap_math=>round_down ) + 1 ).


  GET TIME STAMP FIELD ende.

  WRITE: |{ lv_result } IN { EXACT #( ende - start )  } SECONDS |.

ENDLOOP.
