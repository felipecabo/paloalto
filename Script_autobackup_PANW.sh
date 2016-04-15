#!/bin/bash

	################  ###############  ####      #####  #####           #####
	################  ###############  ####      #####  #####           #####
	#####      #####  #####     #####  ####      #####  #####           #####
	#####      #####  #####     #####  #####     #####  #####           #####
	#####      #####  #####     #####  #######   #####  #####    ###    #####
	################  ###############  ######### #####  #####################
	################  ###############  ###############  #########   #########
	#####             #####     #####  #####  ########  #######       #######
	#####             #####     #####  #####    ######  #####          ######
	#####             #####     #####  #####     #####  ####            #####

# ----------------------------------------------------------------------------------------------------------- #
# -	# INFO #											    - #
# -	This script is designed to autobackup Palo Alto Networks Next Generation Firewalls;		    - #
# -	It uses XML API;										    - #
# -	And it uses CURL to connect to the PANW firewall through XML API ang get the backup data;	    - #
# -	To generate the Key/Token the user needs to have permition to access the PANW running-config via    - #
# - 	XML API.											    - #
# -	The script uses only the access Key/Token to get the running-config data on PANW, so the user       - #
# -	credencial is not necessary.									    - #
# -													    - #
# -	To generate the Key/Token on Palo Alto use the follow syntax:					    - #
# -	https://${HOST}/api/type=keygen&user=${USER}&password=${PW}					    - #
# -                                                                                                         - #
# -	E.g.: https://10.1.1.1/api/?type=keygen&user=felipe&password=12345				    - #
# -                                                                                                         - #
# -	This script downloads the backup file to a temporary diretory and moves it to a local directory	    - #
# -	or to a remote HTTP, FTP or File Server.							    - #
# -													    - #
# -	Tip: Use Crontab to schedule the backup routine.						    - #
# ----------------------------------------------------------------------------------------------------------- #


# ----------------------------------------------------------------------------------------------------------- #
# -                                   VARIABLES DEFINITIONS				       		    - #
# ----------------------------------------------------------------------------------------------------------- #

## PANW access Token/Key (insert the Token/Key generated via XML API):
KEY='1LUFRPT1W9vS589KU1pNVmoyZFhMTHN6MmhnbWFBNitxZmprbWc9THBrYUZTLzhodHA5WHE3QTN877azNBdz09'

## PANW Hostname or IP
PANW='10.1.1.1'

## Local temp dir
TEMPDIR='/tmp'

## Date and Time
DATESCRIPT=`date +%F_%H_%M_%S`

# ----------------------------------------------------------------------------------------------------------- #
# -	 You can store the permanent backup file localy on this server or you can move file to a remote	    - #
# -	 storage via FTP, HTTP ou File Server.								    - #
# -	 Define the kind of information you need according the kind of service you will use to archive 	    - #
# -	 the backup files.										    - #
# ----------------------------------------------------------------------------------------------------------- #
# -	       SET AND UNCOMMENT THE VARIABLES OF THE KIND OF SERVICE YOU WILL USE		   	    - #
# ----------------------------------------------------------------------------------------------------------- #

## Local Dir to permanently store the backup files
#	BACKUPDIR='/root/backup'

## HTTP Server to upload and permanently store the backup files
#	HTTPSERVER='10.1.1.50:8080/Folder'

## FTP Server and credentials to permanenttly store the backup files
#	FTPSERVER='10.1.1.50'
#	FTPUSER_PASS='user:password'

## File Server and credentials to permanenttly store the backup files
	FSSERVER='//10.1.1.50/Folder'
	FSUSER_PASS='user%password'
	FSDOMAIN='corp'


# ----------------------------------------------------------------------------------------------------------- #
# -			 TO DOWNLOAD THE BACKUP FILE TO TEMP DIRECTORY					    - #
# ----------------------------------------------------------------------------------------------------------- #

## Uses CURL to download the backup file using PANW Token access defined above

	cd "$TEMPDIR"
		curl --output ${PANW}.xml -k "https://${PANW}/api/?type=config&action=show&key=${KEY}"


# ----------------------------------------------------------------------------------------------------------- #
# -			 SEND THE BACKUP FILE TO THE PERMANENT LOCAL OR REMOTE DIR			    - #
# -			 UNCOMMENT ONLY THE CORRESPONDING LINE TO THE TYPE OF SERVICE YOU WILL USE	    - #
# ----------------------------------------------------------------------------------------------------------- #

##  If you want to move the file to a local dir, uncomment the line below:

#	cd "$BACKUPDIR" &&  mv "$TEMPDIR/${PANW}.xml" "backup_panw_"${PANW}_${DATESCRIPT}.xml


##  If you want to sent the file to a remote HTTP Server, uncomment the line below:

#	mv "$TEMPDIR/${PANW}.xml" "backup_panw_"${PANW}_${DATESCRIPT}.xml && curl -X POST -F "Filedata=@${TEMPDIR}/backup_panw_${PANW}_${DATESCRIPT}.xml" http://${HTTPSERVER} && rm -rf ${TEMPDIR}/*.xml


##  If you want to sent the file to a remote FTP Server, uncomment the line below:

#       mv "$TEMPDIR/${PANW}.xml" "backup_panw_"${PANW}_${DATESCRIPT}.xml && curl -T "$TEMPDIR/backup_panw_${PANW}_${DATESCRIPT}.xml" ftp://${FTPUSER_PASS}@${FTPSERVER} && rm -rf ${TEMPDIR}/*.xml


##  If you want to sent the file to a remote File Server ** SMB client is required to be installed in this server **, uncomment the line below:

       mv "$TEMPDIR/${PANW}.xml" "backup_panw_"${PANW}_${DATESCRIPT}.xml && smbclient ${FSSERVER} -W ${FSDOMAIN} -U ${FSUSER_PASS} -c "prompt; recurse; mput *.xml" && rm -rf $TEMPDIR/*.xml


##   ;)

