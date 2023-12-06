*&---------------------------------------------------------------------*
*& Report  /CPT/ADVENT1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT /cpt/advent5_2.

TYPES tt_input TYPE TABLE OF string WITH EMPTY KEY.
TYPES: BEGIN OF ts_seed,
         low  TYPE numc10,
         high TYPE numc10,
       END OF ts_seed,
       BEGIN OF ts_map,
         from TYPE ts_seed,
         dest TYPE ts_seed,
       END OF ts_map,

       tt_seed_line TYPE TABLE OF ts_seed WITH EMPTY KEY,
       tt_seed      TYPE TABLE OF tt_seed_line WITH EMPTY KEY,
       tt_map_line  TYPE TABLE OF ts_map WITH EMPTY KEY,
       tt_map       TYPE TABLE OF tt_map_line WITH EMPTY KEY.


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

  DATA(lt_seed) = VALUE tt_seed( ( VALUE #( FOR i = 1 THEN i + 1 WHILE i <= lines( lt_split ) DIV 2
                                          ( low  = lt_split[ i * 2 ]
                                            high = lt_split[ i * 2 ] + lt_split[ i * 2 + 1 ] - 1 ) ) ) ).

  DATA(lt_map)      = VALUE tt_map( ).
  DATA(lt_map_line) = VALUE tt_map_line( ).

  LOOP AT lt_input REFERENCE INTO DATA(lr_input) FROM 2.
    IF lr_input->* CA '0123456789'.
      SPLIT lr_input->* AT space INTO DATA(lv_dest_start) DATA(lv_source_start) DATA(lv_range).
      APPEND VALUE #( from = VALUE #( low  = lv_source_start
                                      high = lv_source_start + lv_range )
                      dest = VALUE #( low  = lv_dest_start
                                      high = lv_dest_start + lv_range ) ) TO lt_map_line.
    ELSEIF lines( lt_map_line ) > 0.
      APPEND lt_map_line TO lt_map.
      CLEAR lt_map_line[].
    ENDIF.
  ENDLOOP.

  LOOP AT lt_map REFERENCE INTO DATA(lr_map) WHERE table_line IS NOT INITIAL.
    DATA(lt_seed_line) = lt_seed[ sy-tabix ].
    APPEND INITIAL LINE TO lt_seed REFERENCE INTO DATA(lr_seed_next).
    LOOP AT lt_seed_line REFERENCE INTO DATA(lr_seed).
      LOOP AT lr_map->* REFERENCE INTO DATA(lr_map_line) WHERE from-low <= lr_seed->high AND from-high >= lr_seed->low.
        IF lr_map_line->from-low <= lr_seed->low AND lr_map_line->from-high >= lr_seed->high.
          APPEND VALUE #( low  = lr_map_line->dest-low + ( lr_seed->low  - lr_map_line->from-low ) high = lr_map_line->dest-low + ( lr_seed->high - lr_map_line->from-low ) ) TO lr_seed_next->*.
        ELSEIF lr_map_line->from-low <= lr_seed->low AND lr_map_line->from-high < lr_seed->high.
          APPEND VALUE #( low  = lr_map_line->from-high + 1 high = lr_seed->high ) TO lt_seed_line.
          APPEND VALUE #( low  = lr_map_line->dest-low + ( lr_seed->low  - lr_map_line->from-low ) high = lr_map_line->dest-high ) TO lr_seed_next->*.
        ELSEIF lr_map_line->from-low > lr_seed->low AND lr_map_line->from-high >= lr_seed->high.
          APPEND VALUE #( low = lr_seed->low high = lr_map_line->from-low - 1 ) TO lt_seed_line.
          APPEND VALUE #( low = lr_map_line->dest-low high = lr_map_line->dest-low + ( lr_seed->high - lr_map_line->from-low ) ) TO lr_seed_next->*.
        ELSEIF lr_map_line->from-low > lr_seed->low AND lr_map_line->from-high < lr_seed->high.
          APPEND VALUE #( low = lr_map_line->from-high + 1 high = lr_seed->high ) TO lt_seed_line.
          APPEND VALUE #( low = lr_seed->low high = lr_map_line->from-low - 1 ) TO lt_seed_line.
          APPEND VALUE #( low  = lr_map_line->dest-low high = lr_map_line->dest-high ) TO lr_seed_next->*.
        ENDIF.
      ENDLOOP.
      IF sy-subrc IS NOT INITIAL.
        APPEND VALUE #( low = lr_seed->low high = lr_seed->high ) TO lr_seed_next->*.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  DATA(result) = lt_seed[ lines( lt_seed ) ].
  SORT result BY low ASCENDING.
  WRITE result[ 1 ]-low.

ENDLOOP.
