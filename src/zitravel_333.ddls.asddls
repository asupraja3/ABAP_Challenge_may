@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel View Entity'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.extensibility: {
  extensible: true,
  elementSuffix: 'ZAC',
  quota: {
    maximumFields: 500,
    maximumBytes: 5000
  },
  dataSources: [ '_Travel' ]
}
define view entity ZITRAVEL_333
  as select from ztravel_333 as _Travel
{
  key travel_id           as TravelId,
      description         as Description,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price         as TotalPrice,
      currency_code       as CurrencyCode,
      _Travel.travel_type as TravelType,
      case
      when cast(_Travel.total_price as abap.dec(16,2)) > 1000
      then cast(
           cast(_Travel.total_price as abap.dec(16,2)) *
           cast(0.9 as abap.dec(4,2))
         as abap.dec(16,2))
      else cast(_Travel.total_price as abap.dec(16,2))
      end                 as DiscPrice
}
