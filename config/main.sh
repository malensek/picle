################################################################################
# Sample master configuration file. Must be located in ${PICLE_CONF}, which
# defaults to ${PICLE_HOME}/config.
################################################################################
MASTER_NODE="pi-0"
CLUSTER_MEMBERS="${PICLE_HOME}/config/cluster-members.txt"
USER_HOME_DIR="/srv/nfs/${MASTER_NODE}/home"
UPDATE_DIR="/srv/nfs/${MASTER_NODE}/sys/updates"

NFS_DIRS="/srv/nfs/${MASTER_NODE}/
          /srv/nfs/${MASTER_NODE}/home
          /srv/nfs/${MASTER_NODE}/sys
"
NFS_OPTS="rw,no_subtree_check,nohide,root_squash"
