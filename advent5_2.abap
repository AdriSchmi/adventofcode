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
  DATA(lt_map) = VALUE tt_map( ).

  LOOP AT lt_split REFERENCE INTO DATA(lr_split).
    IF sy-tabix MOD 2 EQ 0.
      DO lt_split[ sy-tabix + 1 ] TIMES.
        APPEND VALUE #( seed = lr_split->* + ( sy-index - 1 ) ) TO lt_map.
      ENDDO.
    ENDIF.
  ENDLOOP.

  LOOP AT lt_map REFERENCE INTO DATA(lr_map).
    lr_map->result = lr_map->seed.
    DATA(lv_found) = abap_false.

    LOOP AT lt_input REFERENCE INTO DATA(lr_input) FROM 2.

      IF lr_input->* CA '0123456789'.
        IF lv_found EQ abap_false.
          SPLIT lr_input->* AT space INTO DATA(lv_dest_start) DATA(lv_source_start) DATA(lv_range).
          DATA(lv_source_ende) = lv_source_start + lv_range - 1.

          IF lr_map->result BETWEEN lv_source_start AND lv_source_ende.
            lr_map->result = ( lr_map->result - lv_source_start ) + lv_dest_start.
            lv_found = abap_true.
          ENDIF.
        ENDIF.
      ELSE.
        lv_found = abap_false.
      ENDIF.
    ENDLOOP.

  ENDLOOP.

  SORT lt_map BY result ASCENDING.
  WRITE / lt_map[ 1 ]-result.

ENDLOOP.
