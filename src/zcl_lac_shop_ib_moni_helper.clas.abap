class ZCL_LAC_SHOP_IB_MONI_HELPER definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_GUI_WRAP type ref to ZCA_LAC_GUI_WRAP optional
      !IO_SALV_WRAP type ref to ZCA_LAC_SALV_WRAP optional .
  methods CREATE_SALV
    importing
      !IO_SPLITTER type ref to CL_GUI_SPLITTER_CONTAINER
      !IV_ROW type I
      !IV_HEIGHT type I
    returning
      value(RO_SALV) type ref to CL_SALV_TABLE
    raising
      CX_SALV_MSG
      ZCX_LAC_OBJ_MODIFY_ATTRIBUTE .
  methods CREATE_SPLITTER_CONTAINER
    returning
      value(RO_CONTAINER) type ref to CL_GUI_SPLITTER_CONTAINER
    raising
      ZCX_LAC_OBJ_CREATION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_gui_wrap TYPE REF TO zca_lac_gui_wrap .
    DATA mo_salv_wrap TYPE REF TO zca_lac_salv_wrap .
ENDCLASS.



CLASS ZCL_LAC_SHOP_IB_MONI_HELPER IMPLEMENTATION.


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


  METHOD CREATE_SALV.

    DATA: lo_container TYPE REF TO cl_gui_container,
          lt_data      TYPE zlac_shop_ib_moni_display_tab.

    lo_container = mo_gui_wrap->get_splitter_container(
      io_splitter = io_splitter
      iv_row      = iv_row
    ).

    mo_gui_wrap->set_splitter_row_height(
      io_splitter = io_splitter
      iv_id       = iv_row
      iv_height   = iv_height
    ).

    ro_salv = mo_salv_wrap->create_salv_table(
      io_container = lo_container
      it_data      = lt_data
    ).

  ENDMETHOD.


  METHOD CREATE_SPLITTER_CONTAINER.

    DATA lo_container TYPE REF TO cl_gui_container.

    lo_container = mo_gui_wrap->create_container( ).

    ro_container = mo_gui_wrap->create_splitter(
      io_parent  = lo_container
      iv_rows    = 2
      iv_columns = 1
    ).

  ENDMETHOD.
ENDCLASS.
