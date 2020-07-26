interface ZIF_LAC_SHOP_MONI_HELPER
  public .


  methods CREATE_SCREEN_SPLITTER
    returning
      value(RO_CONTAINER) type ref to CL_GUI_SPLITTER_CONTAINER
    raising
      ZCX_LAC_OBJ_CREATION .
  methods CREATE_SCREEN_CONTAINER
    importing
      !IO_SPLITTER type ref to CL_GUI_SPLITTER_CONTAINER
      !IV_ROW type I
      !IV_HEIGHT type I
    returning
      value(RO_CONTAINER) type ref to CL_GUI_CONTAINER .
  methods CREATE_SALV_CONTAINER
    importing
      !IO_CONTAINER type ref to CL_GUI_CONTAINER
      !IT_DATA type STANDARD TABLE
    returning
      value(RS_SALV_RETURN) type ZLAC_SALV_RETURN
    raising
      CX_SALV_ERROR .
  methods DISPLAY_SCREEN
    importing
      !IO_GRID type ZLAC_SALV_RETURN .
endinterface.
