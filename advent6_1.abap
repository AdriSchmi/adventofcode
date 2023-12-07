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

  SPLIT condense( lt_input[ 1 ] ) AT space INTO TABLE DATA(lt_time).
  SPLIT condense( lt_input[ 2 ] ) AT space INTO TABLE DATA(lt_dist).

  DATA(lv_result) = 1.

  LOOP AT lt_time REFERENCE INTO DATA(lr_time) FROM 2.

    lv_result = lv_result * ( round( val = ( ( lr_time->* / 2 ) + sqrt( ( ( lt_dist[ sy-tabix ] ) * -1 ) + ( ( lr_time->* * lr_time->* ) / 4 ) ) - 1 ) dec = 0 mode = cl_abap_math=>round_up )
                            - round( val = ( ( lr_time->* / 2 ) - sqrt( ( ( lt_dist[ sy-tabix ] ) * -1 ) + ( ( lr_time->* * lr_time->* ) / 4 ) ) + 1 ) dec = 0 mode = cl_abap_math=>round_down ) + 1 ).

  ENDLOOP.

  GET TIME STAMP FIELD ende.

  WRITE: |{ lv_result } IN { EXACT #( ende - start )  } SECONDS |.

ENDLOOP.
