*&---------------------------------------------------------------------*
*& Report  /CPT/ADVENT1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent1.

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

  DO 1000 TIMES.
    DATA(lv_result) = REDUCE i( INIT lv_summe = 0
                               FOR <ls_input> IN lt_input
                               NEXT lv_summe = lv_summe + CONV i( concat_lines_of( table = VALUE tt_input( ( substring_from( val = <ls_input> regex = '[1-9]' len = 1 ) )
                                                                                                           ( substring_from( val = <ls_input> regex = '[1-9]' occ = count( val = <ls_input> regex = '[1-9]' ) len = 1 ) ) ) ) ) ).

  ENDDO.

  GET TIME STAMP FIELD ende.

  WRITE: |{ lv_result } IN { EXACT #( ( ( ende - start ) / 1000 ) ) } SECONDS |.

ENDLOOP.
