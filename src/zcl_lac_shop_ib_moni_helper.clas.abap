class ZCL_LAC_SHOP_IB_MONI_HELPER definition
  public
  create public .

public section.

  interfaces ZIF_LAC_SHOP_MONI_HELPER .

  methods CONSTRUCTOR
    importing
      !IO_GUI_WRAP type ref to ZIF_LAC_GUI_WRAP optional
      !IO_SALV_WRAP type ref to ZIF_LAC_SALV_WRAP optional .
  PROTECTED SECTION.
private section.

  data MO_GUI_WRAP type ref to ZIF_LAC_GUI_WRAP .
  data MO_SALV_WRAP type ref to ZIF_LAC_SALV_WRAP .
ENDCLASS.



CLASS ZCL_LAC_SHOP_IB_MONI_HELPER IMPLEMENTATION.


  METHOD constructor.

    IF io_gui_wrap IS BOUND.
      mo_gui_wrap = io_gui_wrap.
    ELSE.
      CREATE OBJECT mo_gui_wrap TYPE zcl_lac_gui_wrap.
    ENDIF.

    IF io_salv_wrap IS BOUND.
      mo_salv_wrap = io_salv_wrap.
    ELSE.
      CREATE OBJECT mo_salv_wrap TYPE zcl_lac_salv_wrap.
    ENDIF.

  ENDMETHOD.


  METHOD zif_lac_shop_moni_helper~create_salv_container.

    DATA: lo_salv_table TYPE zlac_salv_return,
          lv_download   TYPE string.

    lv_download = TEXT-s00.

    lo_salv_table = mo_salv_wrap->create_salv_table(
      io_container = io_container
      it_data      = it_data ).

    mo_salv_wrap->set_default_functions( lo_salv_table-salv ).

    mo_salv_wrap->add_function(
      io_salv     = lo_salv_table-salv
      iv_name     = 'BUTTON'
      iv_icon     = '@FT@'
      iv_text     = lv_download
      iv_tooltip  = lv_download
      iv_position = if_salv_c_function_position=>right_of_salv_functions
    ).

    mo_salv_wrap->set_optimize_columns( lo_salv_table-salv ).

    rs_salv_return = VALUE #(
      salv = lo_salv_table-salv
      data = lo_salv_table-data
    ).

  ENDMETHOD.


  METHOD zif_lac_shop_moni_helper~create_screen_container.

    ro_container = mo_gui_wrap->get_splitter_container(
      io_splitter = io_splitter
      iv_row      = iv_row
    ).

    mo_gui_wrap->set_splitter_row_height(
      io_splitter = io_splitter
      iv_id       = iv_row
      iv_height   = iv_height
    ).

  ENDMETHOD.


  METHOD zif_lac_shop_moni_helper~create_screen_splitter.

    DATA lo_container TYPE REF TO cl_gui_container.

    lo_container = mo_gui_wrap->create_container( ).

    ro_container = mo_gui_wrap->create_splitter(
      io_parent  = lo_container
      iv_rows    = 2
      iv_columns = 1
    ).

  ENDMETHOD.


  METHOD zif_lac_shop_moni_helper~display_screen.

    io_grid-salv->display( ).

  ENDMETHOD.
ENDCLASS.
