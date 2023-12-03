*&---------------------------------------------------------------------*
*& Report  /CPT/ADVENT1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent3_1.

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
                                FOR <lv_input> IN lt_input INDEX INTO lv_line
                                NEXT lv_summe = lv_summe
                                              + REDUCE i( init lv_summe_line = 0
                                                          FOR i = 1 THEN i + 1 WHILE i <= count( val = <ls_wa> regex = '[0-9]' )
                                                          NEXT lv_summe_line = lv_summe_line
                                                                             + COND #( LET bevor = i - 1 after = i + 1 in
                                                                                       WHEN ( lv_line > 1 
                                                                                            AND ( bevor > 1 and lt_input[ lv_line - 1 ]-table_line+bevor EQ '*' )
                                                                                               OR lt_input[ lv_line - 1 ]-table_line+i EQ '*'   
                                                                                               OR ( after <= strlen( lt_input[ lv_line - 1 ] )
                                                                                                and lt_input[ lv_line - 1 ]-table_line+after EQ '*' ) ) 
                                                                                                       OR ( lv_line < describe( lt_input ) 
                                                                                                           AND ( lt_input[ lv_line + 1 ]-table_line+bevor EQ '*'
                                                                                                              OR lt_input[ lv_line + 1 ]-table_line+i     EQ '*'   
                                                                                                              OR lt_input[ lv_line + 1 ]-table_line+after EQ '*' ) )
                                                                                                       OR ( lt_input[ lv_line ]-table_line+bevor EQ '*'
                                                                                                         OR lt_input[ lv_line ]-table_line+i     EQ '*'   
                                                                                                         OR lt_input[ lv_line ]-table_line+after EQ '*' )
                                                                                                      THEN lv_summe_line+i(1)
                                                                                                                                       
                                                                                       WHEN i eq strlength( <lv_input> )
                                                                                        THEN 2
                                                                                       ELSE 3
  ENDDO.

  GET TIME STAMP FIELD ende.

  WRITE: |{ lv_result } IN { EXACT #( ( ( ende - start ) / 1000 ) ) } SECONDS |.

ENDLOOP.
