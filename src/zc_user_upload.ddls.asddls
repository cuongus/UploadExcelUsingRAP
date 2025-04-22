@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_USER_UPLOAD'
@ObjectModel.semanticKey: [ 'EndUser' ]
@Search.searchable: true
define root view entity ZC_USER_UPLOAD
  provider contract transactional_query
  as projection on ZR_USER_UPLOAD
{
      @Search.defaultSearchElement: true
  key Uuid,
      @Search.defaultSearchElement: true
  key EndUser,
  key ZCount,
      @ObjectModel.text.element: ['OverallStatusText']
      Status,
      @EndUserText.label: 'Status'
      _OverallStatus.description as OverallStatusText,
      Attachment,
      Mimetype,
      @Semantics.text: true
      Filename,
      LocalLastChangedAt,
      /* Associations */
      _dataFile    : redirected to composition child ZC_USR_DATA_FILE,
      _previewData : redirected to composition child ZC_UUID_DATA_FILE,
      _OverallStatus

}
