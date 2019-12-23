class ZCL_LAC_SHOP_OB_MONI_HELPER definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_GUI_WRAP type ref to ZCA_LAC_GUI_WRAP optional
      !IO_SALV_WRAP type ref to ZCA_LAC_SALV_WRAP optional .
  methods CREATE_SCREEN_SPLITTER
    returning
      value(RO_CONTAINER) type ref to CL_GUI_SPLITTER_CONTAINER
    raising
      ZCX_LAC_OBJ_CREATION .
  methods CREATE_SCREEN_CONTAINER
    importing
      !IO_SPLITTER type ref to CL_GUI_SPLITTER_CONTAINER
      !IV_ROW type I
      !IV_HEIGHT type I
    returning
      value(RO_CONTAINER) type ref to CL_GUI_CONTAINER .
  methods CREATE_SALV_CONTAINER
    importing
      !IO_CONTAINER type ref to CL_GUI_CONTAINER
      !IT_DATA type STANDARD TABLE
    returning
      value(RO_SALV_TABLE) type ref to CL_SALV_TABLE
    raising
      CX_SALV_ERROR .
  PROTECTED SECTION.
private section.

  data MO_GUI_WRAP type ref to ZCA_LAC_GUI_WRAP .
  data MO_SALV_WRAP type ref to ZCA_LAC_SALV_WRAP .
ENDCLASS.



CLASS ZCL_LAC_SHOP_OB_MONI_HELPER IMPLEMENTATION.


  METHOD CONSTRUCTOR.

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


  METHOD CREATE_SALV_CONTAINER.

    DATA lv_download TYPE string.

    lv_download = TEXT-s00.

    ro_salv_table = mo_salv_wrap->create_salv_table(
      io_container = io_container
      it_data      = it_data ).

    mo_salv_wrap->set_default_functions( ro_salv_table ).

    mo_salv_wrap->add_function(
      io_salv     = ro_salv_table
      iv_name     = 'BUTTON'
      iv_icon     = '@FT@'
      iv_text     = lv_download
      iv_tooltip  = lv_download
      iv_position = if_salv_c_function_position=>right_of_salv_functions
    ).

    mo_salv_wrap->set_optimize_columns( ro_salv_table ).

    mo_salv_wrap->display( ro_salv_table ).

  ENDMETHOD.


  METHOD CREATE_SCREEN_CONTAINER.

    ro_container = mo_gui_wrap->get_splitter_container(
      io_splitter = io_splitter
      iv_row      = iv_row
    ).

    TRY .
        mo_gui_wrap->set_splitter_row_height(
          io_splitter = io_splitter
          iv_id       = iv_row
          iv_height   = iv_height
        ).

      CATCH zcx_lac_obj_modify_attribute ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD CREATE_SCREEN_SPLITTER.

    DATA lo_container TYPE REF TO cl_gui_container.

    lo_container = mo_gui_wrap->create_container( ).

    ro_container = mo_gui_wrap->create_splitter(
      io_parent  = lo_container
      iv_rows    = 2
      iv_columns = 1
    ).

  ENDMETHOD.
ENDCLASS.
