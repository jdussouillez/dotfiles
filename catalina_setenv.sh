#!/bin/bash

# Memory
#export CATALINA_OPTS="$CATALINA_OPTS -Xms128m"
#export CATALINA_OPTS="$CATALINA_OPTS -Xmx1024m"

# JMX
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9000"
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"

# JPDA (to attach a debugger)
export CATALINA_OPTS="$CATALINA_OPTS -agentlib:jdwp=transport=dt_socket,address=localhost:8000,server=y,suspend=n"

# Dump heap in case of OOM
DUMP_FOLDER="$CATALINA_BASE/dumps"
echo "Setting up the dump folder: $DUMP_FOLDER"
mkdir -p "$DUMP_FOLDER"
export CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath='$DUMP_FOLDER'"
