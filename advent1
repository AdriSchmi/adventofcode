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

  WRITE reduce i( init lv_summe = 0
                  for <ls_input> in lt_input
                  next lv_summe = lv_summe + conv i( concat_lines_of( table = value tt_input( ( substring_from( val = <ls_input> regex = '[0-9]' len = 1 ) )
                                                                                              ( substring_from( val = <ls_input> regex = '[0-9]' occ = count( val = <ls_input> regex = '[0-9]' ) len = 1 ) ) ) ) ) ).

ENDLOOP.
