*&---------------------------------------------------------------------*
*& Report  /CPT/ADVENT1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent1_2.

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
                                FOR <lv_input> IN VALUE tt_input( FOR <ls_wa> IN lt_input ( REDUCE #( INIT lv_line = ||
                                                                                                      FOR i = 1 THEN i + 1 WHILE i <= count( val = <ls_wa> regex = '[0-9]|one|two|three|four|five|six|seven|eight|nine' )
                                                                                                      NEXT lv_line = lv_line  && SWITCH #( match( val   = <ls_wa>
                                                                                                                                                  regex = '[0-9]|one|two|three|four|five|six|seven|eight|nine'
                                                                                                                                                  occ   = i )
                                                                                                                                           WHEN 'one'   OR '1' THEN '1'
                                                                                                                                           WHEN 'two'   OR '2' THEN '2'
                                                                                                                                           WHEN 'three' OR '3' THEN '3'
                                                                                                                                           WHEN 'four'  OR '4' THEN '4'
                                                                                                                                           WHEN 'five'  OR '5' THEN '5'
                                                                                                                                           WHEN 'six'   OR '6' THEN '6'
                                                                                                                                           WHEN 'seven' OR '7' THEN '7'
                                                                                                                                           WHEN 'eight' OR '8' THEN '8'
                                                                                                                                           WHEN 'nine'  OR '9' THEN '9' ) ) ) )
                                NEXT lv_summe = lv_summe + CONV i( concat_lines_of( table = VALUE tt_input( ( substring_from( val = <lv_input> regex = '[0-9]' len = 1 ) )
                                                                                                            ( substring_from( val = <lv_input> regex = '[0-9]' occ = count( val = <lv_input> regex = '[1-9]' ) len = 1 ) ) ) ) ) ).

  ENDDO.

  GET TIME STAMP FIELD ende.

  WRITE: |{ lv_result } IN { EXACT #( ( ( ende - start ) / 1000 ) ) } SECONDS |.

ENDLOOP.
