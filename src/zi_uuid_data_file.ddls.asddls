@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'UUID data file'

define view entity ZI_UUID_DATA_FILE
  as select from zuuid_data_file
  association to parent ZR_USER_UPLOAD as _File on  $projection.UploadUuid = _File.Uuid
                                                and $projection.EndUser    = _File.EndUser
                                                and $projection.ZCount     = _File.ZCount
{
  key uuid                  as Uuid,
      upload_uuid           as UploadUuid,
      end_user              as EndUser,
      cnt                   as ZCount,
      ebeln                 as Ebeln,
      ebelp                 as Ebelp,
      entrysheet            as Entrysheet,
      ext_number            as ExtNumber,
      begdate               as Begdate,
      enddate               as Enddate,
      @Semantics.quantity.unitOfMeasure: 'BaseUom'
      quantity              as Quantity,
      base_uom              as BaseUom,
      fin_entry             as FinEntry,
      error                 as Error,
      error_message         as ErrorMessage,
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
      _File
}
