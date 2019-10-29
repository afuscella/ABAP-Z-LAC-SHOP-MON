class ZTD_LAC_SHOP_IB_MONI_HELPER definition
  public
  inheriting from ZCL_LAC_SHOP_IB_MONI_HELPER
  final
  create public .

public section.

  data MV_RAISE_OBJECT_CREATION type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.
  data MV_RAISE_SALV_MSG type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.
  data MV_RAISE_MODIFY_OBJECT_ATTR type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.

  methods CREATE_SALV
    redefinition .
  methods CREATE_SPLITTER_CONTAINER
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZTD_LAC_SHOP_IB_MONI_HELPER IMPLEMENTATION.


  METHOD create_salv.

    IF mv_raise_salv_msg = abap_true.
      RAISE EXCEPTION TYPE cx_salv_msg.
    ELSEIF mv_raise_modify_object_attr = abap_true.
      RAISE EXCEPTION TYPE zcx_lac_obj_modify_attribute.
    ENDIF.

  ENDMETHOD.


  METHOD create_splitter_container.

    IF mv_raise_object_creation = abap_true.
      RAISE EXCEPTION TYPE zcx_lac_obj_creation
        EXPORTING
          textid    = zcx_lac_obj_creation=>create_object_error
          mv_object = 'CONTAINER'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
