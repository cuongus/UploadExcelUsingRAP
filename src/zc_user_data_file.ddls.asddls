@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_USER_DATA_FILE'
@ObjectModel.semanticKey: [ 'Ebeln', 'Ebelp' ]
define root view entity ZC_USER_DATA_FILE
  provider contract transactional_query
  as projection on ZR_USER_DATA_FILE
{
  key Ebeln,
  key Ebelp,
  Entrysheet,
  ExtNumber,
  Begdate,
  Enddate,
  Quantity,
  BaseUom,
  FinEntry,
  Error,
  ErrorMessage,
  UUID,
  EndUser,
  FileName,
  ZCount,
  LocalLastChangedAt,
  _File
  
}
