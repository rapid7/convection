#!/bin/bash

FILES=$*

function my_curl {
    # Because curl can't retry with backoff on its own
    local URL=$1
    local TRIES=5
    local RC=1
    for TRY in `seq 1 $TRIES`; do
        curl -sO "$URL"
        RC=$?
        if [ $RC -eq 0 ]; then
            break
        else
            sleep $TRY
        fi
    done
    if [ $RC -ne 0 ]; then
        echo "ERROR: could not curl $URL successfully after $TRIES tries!  Exiting"
        exit 1
    fi
}

if [ -z "$FILES" ]; then
    my_curl "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html"
    # Yes, echo cat.  That puts the entire html file on one line (ie, strips newlines)
    FILES="$(echo `cat aws-template-resource-type-ref.html` | egrep -o 'Topics.+' | egrep -o 'aws[a-z0-9-]+.html')"
fi

for FILE in $FILES; do
    if [ ! -f "$FILE" ]; then
        my_curl "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/$FILE"
    fi
    TMPFILE=".$FILE.`date +%s`.tmp"
    RESOURCE=`egrep 'Type[ ":]+AWS::' $FILE | egrep -o 'AWS::[a-zA-Z0-9]+::[a-zA-Z0-9]+' | head -1`
    egrep -o 'span class="term"..code class="(code|literal)".[a-zA-Z0-9]+.\/|replacement..Replacement' $FILE > $TMPFILE
    NUM_LINES=`wc -l $TMPFILE | awk '{print $1}'`
    if [ $NUM_LINES -eq 0 ]; then
        # We don't really need to print this warning
        #echo "#WARNING: could not find any properties for $RESOURCE in $FILE"
        continue
    fi
    for LINE_NUM in `seq 1 $NUM_LINES`; do
        THIS_LINE=`head -n $LINE_NUM $TMPFILE | tail -1`
        if [ $LINE_NUM == $NUM_LINES ]; then
            break
        fi
        if [[ "$THIS_LINE" =~ Replacement ]]; then
            continue
        fi
        NEXT_LINE_NUM=`expr $LINE_NUM + 1`
        NEXT_LINE=`head -n $NEXT_LINE_NUM $TMPFILE | tail -1`
        if [[ "$NEXT_LINE" =~ "Replacement" ]]; then
            PROPERTY=`echo $THIS_LINE | egrep -o '[A-Z][A-Za-z0-9]+'`
            echo "'$RESOURCE.$PROPERTY',"
        fi
    done

    rm $TMPFILE
done
