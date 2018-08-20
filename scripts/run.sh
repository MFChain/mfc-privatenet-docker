#!/bin/bash
#
# This script starts four consensus and waits forever
#

screen -dmS node1 expect /opt/start_consensus_node.sh /opt/node1/mfc-cli/ wallet1.json one
screen -dmS node2 expect /opt/start_consensus_node.sh /opt/node2/mfc-cli/ wallet2.json two
screen -dmS node3 expect /opt/start_consensus_node.sh /opt/node3/mfc-cli/ wallet3.json three
screen -dmS node4 expect /opt/start_consensus_node.sh /opt/node4/mfc-cli/ wallet4.json four

sleep infinity

