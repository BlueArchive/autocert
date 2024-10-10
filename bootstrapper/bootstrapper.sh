#!/bin/sh

if [ -f "$CRT" ];
then
    echo "Found existing $CRT. This can happen in daemonset pods after node reboot. If the certificate is expired, renewal will fail. Raising an error to force recreation of the autocert-bootstrapper container."
    exit 1
fi

# Download the root certificate and set permissions
if [ "$DURATION" == "" ];
then
    step ca certificate $COMMON_NAME $CRT $KEY
else
    step ca certificate --not-after $DURATION $COMMON_NAME $CRT $KEY
fi

step ca root $STEP_ROOT

if [ -n "$OWNER" ]
then
    chown "$OWNER" $CRT $KEY $STEP_ROOT
fi

if [ -n "$MODE" ]
then
    chmod "$MODE" $CRT $KEY $STEP_ROOT
else
    chmod 644 $CRT $KEY $STEP_ROOT
fi

