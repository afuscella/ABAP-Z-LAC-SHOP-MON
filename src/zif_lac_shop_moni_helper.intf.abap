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
      value(RO_SALV_TABLE) type ref to CL_SALV_TABLE
    raising
      CX_SALV_ERROR .
endinterface.
