@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manage user upload file'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZR_USER_UPLOAD
  as select from zuser_upload as File
  composition [0..*] of ZI_USR_DATA_FILE as _dataFile
  composition [0..*] of ZI_UUID_DATA_FILE as _previewData
  association [0..1] to ZI_REQ_STA_VH         as _OverallStatus     on  $projection.Status      = _OverallStatus.Status
                                                                    and _OverallStatus.language = $session.system_language
{
  key uuid                  as Uuid,
  key end_user              as EndUser,
  key cnt                   as ZCount,
      status                as Status,
      @Semantics.largeObject: { mimeType: 'Mimetype',
                                fileName: 'Filename',
                                contentDispositionPreference: #INLINE }
      attachment            as Attachment,
      @Semantics.mimeType: true
      mimetype              as Mimetype,
      filename              as Filename,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _dataFile,
      _previewData,
      _OverallStatus
}
