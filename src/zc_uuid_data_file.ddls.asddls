@EndUserText.label: 'UUID data file projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_UUID_DATA_FILE
  as projection on ZI_UUID_DATA_FILE
{
  key Uuid,
      UploadUuid,
      @Search.defaultSearchElement: true
      EndUser,
      @Search.defaultSearchElement: true
      ZCount,
      @Search.defaultSearchElement: true
      Ebeln,
      Ebelp,
      Entrysheet,
      ExtNumber,
      Begdate,
      Enddate,
      Quantity,
      BaseUom,
      FinEntry,
      Error,
      ErrorMessage,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _File : redirected to parent ZC_USER_UPLOAD
}
