class ZCL_LAC_SHOP_OB_MONI definition
  public
  inheriting from ZCA_LAC_REPORT
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IS_SELECTION_FIELDS type ZLAC_SHOP_IB_MONI_SELECTION optional
      !IO_SCREEN_HELPER type ref to ZIF_LAC_SHOP_MONI_HELPER optional
      !IO_SALV_WRAP type ref to ZIF_LAC_SALV_WRAP optional
      !IO_SPLITTER type ref to CL_GUI_CONTAINER optional .

  methods ZIF_LAC_REPORT~FINALIZE
    redefinition .
  methods ZIF_LAC_REPORT~INITIALIZE
    redefinition .
  PROTECTED SECTION.
private section.

  data MO_SCREEN_HELPER type ref to ZIF_LAC_SHOP_MONI_HELPER .
  data MS_SELECTION_FIELDS type ZLAC_SHOP_IB_MONI_SELECTION  ##NEEDED.

  methods CREATE_HEADER_SECTION
    importing
      !IO_SPLITTER type ref to CL_GUI_SPLITTER_CONTAINER
    raising
      CX_SALV_ERROR .
  methods CREATE_ITEMS_SECTION
    importing
      !IO_SPLITTER type ref to CL_GUI_SPLITTER_CONTAINER
    raising
      CX_SALV_ERROR .
ENDCLASS.



CLASS ZCL_LAC_SHOP_OB_MONI IMPLEMENTATION.


  METHOD CONSTRUCTOR.

    super->constructor( ).

    IF io_screen_helper IS BOUND.
      mo_screen_helper = io_screen_helper.
    ELSE.
      CREATE OBJECT mo_screen_helper TYPE zcl_lac_shop_ob_moni_helper.
    ENDIF.

  ENDMETHOD.


  METHOD CREATE_HEADER_SECTION.

    DATA: lo_header_container TYPE REF TO cl_gui_container,
          lt_header_display   TYPE zlac_shop_ib_moni_hdr_disp_tab.

    lo_header_container = mo_screen_helper->create_screen_container(
      io_splitter = io_splitter
      iv_row      = 1
      iv_height   = 80 ##NUMBER_OK
    ).

    mo_screen_helper->create_salv_container(
      io_container = lo_header_container
      it_data      = lt_header_display
    ).

  ENDMETHOD.


  METHOD create_items_section.

    DATA: lo_items_container TYPE REF TO cl_gui_container,
          lo_items_salv      TYPE REF TO cl_salv_table,
          lt_items_display   TYPE zlac_shop_ib_moni_hdr_disp_tab.

    lo_items_container = mo_screen_helper->create_screen_container(
      io_splitter = io_splitter
      iv_row      = 2
      iv_height   = 20 ##NUMBER_OK
    ).

    lo_items_salv = mo_screen_helper->create_salv_container(
      io_container = lo_items_container
      it_data      = lt_items_display
    ).

  ENDMETHOD.


  METHOD ZIF_LAC_REPORT~FINALIZE.
    FREE mo_screen_helper.
  ENDMETHOD.


  METHOD ZIF_LAC_REPORT~INITIALIZE.

    DATA: lo_splitter     TYPE REF TO cl_gui_splitter_container,
          lx_static_check TYPE REF TO cx_static_check.

    lo_splitter = mo_screen_helper->create_screen_splitter( ).

    TRY .
        create_header_section( lo_splitter ).
      CATCH cx_salv_error INTO lx_static_check.
        RAISE EXCEPTION TYPE zcx_lac
          EXPORTING
            previous = lx_static_check.
    ENDTRY.

    TRY .
        create_items_section( lo_splitter ).
      CATCH cx_salv_error INTO lx_static_check.
        RAISE EXCEPTION TYPE zcx_lac
          EXPORTING
            previous = lx_static_check.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
