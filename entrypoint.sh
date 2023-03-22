#!/bin/sh

#
# Entrypoint script runs some command or benchmark
# Author: Stanislav V. Emets <stas@emets.su>
#

# try run parameters passed to container and exit
if [ $# -gt 0 ]; then
    $@
    exit $?
fi

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=""

TEST_CLIENTS=50
TEST_REQUESTS=100000
TEST_SIZE=3
TEST_CONNECTIONS=1
TESTS=""

EXTRA_ARGS=""

if [ ${TEST_CLIENTS} -ne 50 ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -c ${TEST_CLIENTS}"
fi

if [ ${TEST_SIZE} -ne 3 ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -d ${TEST_SIZE}"
fi

if [ -n "${TESTS}" ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -t ${TESTS}"
fi

if [ ${TEST_CONNECTIONS} -gt 1 ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -c ${TEST_CONNECTIONS}"
fi

if [ ${TEST_SIZE} -ne 3 ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -d ${TEST_SIZE}"
fi

if [ -n "${REDIS_PASSWORD}" ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -a ${REDIS_PASSWORD} "
fi

echo "redis-benchmark -h ${REDIS_HOST} -p ${REDIS_PORT} -n ${TEST_REQUESTS} ${EXTRA_ARGS}"

