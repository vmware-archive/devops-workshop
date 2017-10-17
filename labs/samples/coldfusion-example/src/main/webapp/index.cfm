<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cold Fusion on Cloud Foundry? It's magic!</title>
    </head>
    <body>
        <h3>More than a few tricks up our sleeves here</h3> 
        <p>cfset, cfloop, and cfhttp tags are exercised in this Cold Fusion example.</p>
        <cfset greeting="Hello World">
        <cfoutput>
            #greeting#</br>

            <cfloop from="1" to="5" index="i">
	            #i#<br />
            </cfloop>

            <cfhttp url="http://maps.googleapis.com/maps/api/geocode/xml?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&sensor=false" method="get" result="httpResp" timeout="60">
                <cfhttpparam type="header" name="Content-Type" value="application/json" />
            </cfhttp>

            Rest Output: #httpResp.FileContent#
        </cfoutput>
    </body>
</html>