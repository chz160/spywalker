#!/bin/bash
put() { echo "${*:2}" > "$XDG_RUNTIME_DIR/spywalker-var-$1"; }
get() { cat "$XDG_RUNTIME_DIR/spywalker-var-$1"; }
forget() { rm -f "$XDG_RUNTIME_DIR/spywalker-var-$1"; }

function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function throw()
{
    exit $1
}

function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}

function throwErrors()
{
    set -e
}

function ignoreErrors()
{
    set +e
}