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

  WRITE REDUCE i( INIT lv_summe = 0
                  FOR <lv_input> IN value tt_input( for <ls_wa> IN lt_input ( SWITCH #( match( val   = <ls_wa>
                                                                                              regex = '[1-9]|one|two|three|four|five|six|seven|eight|nine'
                                                                                              occ   = 1 )
                                                                                       WHEN 'one'   OR '1' THEN '1'
                                                                                       WHEN 'two'   OR '2' THEN '2'
                                                                                       WHEN 'three' OR '3' THEN '3'
                                                                                       WHEN 'four'  OR '4' THEN '4'
                                                                                       WHEN 'five'  OR '5' THEN '5'
                                                                                       WHEN 'six'   OR '6' THEN '6'
                                                                                       WHEN 'seven' OR '7' THEN '7'
                                                                                       WHEN 'eight' OR '8' THEN '8'
                                                                                       WHEN 'nine'  OR '9' THEN '9' )
                                                                          && SWITCH #( LET lv_reverse = reverse( <ls_wa> ) IN
                                                                                       match( val = reverse( <ls_wa> )
                                                                                              regex = '[1-9]|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin'
                                                                                              occ   = 1 )
                                                                                       WHEN 'eno'  OR '1' THEN '1'
                                                                                       WHEN 'owt'   OR '2' THEN '2'
                                                                                       WHEN 'eerht' OR '3' THEN '3'
                                                                                       WHEN 'ruof'  OR '4' THEN '4'
                                                                                       WHEN 'evif'  OR '5' THEN '5'
                                                                                       WHEN 'xis'   OR '6' THEN '6'
                                                                                       WHEN 'neves' OR '7' THEN '7'
                                                                                       WHEN 'thgie' OR '8' THEN '8'
                                                                                       WHEN 'enin'  OR '9' THEN '9' ) ) )
                  NEXT lv_summe = lv_summe + CONV i( concat_lines_of( table = VALUE tt_input( ( substring_from( val = <lv_input> regex = '[1-9]' len = 1 ) )
                                                                                              ( substring_from( val = <lv_input> regex = '[1-9]' occ = count( val = <lv_input> regex = '[1-9]' ) len = 1 ) ) ) ) ) ).

ENDLOOP.
