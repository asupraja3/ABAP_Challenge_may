extend view entity ZITRAVEL_333 with

association [0..1] to /DMO/I_Booking_U as ZZ_Booking on $projection.TravelId = ZZ_Booking.TravelID
{

  ZZ_Booking.FlightDate as ZZFlightDate,

  // cast( $session.system_date as /dmo/flight_date ) - _Booking.FlightDate  as DaysToFlight
  cast( cast( ZZ_Booking.FlightDate        as abap.int8 ) -
      cast( $session.system_date       as abap.int8 )
      as abap.int4 )    as ZZDaysToFlight
}
