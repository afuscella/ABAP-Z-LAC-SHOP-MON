class ZCL_LAC_SHOP_IB_MONI_HNDL_FCTY definition
  public
  create public .

public section.

  constants:
    BEGIN OF sc_event_type ,
      button TYPE string VALUE 'BUTTON',
    END OF sc_event_type .

  methods BUILD
    importing
      !IV_EVENT_TYPE type STRING
      !IV_EVENT_ID type STRING
    returning
      value(RO_HANDLER) type ref to ZIF_LAC_SHOP_IB_MONI_HNDL
    raising
      ZCX_LAC_MISSING_HNDL .
protected section.
private section.

  methods BUILD_BUTTON_EVENT_HANDLER
    importing
      !IV_EVENT_ID type STRING
    returning
      value(RO_HANDLER) type ref to ZIF_LAC_SHOP_IB_MONI_HNDL .
ENDCLASS.



CLASS ZCL_LAC_SHOP_IB_MONI_HNDL_FCTY IMPLEMENTATION.


  METHOD build.

    build_button_event_handler( iv_event_id ).

    IF ro_handler IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_lac_missing_hndl
        EXPORTING
          mv_event_type = iv_event_type
          mv_event_id   = iv_event_id.
    ENDIF.

  ENDMETHOD.


  METHOD build_button_event_handler.

    CREATE OBJECT ro_handler TYPE zcl_lac_shop_ib_moni_hndl_save.

  ENDMETHOD.
ENDCLASS.
