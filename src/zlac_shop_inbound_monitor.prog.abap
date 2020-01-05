*&---------------------------------------------------------------------*
*& Report ZLAC_SHOP_INBOUND_MONITOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlac_shop_inbound_monitor.

INCLUDE zlac_shop_ib_monitor_0100o01.
INCLUDE zlac_shop_ib_monitor_0100i01.

CLASS lcl_main DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS execute RAISING zcx_lac.

  PRIVATE SECTION.
    DATA lo_monitor TYPE REF TO zif_lac_report.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD execute.

    CREATE OBJECT lo_monitor TYPE zcl_lac_shop_ib_moni.
    lo_monitor->initialize( ).
    CALL SCREEN 0100.
    lo_monitor->finalize( ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  TRY .
      NEW lcl_main( )->execute( ).
    CATCH zcx_lac INTO DATA(lx_lac).
      lx_lac->raise_message( ).
  ENDTRY.
