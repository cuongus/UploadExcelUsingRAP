@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manage Data File'
define root view entity ZR_USER_DATA_FILE
  as select from zuser_data_file as dataFile
  association [0..1] to ZR_USER_UPLOAD as _File on  $projection.UUID    = _File.Uuid
                                                and $projection.EndUser = _File.EndUser
{
  key ebeln                 as Ebeln,
  key ebelp                 as Ebelp,
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
      uuid                  as UUID,
      end_user              as EndUser,
      filename              as FileName,
      zcount                as ZCount,
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
