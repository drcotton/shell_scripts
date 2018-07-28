# Script to automate nmap scans  and pickup changes to an email
# created  07 07 17
#!/bin/bash
# do the nmap scan ##
# store the nmap scan in a location with all the files
# compare the results of the two files
# output the results of that to a temp location
# email the results of that to security.alerts
# requires nmap and ndiff pacakges installed

#nmap -sV -T4 -O -F --version-light $CIDRBLOCK

DATE=`date +%F`

## Begin Config

# The directory for autonmap data/scans
RUN_DIRECTORY="/usr/local/nmap/"

# The subnets you want to scan daily, space seperated.
SCAN_SUBNETS="172.18.100.1-254"

# The full path to your chosen nmap binary
NMAP="/usr/bin/nmap"

# The path to the ndiff tool provided with nmap
NDIFF="/usr/bin/ndiff"

# The email address(es), space seperated that you wish to send the email report to.
EMAIL_RECIPIENTS="whoeverwantsit@thataddress.com"

## End config

echo "`date` - Nmap emailer "

# Ensure we can change to the run directory
cd $RUN_DIRECTORY || exit 2
echo "`date` - Running nmap, please wait. This may take a while.  "

$NMAP --open -sV -T4 -O -F $SCAN_SUBNETS -n -oX scan-$DATE-$SCAN_SUBNETS.xml > /dev/null
echo "`date` - Nmap process completed with exit code $?"

# If this is not the first time autonmap2 has run, we can check for a diff. Otherwise skip this section, and tomorrow when the link exists we can diff.
if [ -e scan-prev.xml ]
then
    echo "`date` - Running ndiff..."
    # Run ndiff with the link to yesterdays scan and todays scan
    DIFF=`$NDIFF scan-prev-$SCAN_SUBNETS.xml scan-$DATE-$SCAN_SUBNETS.xml`

    echo "`date` - Checking ndiff output"
    # There is always two lines of difference; the run header that has the time/date in. So we can discount that.
    if [ `echo "$DIFF" | wc -l` -gt 2 ]
    then
            echo "`date` - Differences Detected. Sending mail."
            echo "Nmap found differences in a scan for ${SCAN_SUBNETS} since yesterday.  \n\n$DIFF\n\n" | mail -s "Nmap Changes Detected on ${SCAN_SUBNETS}" $EMAIL_RECIPIENTS
    else
            echo "`date`- No differences, skipping mail. "
    fi
else
    echo "`date` - There is no previous scan (scan-prev.xml). Cannot diff today; will do so tomorrow."
fi

# Create the link from today's report to scan-prev so it can be used tomorrow for diff.
echo "`date` - Copying todays scan to scan-prev.xml"
cp scan-$DATE-$SCAN_SUBNETS.xml scan-prev-$SCAN_SUBNETS.xml
echo "`date` - Nmap is complete."
exit 0
