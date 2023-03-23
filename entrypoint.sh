#!/bin/bash

#
# Entrypoint script runs some command or benchmark
# Author: Stanislav V. Emets <stas@emets.su>
#

# try run parameters passed to container and exit
if [ $# -gt 0 ]; then
    $@
    exit $?
fi

HOST=${REDIS_HOST:-127.0.0.1}
PORT=${REDIS_PORT:-6379}
PASSWORD=${REDIS_PASSWORD:-""}

TEST_CLIENTS=${REDIS_TEST_CLIENT:-50}
TEST_REQUESTS=${REDIS_TEST_REQUESTS:-100000}
TEST_SIZE=${REDIS_TEST_SIZE:-3}
TEST_CONNECTIONS=${REDIS_TEST_CONNECTIONS:-1}
TESTS=${REDIS_TESTS:-""}

CUSTOM_ARGS=${REDIS_CUSTOM_ARGS:-""}

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
    EXTRA_ARGS="${EXTRA_ARGS} -k ${TEST_CONNECTIONS}"
fi

if [ ${TEST_SIZE} -ne 3 ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -d ${TEST_SIZE}"
fi

if [ -n "${PASSWORD}" ]; then
    EXTRA_ARGS="${EXTRA_ARGS} -a ${REDIS_PASSWORD} "
fi

if [ -n "${CUSTOM_ARGS}" ]; then
    EXTRA_ARGS="${EXTRA_ARGS} ${CUSTOM_ARGS}"
fi

redis-benchmark -h ${HOST} -p ${PORT} -n ${TEST_REQUESTS} ${EXTRA_ARGS}

