﻿<#
Applies finding V-26006 from the IIS 7 Server STIG
Title: A global authorization rule to restrict access must exist on the web server.
Reference: http://www.stigviewer.com/stig/iis_7.0_web_server/2013-04-11/finding/V-26006
#>

function Set-GlobalAuthorizationRule {

    $serverConfiguration = "/system.webServer/security/authorization/add"
    $siteConfiguration = "/system.webServer/security/authorization/*"

    Write-Output "Restricting server level access to Administrators only"

    $authorizationRule = Get-WebConfiguration -Filter $serverConfiguration
    $authorizationRule.Users = "Administrators"
    $authorizationRule | Set-WebConfiguration -Filter $serverConfiguration -PSPath IIS:\

    $websites = Get-Website

    foreach ($website in $websites) {

        $siteName = $website.Name

        Write-Output "$siteName authorization reset to All Users"

        Set-WebConfiguration -Filter $siteConfiguration -Value (@{AccessType="Allow"; Users="*"}) -PSPath IIS: -Location $siteName

    }

}