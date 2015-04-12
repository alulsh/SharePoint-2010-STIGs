/*
V-41411 - SQL Server must encrypt information stored in the database.
This script only reports, it does not make any configuration changes.
It proves that you are using TDE to encrypt the databases.
*/

/*
Gets symmetric keys in master database
Service Master Key encrypts the Database Master Key for the master database
Database master key is used to encrypt the certificates used to encrypt the database encryption keys
*/

USE Master
GO

SELECT name, key_length, algorithm_desc, key_guid FROM sys.symmetric_keys

/*
Gets database encryption keys for each database and joins with certificate information
Database Master Key encrypts the certificate and stores it in the master database
TDE database encryption keys are symmetric keys encrypted by a certificate
An encryption key of 3 means the database is encrypted
*/

SELECT (DB_NAME(database_id)) AS 'Database Name',
	dek.encryption_state, dek.key_algorithm, dek.key_length, dek.encryptor_type, dek.encryptor_thumbprint,
	certs.name AS 'Encryption Certificate', certs.pvt_key_encryption_type_desc, certs.issuer_name, certs.subject, certs.expiry_date
FROM sys.dm_database_encryption_keys AS dek
LEFT OUTER JOIN sys.certificates AS certs
	 on (dek.encryptor_thumbprint = certs.thumbprint)