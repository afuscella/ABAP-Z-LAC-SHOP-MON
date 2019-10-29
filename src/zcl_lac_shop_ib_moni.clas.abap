class ZCL_LAC_SHOP_IB_MONI definition
  public
  inheriting from ZCA_LAC_REPORT
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IS_SELECTION_FIELDS type ZLAC_SHOP_IB_MONI_SELECTION optional
      !IO_SCREEN_HELPER type ref to ZCL_LAC_SHOP_IB_MONI_HELPER optional
      !IO_SALV_WRAP type ref to ZCA_LAC_SALV_WRAP optional .

  methods ZIF_LAC_REPORT~FINALIZE
    redefinition .
  methods ZIF_LAC_REPORT~INITIALIZE
    redefinition .
protected section.
private section.

  data MO_SALV_WRAP type ref to ZCA_LAC_SALV_WRAP .
  data MO_SCREEN_HELPER type ref to ZCL_LAC_SHOP_IB_MONI_HELPER .
  data MS_SELECTION_FIELDS type ZLAC_SHOP_IB_MONI_SELECTION  ##NEEDED.

  methods EXECUTE
    raising
      ZCX_LAC
      CX_SALV_ERROR .
ENDCLASS.



CLASS ZCL_LAC_SHOP_IB_MONI IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    IF io_screen_helper IS BOUND.
      mo_screen_helper = io_screen_helper.
    ELSE.
      CREATE OBJECT mo_screen_helper.
    ENDIF.

    IF io_salv_wrap IS BOUND.
      mo_salv_wrap = io_salv_wrap.
    ELSE.
      CREATE OBJECT mo_salv_wrap TYPE zcl_lac_salv_wrap.
    ENDIF.

  ENDMETHOD.


   METHOD EXECUTE.

    DATA: lo_splitter    TYPE REF TO cl_gui_splitter_container,
          lo_header_salv TYPE REF TO cl_salv_table,
          lo_items_salv  TYPE REF TO cl_salv_table,
          lv_download    TYPE string.

    lv_download = text-s00.

    lo_splitter = mo_screen_helper->create_splitter_container( ).

    lo_header_salv = mo_screen_helper->create_salv(
      io_splitter = lo_splitter
      iv_row      = 1
      iv_height   = 80 ##NUMBER_OK
    ).

    lo_items_salv = mo_screen_helper->create_salv(
      io_splitter = lo_splitter
      iv_row      = 2
      iv_height   = 20 ##NUMBER_OK
    ).

    mo_salv_wrap->set_default_functions( lo_header_salv ).

    mo_salv_wrap->add_function(
      io_salv     = lo_header_salv
      iv_name     = 'BUTTON'
      iv_icon     = '@FT@'
      iv_text     = lv_download
      iv_tooltip  = lv_download
      iv_position = if_salv_c_function_position=>right_of_salv_functions
    ).

    mo_salv_wrap->set_optimize_columns( lo_header_salv ).
    mo_salv_wrap->set_optimize_columns( lo_items_salv ).

    mo_salv_wrap->display( lo_header_salv ).
    mo_salv_wrap->display( lo_items_salv ).

  ENDMETHOD.


  METHOD ZIF_LAC_REPORT~FINALIZE.
    FREE mo_screen_helper.
  ENDMETHOD.


  METHOD ZIF_LAC_REPORT~INITIALIZE.

    DATA lx_static_check TYPE REF TO cx_static_check.

    TRY .
        execute( ).

      CATCH cx_salv_error INTO lx_static_check.
        RAISE EXCEPTION TYPE zcx_lac
          EXPORTING
            previous = lx_static_check.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
