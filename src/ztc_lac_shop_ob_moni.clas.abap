CLASS ztc_lac_shop_ob_moni DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PUBLIC SECTION.

    METHODS constructor_ok
        FOR TESTING .
    METHODS finalize_ok
        FOR TESTING .
    METHODS initialize_ok
          FOR TESTING
      RAISING
        cx_salv_error
        zcx_lac_obj_creation .
    METHODS create_screen_fail
          FOR TESTING
      RAISING
        zcx_lac_obj_creation .
    METHODS create_header_section_fail
          FOR TESTING
      RAISING
        zcx_lac_obj_creation
        cx_salv_error .
    METHODS create_item_section_fail
          FOR TESTING
      RAISING
        zcx_lac_obj_creation
        cx_salv_error .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_ib_monitor TYPE REF TO zcl_lac_shop_ob_moni .
    DATA mo_screen_helper_double TYPE REF TO zif_lac_shop_moni_helper .
    DATA mo_salv_wrap_double TYPE REF TO zif_lac_salv_wrap .

    METHODS setup .
ENDCLASS.



CLASS ZTC_LAC_SHOP_OB_MONI IMPLEMENTATION.


  METHOD constructor_ok.

    CLEAR mo_ib_monitor.

    CREATE OBJECT mo_ib_monitor.

    cl_aunit_assert=>assert_bound( mo_ib_monitor ).

  ENDMETHOD.


  METHOD create_header_section_fail.

    DATA: lx_salv_error TYPE REF TO cx_salv_error,
          lo_splitter   TYPE REF TO cl_gui_splitter_container ##NEEDED,
          lo_container  TYPE REF TO cl_gui_container ##NEEDED.

*   configure CREATE_SCREEN_SPLITTER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->returning( lo_splitter ).

    mo_screen_helper_double->create_screen_splitter( ).

*   configure CREATE_SCREEN_CONTAINER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->returning( lo_container ).

    mo_screen_helper_double->create_screen_container(
      io_splitter = lo_splitter
      iv_row      = 1
      iv_height   = 1 ).

*   configure CREATE_SALV_CONTAINER
    CREATE OBJECT lx_salv_error.
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->raise_exception( lx_salv_error ).

    mo_screen_helper_double->create_salv_container(
      io_container = lo_container
      it_data      = VALUE zlac_shop_ib_moni_hdr_disp_tab( )
    ).

    TRY .
        mo_ib_monitor->initialize( ).
        cl_aunit_assert=>fail( 'Test has ended unexpectedly' ).

      CATCH zcx_lac ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD create_item_section_fail.

    DATA: lx_salv_error TYPE REF TO cx_salv_error,
          lo_splitter   TYPE REF TO cl_gui_splitter_container ##NEEDED,
          lo_container  TYPE REF TO cl_gui_container ##NEEDED.

*   configure CREATE_SCREEN_SPLITTER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->returning( lo_splitter ).

    mo_screen_helper_double->create_screen_splitter( ).

*   configure CREATE_SCREEN_CONTAINER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->returning( lo_container ).

    mo_screen_helper_double->create_screen_container(
      io_splitter = lo_splitter
      iv_row      = 1
      iv_height   = 1 ).

*   configure CREATE_SALV_CONTAINER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double ).

    mo_screen_helper_double->create_salv_container(
      io_container = lo_container
      it_data      = VALUE zlac_shop_ib_moni_hdr_disp_tab( )
    ).

*   configure CREATE_SALV_CONTAINER
    CREATE OBJECT lx_salv_error.
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->raise_exception( lx_salv_error ).

    mo_screen_helper_double->create_salv_container(
      io_container = lo_container
      it_data      = VALUE zlac_shop_ib_moni_hdr_disp_tab( )
    ).

    TRY .
        mo_ib_monitor->initialize( ).
        cl_aunit_assert=>fail( 'Test has ended unexpectedly' ).

      CATCH zcx_lac ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD create_screen_fail.

    DATA lx_lac_obj_creation TYPE REF TO zcx_lac_obj_creation.

    CREATE OBJECT lx_lac_obj_creation.

*   configure CREATE_SCREEN_CONTAINER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->raise_exception( lx_lac_obj_creation ).

    mo_screen_helper_double->create_screen_splitter( ).

    TRY .
        mo_ib_monitor->initialize( ).
        cl_aunit_assert=>fail( 'Test has ended unexpectedly' ).

      CATCH zcx_lac ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD finalize_ok.

    mo_ib_monitor->finalize( ).

  ENDMETHOD.


  METHOD initialize_ok.

    DATA: lo_splitter  TYPE REF TO cl_gui_splitter_container ##NEEDED,
          lo_container TYPE REF TO cl_gui_container ##NEEDED.

*   configure CREATE_SCREEN_SPLITTER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->returning( lo_splitter ).

    mo_screen_helper_double->create_screen_splitter( ).

*   configure CREATE_SCREEN_CONTAINER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double
      )->returning( lo_container ).

    mo_screen_helper_double->create_screen_container(
      io_splitter = lo_splitter
      iv_row      = 1
      iv_height   = 1 ).

*   configure CREATE_SALV_CONTAINER
    cl_abap_testdouble=>configure_call( mo_screen_helper_double )->times( 2 ).

    mo_screen_helper_double->create_salv_container(
      io_container = lo_container
      it_data      = VALUE zlac_shop_ib_moni_hdr_disp_tab( )
    ).

    TRY .
        mo_ib_monitor->initialize( ).

        cl_abap_testdouble=>verify_expectations( mo_screen_helper_double ).

      CATCH zcx_lac.
        cl_aunit_assert=>fail( 'Test has ended unexpectedly' ).
    ENDTRY.

  ENDMETHOD.


  METHOD setup.

    CONSTANTS: lc_moni_helper TYPE seoclsname VALUE 'ZIF_LAC_SHOP_MONI_HELPER',
               lc_salv_wrap   TYPE seoclsname VALUE 'ZIF_LAC_SALV_WRAP'.

    mo_screen_helper_double ?= cl_abap_testdouble=>create( lc_moni_helper ).
    mo_salv_wrap_double     ?= cl_abap_testdouble=>create( lc_salv_wrap ).

    CREATE OBJECT mo_ib_monitor
      EXPORTING
        io_screen_helper = mo_screen_helper_double
        io_salv_wrap     = mo_salv_wrap_double.

  ENDMETHOD.
ENDCLASS.
