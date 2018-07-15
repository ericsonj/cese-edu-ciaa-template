#!/bin/bash

# Check .elf file argument
if [ -z "$1" ]
then
    echo "No file .elf supplied";
    exit 1;
fi

# Check gdbgui installed
if hash gdbgui 2>/dev/null; then
    echo "gdbgui OK";
else
    echo "gdbgui it's not installed";
    exit 1;
fi

# Check google-chrome 
if hash google-chrome 2>/dev/null; then
    echo "google-chrome OK";
else
    echo "google-chrome it's not installed";
    exit 1;
fi

# Check openocd 
if hash openocd 2>/dev/null; then
    echo "openocd OK";
else
    echo "openocd it's not installed";
    exit 1;
fi

make
make download
openocd -f scripts/openocd.cfg & export APP_PID=$!
echo $APP_PID
# run google-chrome app
google-chrome --app=http://127.0.0.1:5000 &
# run gdbgui
gdbgui $1 -x .gdb_cmd -g /ciaa/gcc-arm-none-eabi-4_9-2015q1/bin/arm-none-eabi-gdb -n
#arm-none-eabi-gdb --batch --command=run.gdb $1
#nemiver --remote=localhost:3333 --gdb-binary=/ciaa/gcc-arm-none-eabi-4_9-2015q1/bin/arm-none-eabi-gdb $1
kill -SIGINT $APP_PID
