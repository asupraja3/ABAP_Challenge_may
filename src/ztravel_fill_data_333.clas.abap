CLASS ztravel_fill_data_333 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztravel_fill_data_333 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA lt_travel TYPE STANDARD TABLE OF ztravel_333.
    DELETE FROM ztravel_333.
    SELECT travel_id, total_price, currency_code, description
      FROM /dmo/travel
      INTO TABLE @DATA(lt_dmo_travel).

    LOOP AT lt_dmo_travel ASSIGNING FIELD-SYMBOL(<ls_dmo>).

      DATA(ls_travel) = VALUE ztravel_333(
        travel_id     = <ls_dmo>-travel_id
        total_price   = <ls_dmo>-total_price
        currency_code = <ls_dmo>-currency_code
        description   = <ls_dmo>-description
        travel_type   = COND #( WHEN <ls_dmo>-total_price > 4500 THEN 'Business'
                            WHEN <ls_dmo>-total_price > 3000 THEN 'Premium Economy'
                            ELSE 'Economy' )
      ).

      APPEND ls_travel TO lt_travel.

    ENDLOOP.

    INSERT ztravel_333 FROM TABLE @lt_travel.
  ENDMETHOD.
ENDCLASS.
