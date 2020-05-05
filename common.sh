#!/bin/bash
put() { echo "${*:2}" > "$XDG_RUNTIME_DIR/spywalker-var-$1"; }
get() { cat "$XDG_RUNTIME_DIR/spywalker-var-$1"; }
forget() { rm -f "$XDG_RUNTIME_DIR/spywalker-var-$1"; }