################################################################################
# Sample master configuration file. Must be located in ${PICLE_CONF}, which
# defaults to ${PICLE_HOME}/config.
################################################################################

# Node Configuration #
PRIMARY_NODE="jr-0"
CLUSTER_MEMBERS="${PICLE_HOME}/config/cluster-members.txt"
UPDATE_DIR="/srv/nfs/${PRIMARY_NODE}/sys/updates"

# Users #
USER_GROUPS="users" # (comma-separated)
USER_HOME_DIR="/srv/nfs/${PRIMARY_NODE}/home"

# Network #
read -r -d '' NET_SETTINGS <<EOM
Domains=cs.colostate.edu colostate.edu
DNS=129.82.45.181
DNS=129.82.103.78
DNS=129.82.103.79
Gateway=10.1.208.1
EOM

# NFS #
NFS_DIRS="/srv/nfs/${PRIMARY_NODE}/
          /srv/nfs/${PRIMARY_NODE}/home
          /srv/nfs/${PRIMARY_NODE}/sys
"
NFS_OPTS="rw,no_subtree_check,nohide,root_squash"
