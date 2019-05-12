
function get_container {
    ssh $remote docker ps -q --filter network=$2_default
}

# docker remote exec
function dre {
    target="$1"
    remote="${2:-stage}"
    id=$(get_container "${remote}" "${target}")
    ssh -tt $remote docker exec -it $id sh
}

# docker remote logs
function drl {
    target="$1"
    remote="${2:-stage}"
    id=$(get_container "${remote}" "${target}")
    ssh $remote docker logs $id
}

function get_dump {
    target="$1"
    remote="${2:-stage}"
    id=$(get_container "${remote}" "${target}")
    ssh $remote docker exec $id mkdir -p /dump
    ssh $remote docker exec $id touch /dump/.dumpignore
    ssh $remote docker exec $id dumper --dump-all
    ssh $remote docker cp $id:/dump /tmp/dump
    ssh $remote tar czf - /tmp/dump > dump.tgz
    ssh $remote rm -rf /tmp/dump
}

function get_backend {
    target="$1"
    remote="${2:-stage}"
    id=$(get_container "${remote}" "${target}")
    ssh $remote docker cp $id:/app/backend /tmp/backend
    ssh $remote tar czf - /tmp/backend > backend.tgz
    ssh $remote rm -rf /tmp/backend
}

