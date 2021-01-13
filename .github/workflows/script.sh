#!/bin/bash
# Detect issues in URL Rewrite Rules 
set -euo pipefail

output=""

for file in $(find /home/runner/work/UrlRewriteRuleCheckingGHAction/UrlRewriteRuleCheckingGHAction -name 'Web.config')
do
        lineNumber=1
        for line in $(xmlstarlet sel -T -t -m /configuration/system.webServer/rewrite/rules/rule/match/@url -v . -n "$file")
        do
                if [[ $line != \^* ]] || [[ $line != *\$ ]]
                then
                        output+="Line Item: <br /><br /> $line <br /><br /> in $file on line $lineNumber;"
                fi

                ((lineNumber+=1))
        done
done

echo "::set-output name=ERROR_LINES::${output::-1}"