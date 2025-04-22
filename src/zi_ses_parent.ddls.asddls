@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Excel File Table'
define root view entity ZI_SES_PARENT
  as select from    I_SystemUser    as _user
    left outer join zses_file_table as _ses_file on _user.UserID = _ses_file.end_user
  composition [0..*] of zi_ses_excel_data as _ses_excel
{

  key _user.UserID                                                                                             as end_user,
      _ses_file.status                                                                                         as status,
      cast( case when _ses_file.filename is initial and _ses_file.status is      initial then 'File Not Uploaded'
                 when _ses_file.filename is not initial and  _ses_file.status is initial  then 'File Uploaded'
                 when _ses_file.filename is initial then 'File Not Uploaded'
                 when  _ses_file.status is not initial then 'File Processed' else ' ' end as abap.char( 20 ) ) as FileStatus,
      cast( case when _ses_file.filename is initial and _ses_file.status is initial then '1'
                 when _ses_file.filename is not initial and  _ses_file.status is initial  then '2'
                 when _ses_file.filename is initial then '1'
                 when  _ses_file.status is not initial then '3' else ' ' end as abap.char( 1 ) )               as CriticalityStatus,
      cast( case when _ses_file.filename is not initial then ' ' else 'X' end as boolean preserving type  )    as HideExcel,
      @Semantics.largeObject: { mimeType: 'MimeType',
                                fileName: 'Filename',
                                contentDispositionPreference: #INLINE }
      _ses_file.attachment                                                                                     as Attachment,
      @Semantics.mimeType: true
      _ses_file.mimetype                                                                                       as MimeType,
      _ses_file.filename                                                                                       as Filename,
      @Semantics.user.createdBy: true
      _ses_file.local_created_by                                                                               as Local_Created_By,
      @Semantics.systemDateTime.createdAt: true
      _ses_file.local_created_at                                                                               as Local_Created_At,
      @Semantics.user.lastChangedBy: true
      _ses_file.local_last_changed_by                                                                          as Local_Last_Changed_By,
      //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _ses_file.local_last_changed_at                                                                          as Local_Last_Changed_At,
      //total ETag field
      @Semantics.systemDateTime.lastChangedAt: true
      _ses_file.last_changed_at                                                                                as Last_Changed_At,

      _ses_excel
}
where
  _user.UserID = $session.user
