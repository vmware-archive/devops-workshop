#! /bin/sh

CERT_URLS=(http://www.boeing.com/crl/Boeing%20Basic%20Assurance%20Hardware%20Root%20CA.crt http://www.boeing.com/crl/Boeing%20Basic%20Assurance%20Software%20Issuing%20CA%20G3.crt http://www.boeing.com/crl/Boeing%20Basic%20Assurance%20Software%20Root%20CA%20G2.crt http://www.boeing.com/crl/Boeing%20SecureBadge%20Basic%20G2.crt http://www.boeing.com/crl/Boeing%20SecureBadge%20Medium%20G2.crt http://www.boeing.com/crl/The%20Boeing%20Company%20Class%202%20Certificate%20Authority%20G2.crt http://www.boeing.com/crl/The%20Boeing%20Company%20Root%20Certificate%20Authority.crt)
CERT_DIR=~/Downloads/BoeingCerts

function main {
	echo "Make sure you are running GitBash/MingW/Cygwin/etc as admin before continuing!"
	echo "Please report any bugs to Alexander Schwach"
	read -n1 -r -p "Press any key to continue..." key

	echo "Attempting to find JDK automatically..."
	JDK_NUM=`ls /c/Program\ Files/Java | grep jdk | wc -l`

	if [ $JDK_NUM -eq 1 ]
	then
		JDK=`ls /c/Program\ Files/Java | grep jdk `
		JDK_PATH="/c/Program Files/Java/${JDK}"
		echo "Found 1 JDK at ${JDK_PATH}!" && echo
		importCerts
	fi
	
	if [ $JDK_NUM -eq 0 ]
	then
		echo "No JDKs found at /c/Program Files/Java!"
		askJDK
	fi
	
	if [ $JDK_NUM -gt 1 ]
	then
		echo "More than 1 JDK found at /c/Program Files/Java"
		askJDK
	fi
}

function importCerts {
	echo "Checking JDK directory..."
	if [ ! -d "$JDK_PATH" ]; then
		echo "Directory '${$JDK_PATH}' does not exist! Exiting..."
		exit 1
	else 
		echo "JDK Directory good!" && echo
	fi
	
	# Check for required keytool.exe
	echo "Checking for keytool.exe..."
	if [ ! -f "$JDK_PATH/bin/keytool.exe" ]; then
		echo "Could not find keytool! Exiting..."
		exit 1
	else 
		KEYTOOL=$JDK_PATH/bin/keytool.exe
		echo "Found keytool.exe!" && echo
	fi
	
	# Check for required cacerts
	echo "Checking for cacerts..."
	if [ ! -f "$JDK_PATH/jre/lib/security/cacerts" ]; then
		echo "Could not find cacerts! Exiting..."
		exit 1
	else 
		CACERTS=$JDK_PATH/jre/lib/security/cacerts
		echo "Found cacerts!" && echo
	fi
	
	# Download Boeing Certificates
	echo "Downloading Boeing Certificates..."
	if [ ! -d "$CERT_DIR" ]; then
		mkdir $CERT_DIR
	fi
	
	for i in "${CERT_URLS[@]}"
	do
		CERT_FILEPATH=$CERT_DIR/`basename $i`
		if [ -f "$CERT_FILEPATH" ]; then
			rm $CERT_FILEPATH
		fi
		curl $i > $CERT_FILEPATH
	done
	echo "Certificates Downloaded!" && echo
	
	echo "Importing Certificates to JDK Keystore..."
	CERTS=$CERT_DIR/*
	echo $CERTS
	for cert in $CERTS
	do
		CERTNAME=`basename $cert`
		echo $KEYTOOL
		"${KEYTOOL}" -keystore "${CACERTS}" -importcert -alias $CERTNAME -file "${cert}" -storepass changeit
	done
	echo "Import Successful!" && echo
}

function askJDK {
	echo "Please enter the path of the JDK you want to import certificates to:"
	read JDK_PATH
}

main "$!"