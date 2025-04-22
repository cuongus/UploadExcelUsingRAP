@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manage data file'
define view entity ZI_DATA_FILE
  as select from zuser_data_file as dataFile
  association [0..1] to ZR_USER_UPLOAD  as _File on  $projection.Uuid    = _File.Uuid
                                                 and $projection.EndUser = _File.EndUser
  association [0..1] to I_UnitOfMeasure as _UOM  on  $projection.BaseUom = _UOM.UnitOfMeasure

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
      uuid                  as Uuid,
      end_user              as EndUser,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt,
      _File,
      _UOM
}
