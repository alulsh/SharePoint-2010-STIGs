<#
Applies finding V-13688 from the IIS 7 Site STIG
Title: Log files must consist of the required data fields.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_site/2014-03-25/finding/V-13688
#>

function Set-LogDataFields {

    Set-WebConfigurationProperty -Filter "/system.applicationHost/sites/siteDefaults" -Name logfile.logExtFileFlags -Value "Date,Time,ClientIP,UserName,ServerIP,Method,UriStem,UriQuery,HttpStatus,Win32Status,TimeTaken,ServerPort,UserAgent,Referer,HttpSubStatus"

}