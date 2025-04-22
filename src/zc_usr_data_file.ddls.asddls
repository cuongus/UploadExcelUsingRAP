@EndUserText.label: 'Manage data file'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
define view entity ZC_USR_DATA_FILE as projection on ZI_USR_DATA_FILE
{
    @Search.defaultSearchElement: true
    key Ebeln,
    @Search.defaultSearchElement: true
    key Ebelp,
    Entrysheet,
    ExtNumber,
    Begdate,
    Enddate,
    Quantity,
    @Consumption.valueHelpDefinition: [{entity: {name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' }, useForValidation: true}]
    BaseUom,
    FinEntry,
    Error,
    ErrorMessage,
    Uuid,
    EndUser,
    FileName,
    ZCount,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _File : redirected to parent ZC_USER_UPLOAD
}
