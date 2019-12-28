*&---------------------------------------------------------------------*
*& Report ZLAC_SHOP_INBOUND_MONITOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlac_shop_outbound_monitor.

DATA lo_monitor TYPE REF TO zif_lac_report.

CREATE OBJECT lo_monitor TYPE zcl_lac_shop_ob_moni.

TRY .
    lo_monitor->initialize( ).
  CATCH zcx_lac INTO DATA(lx_lac).
    lx_lac->raise_message( ).
ENDTRY.

CALL SCREEN 0100.

lo_monitor->finalize( ).

INCLUDE zlac_shop_ob_monitor_0100o01.
INCLUDE zlac_shop_ob_monitor_0100i01.
