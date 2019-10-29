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
  methods CREATE_SALV_OK
  for testing .
  methods CREATE_SPLITTER_CONTAINER_OK
  for testing .
  methods RAISE_OBJECT_CREATION_ERROR
  for testing .
protected section.
private section.

  data MO_SCREEN_HELPER type ref to ZCL_LAC_SHOP_IB_MONI_HELPER .
  data MO_GUI_WRAP_DOUBLE type ref to ZTD_LAC_GUI_WRAP .
  data MO_SALV_WRAP_DOUBLE type ref to ZTD_LAC_SALV_WRAP .

  methods SETUP .
ENDCLASS.



CLASS ZTC_LAC_SHOP_IB_MONI_HELPER IMPLEMENTATION.


  METHOD CONSTRUCTOR_OK.

    CLEAR mo_screen_helper.

    CREATE OBJECT mo_screen_helper.

    cl_aunit_assert=>assert_bound( mo_screen_helper ).

  ENDMETHOD.


  METHOD CREATE_SALV_OK.

    DATA lo_splitter TYPE REF TO cl_gui_splitter_container.

    TRY .
        mo_screen_helper->create_salv(
          io_splitter = lo_splitter
          iv_row      = 1
          iv_height   = 100
        ).
      CATCH cx_salv_msg zcx_lac_obj_modify_attribute.
        cl_aunit_assert=>fail( ).
    ENDTRY.

    cl_aunit_assert=>assert_equals(
      act = mo_gui_wrap_double->mv_get_container_spy
      exp = abap_true
    ).

  ENDMETHOD.


  METHOD CREATE_SPLITTER_CONTAINER_OK.

    DATA lo_splitter TYPE REF TO cl_gui_splitter_container.

    TRY .
        lo_splitter = mo_screen_helper->create_splitter_container( ).

      CATCH cx_static_check.
        cl_aunit_assert=>fail( ).

    ENDTRY.

    cl_aunit_assert=>assert_bound( lo_splitter ).

  ENDMETHOD.


  METHOD RAISE_OBJECT_CREATION_ERROR.

    DATA lo_container TYPE REF TO cl_gui_splitter_container.

    mo_gui_wrap_double->mv_object_creation_error = abap_true.

    TRY .
        lo_container = mo_screen_helper->create_splitter_container( ).

      CATCH cx_static_check ##NO_HANDLER.
    ENDTRY.

    cl_aunit_assert=>assert_not_bound( lo_container ).

  ENDMETHOD.


  METHOD SETUP.

    CREATE OBJECT mo_gui_wrap_double TYPE ztd_lac_gui_wrap.
    CREATE OBJECT mo_salv_wrap_double TYPE ztd_lac_salv_wrap.

    CREATE OBJECT mo_screen_helper
      EXPORTING
        io_gui_wrap  = mo_gui_wrap_double
        io_salv_wrap = mo_salv_wrap_double.

  ENDMETHOD.
ENDCLASS.
