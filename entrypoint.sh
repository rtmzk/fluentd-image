#!/bin/sh


if dpkg --print-architecture | grep -q amd64;then
    export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
else
    export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libjemalloc.so.2
fi

SIMPLE_SNIFFER_ELASTICSEARCH=$( gem contents fluent-plugin-elasticsearch | grep elasticsearch_simple_sniffer.rb )
if [ -n "$SIMPLE_SNIFFER_ELASTICSEARCH" ] && [ -f "$SIMPLE_SNIFFER_ELASTICSEARCH" ] ; then
    FLUENTD_ARGS="$FLUENTD_ARGS -r $SIMPLE_SNIFFER_ELASTICSEARCH"
fi

SIMPLE_SNIFFER_OPENSEARCH=$( gem contents fluent-plugin-opensearch | grep opensearch_simple_sniffer.rb )
if [ -n "$SIMPLE_SNIFFER_OPENSEARCH" ] && [ -f "$SIMPLE_SNIFFER_OPENSEARCH" ] ; then
    FLUENTD_ARGS="$FLUENTD_ARGS -r $SIMPLE_SNIFFER_OPENSEARCH"
fi

exec /usr/local/bundle/bin/fluentd $FLUENTD_ARGS