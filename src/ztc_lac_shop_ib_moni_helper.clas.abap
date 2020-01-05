class ZTC_LAC_SHOP_IB_MONI_HELPER definition
  public
  abstract
  create public
  for testing
  duration short
  risk level harmless .

public section.

  methods CONSTRUCTOR_OK
  for testing .
  methods CREATE_SALV_CONTAINER_OK
  for testing
    raising
      CX_SALV_ERROR .
  methods CREATE_SCREEN_CONTAINER_OK
  for testing .
  methods CREATE_SCREEN_SPLITTER_OK
  for testing
    raising
      ZCX_LAC_OBJ_CREATION .
  methods CREATE_SALV_CONTAINER_FAIL
  for testing
    raising
      CX_SALV_ERROR .
  PROTECTED SECTION.
private section.

  data MO_SCREEN_HELPER type ref to ZIF_LAC_SHOP_MONI_HELPER .
  data MO_GUI_WRAP_DOUBLE type ref to ZIF_LAC_GUI_WRAP .
  data MO_SALV_WRAP_DOUBLE type ref to ZIF_LAC_SALV_WRAP .

  methods SETUP .
ENDCLASS.



CLASS ZTC_LAC_SHOP_IB_MONI_HELPER IMPLEMENTATION.


  METHOD constructor_ok.

    CLEAR mo_screen_helper.

    CREATE OBJECT mo_screen_helper TYPE zcl_lac_shop_ib_moni_helper.

    cl_aunit_assert=>assert_bound( mo_screen_helper ).

  ENDMETHOD.


  METHOD create_salv_container_fail.

    DATA: lx_salv_error TYPE REF TO cx_salv_error,
          lo_container  TYPE REF TO cl_gui_container ##NEEDED,
          lt_data       TYPE TABLE OF c.

    CREATE OBJECT lx_salv_error.

*   configure CREATE_SALV_TABLE
    cl_abap_testdouble=>configure_call( mo_salv_wrap_double
      )->raise_exception( lx_salv_error ).

    mo_salv_wrap_double->create_salv_table(
      io_container = lo_container
      it_data      = lt_data ).

*   @Test
    TRY .
        CLEAR lx_salv_error.

        mo_screen_helper->create_salv_container(
          io_container = lo_container
          it_data      = lt_data
        ).
        cl_aunit_assert=>fail( ).

      CATCH cx_salv_error INTO lx_salv_error.
        cl_aunit_assert=>assert_bound( lx_salv_error ).

    ENDTRY.

  ENDMETHOD.


  METHOD create_salv_container_ok.

    DATA: lo_container  TYPE REF TO cl_gui_container ##NEEDED,
          lo_salv_table TYPE REF TO cl_salv_table ##NEEDED,
          lt_data       TYPE TABLE OF c.

*   configure CALLs
    cl_abap_testdouble=>configure_call( mo_salv_wrap_double
      )->times( 5 ).

    mo_salv_wrap_double->create_salv_table(
      io_container = lo_container
      it_data      = lt_data ).

    mo_salv_wrap_double->set_default_functions( lo_salv_table ).

    mo_salv_wrap_double->add_function(
      io_salv     = lo_salv_table
      iv_name     = space
      iv_icon     = space
      iv_text     = space
      iv_tooltip  = space
      iv_position = if_salv_c_function_position=>right_of_salv_functions
    ).

    mo_salv_wrap_double->set_optimize_columns( lo_salv_table ).

    mo_salv_wrap_double->display( lo_salv_table ).

*   @Test
    TRY .
        mo_screen_helper->create_salv_container(
          io_container = lo_container
          it_data      = lt_data
        ).

      CATCH cx_salv_error ##NO_HANDLER.
    ENDTRY.

    cl_abap_testdouble=>verify_expectations( mo_salv_wrap_double ).

  ENDMETHOD.


  METHOD create_screen_container_ok.

    DATA lo_splitter TYPE REF TO cl_gui_splitter_container ##NEEDED.

*   configure GET_SPLITTER_CONTAINER
    cl_abap_testdouble=>configure_call( mo_gui_wrap_double
      )->times( 1 ).

    mo_gui_wrap_double->get_splitter_container(
      io_splitter = lo_splitter
      iv_row      = 1
    ).

*   configure SET_SPLITTER_ROW_HEIGHT
    cl_abap_testdouble=>configure_call( mo_gui_wrap_double
      )->times( 1 ).

    mo_gui_wrap_double->set_splitter_row_height(
      io_splitter = lo_splitter
      iv_id       = 1
      iv_height   = 1
    ).

*   @Test
    mo_screen_helper->create_screen_container(
      io_splitter = lo_splitter
      iv_row      = 1
      iv_height   = 100
    ).

    cl_abap_testdouble=>verify_expectations( mo_gui_wrap_double ).

  ENDMETHOD.


  METHOD create_screen_splitter_ok.

    DATA lo_container TYPE REF TO cl_gui_container ##NEEDED.

*   configure CREATE_CONTAINER
    cl_abap_testdouble=>configure_call( mo_gui_wrap_double
      )->times( 1 ).

    mo_gui_wrap_double->create_container( ).

*   configure CREATE_SPLITTER
    cl_abap_testdouble=>configure_call( mo_gui_wrap_double
      )->times( 1 ).

    mo_gui_wrap_double->create_splitter(
      io_parent  = lo_container
      iv_rows    = 1
      iv_columns = 1
    ).

    TRY .
        mo_screen_helper->create_screen_splitter( ).
        cl_abap_testdouble=>verify_expectations( mo_gui_wrap_double ).

      CATCH zcx_lac_obj_creation.
        cl_aunit_assert=>fail( ).

    ENDTRY.

  ENDMETHOD.


  METHOD setup.

    CONSTANTS: lc_gui_wrap  TYPE seoclsname VALUE 'ZIF_LAC_GUI_WRAP',
               lc_salv_wrap TYPE seoclsname VALUE 'ZIF_LAC_SALV_WRAP'.

    mo_gui_wrap_double  ?= cl_abap_testdouble=>create( lc_gui_wrap ).
    mo_salv_wrap_double ?= cl_abap_testdouble=>create( lc_salv_wrap ).

    CREATE OBJECT mo_screen_helper TYPE zcl_lac_shop_ib_moni_helper
      EXPORTING
        io_gui_wrap  = mo_gui_wrap_double
        io_salv_wrap = mo_salv_wrap_double.

  ENDMETHOD.
ENDCLASS.
