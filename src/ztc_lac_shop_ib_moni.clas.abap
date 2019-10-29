class ZTC_LAC_SHOP_IB_MONI definition
  public
  abstract
  create public
  for testing
  duration short
  risk level harmless .

public section.

  methods CONSTRUCTOR_OK
  for testing .
  methods FINALIZE_OK
  for testing .
  methods INITIALIZE_OK
  for testing .
  methods RAISE_MODIFY_OBJECT_ATTR_FAIL
  for testing .
  methods RAISE_SALV_MSG_FAIL
  for testing .
  methods RAISE_SCREEN_CREATION_FAIL
  for testing .
protected section.
private section.

  data MO_IB_MONITOR type ref to ZCL_LAC_SHOP_IB_MONI .
  data MO_SCREEN_HELPER_DOUBLE type ref to ZTD_LAC_SHOP_IB_MONI_HELPER .
  data MO_SALV_WRAP_DOUBLE type ref to ZTD_LAC_SALV_WRAP .

  methods SETUP .
ENDCLASS.



CLASS ZTC_LAC_SHOP_IB_MONI IMPLEMENTATION.


  METHOD CONSTRUCTOR_OK.

    CLEAR mo_ib_monitor.

    CREATE OBJECT mo_ib_monitor.

    cl_aunit_assert=>assert_bound( mo_ib_monitor ).

  ENDMETHOD.


  METHOD FINALIZE_OK.

    mo_ib_monitor->finalize( ).

  ENDMETHOD.


  METHOD INITIALIZE_OK.

    TRY .
        mo_ib_monitor->initialize( ).

      CATCH cx_static_check.
        cl_aunit_assert=>fail( 'An exception was thrown during runtime' ).
    ENDTRY.

    cl_aunit_assert=>assert_equals(
      act = mo_salv_wrap_double->mv_display_spy
      exp = abap_true
    ).

  ENDMETHOD.


  METHOD raise_modify_object_attr_fail.

    mo_screen_helper_double->mv_raise_modify_object_attr = abap_true.

    TRY .
        mo_ib_monitor->initialize( ).
        cl_aunit_assert=>fail( 'Test has ended unexpectedly' ).
      CATCH cx_static_check ##NO_HANDLER.
    ENDTRY.

    cl_aunit_assert=>assert_initial( mo_salv_wrap_double->mv_display_spy ).

  ENDMETHOD.


  METHOD raise_salv_msg_fail.

    mo_screen_helper_double->mv_raise_salv_msg = abap_true.

    TRY .
        mo_ib_monitor->initialize( ).
        cl_aunit_assert=>fail( 'Test has ended unexpectedly' ).
      CATCH cx_static_check ##NO_HANDLER.
    ENDTRY.

    cl_aunit_assert=>assert_initial( mo_salv_wrap_double->mv_display_spy ).

  ENDMETHOD.


  METHOD raise_screen_creation_fail.

    mo_screen_helper_double->mv_raise_object_creation = abap_true.

    TRY .
        mo_ib_monitor->initialize( ).
        cl_aunit_assert=>fail( 'Test has ended unexpectedly' ).
      CATCH cx_static_check ##NO_HANDLER.
    ENDTRY.

    cl_aunit_assert=>assert_initial( mo_salv_wrap_double->mv_display_spy ).

  ENDMETHOD.


  METHOD setup.

    CREATE OBJECT mo_screen_helper_double.
    CREATE OBJECT mo_salv_wrap_double TYPE ztd_lac_salv_wrap.

    CREATE OBJECT mo_ib_monitor
      EXPORTING
        io_screen_helper = mo_screen_helper_double
        io_salv_wrap     = mo_salv_wrap_double.

  ENDMETHOD.
ENDCLASS.
