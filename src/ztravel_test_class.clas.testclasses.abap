"!@testing ZITRAVEL_333
CLASS ltc_zitravel_333 DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    DATA td_ztravel_333 TYPE STANDARD TABLE OF ztravel_333 WITH EMPTY KEY.
    DATA td_/dmo/i_booking_u TYPE STANDARD TABLE OF /dmo/i_booking_u WITH EMPTY KEY.
    DATA act_results TYPE STANDARD TABLE OF zitravel_333 WITH EMPTY KEY.

    "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
    CLASS-METHODS class_setup RAISING cx_static_check.
    "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
    CLASS-METHODS class_teardown.

    "! SETUP method creates a common start state for each test method,
    "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
    METHODS setup RAISING cx_static_check.
    METHODS prepare_testdata.
    "! In this method test data is inserted into the generated double(s) and the test is executed and
    "! the results should be asserted with the actuals.
    METHODS:
      test_total_price_gt_1000    FOR TESTING,
      test_total_price_lt_1000    FOR TESTING,
      test_total_price_eq_1000    FOR TESTING,
      test_total_price_is_initial FOR TESTING.
ENDCLASS.


CLASS ltc_zitravel_333 IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'ZITRAVEL_333' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.


  METHOD prepare_testdata.
    " Prepare test data for 'ztravel_333'
    td_ztravel_333 = VALUE #(
      (
        client = '100'
      ) ).
    environment->insert_test_data( i_data = td_ztravel_333 ).

    " Prepare test data for '/dmo/i_booking_u'
    " TODO: Provide the test data here
    td_/dmo/i_booking_u = VALUE #(
      (
      ) ).
    environment->insert_test_data( i_data = td_/dmo/i_booking_u ).
  ENDMETHOD.

  METHOD test_total_price_gt_1000.
    SELECT SINGLE totalprice, DiscPrice
     FROM zitravel_333
     WHERE totalprice > 1000
     AND DiscPrice is NOT initial
     INTO (@DATA(lv_total_price), @DATA(lv_disc_price)).

    "WRITE: / 'Total:', lv_total_price, ' Discounted:', lv_disc_price.

    DATA(lv_expected) = lv_total_price * '0.9'.
    cl_abap_unit_assert=>assert_equals(
      act = lv_disc_price
      exp = lv_expected
      msg = 'Discounted price should be 90% of total_price'
    ).

  ENDMETHOD.

  METHOD test_total_price_lt_1000.
    SELECT SINGLE totalprice, DiscPrice FROM zitravel_333
      WHERE totalprice < 1000
      INTO (@DATA(lv_total_price), @DATA(lv_disc_price)).
*    DATA(lv_is_discounted) = xsdbool( lv_disc_price < lv_total_price ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_disc_price
      exp = lv_total_price
      msg = 'No discount expected when total_price < 1000'
    ).
  ENDMETHOD.

  METHOD test_total_price_eq_1000.
    SELECT SINGLE DiscPrice FROM zitravel_333
      WHERE totalprice = 1000
      INTO @DATA(lv_disc_price).

    cl_abap_unit_assert=>assert_equals(
      act = lv_disc_price
      exp = 1000
      msg = 'No discount expected when total_price = 1000'
    ).
  ENDMETHOD.

  METHOD test_total_price_is_initial.
    SELECT SINGLE DiscPrice FROM zitravel_333
      WHERE totalprice IS INITIAL
      INTO @DATA(lv_disc_price).

    cl_abap_unit_assert=>assert_initial(
      act = lv_disc_price
      msg = 'Discount should be initial if total_price is initial'
    ).
  ENDMETHOD.

ENDCLASS.
