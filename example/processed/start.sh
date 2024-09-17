#!/bin/bash

# change this to one of the dataset names {rectangle_proc, loop_proc, forward_proc, lateral_proc, vertical_proc, hover_proc}
DATASET=rectangle_proc

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
MAIN_DIR="$SCRIPT_PATH/logs"
PROJECT_NAME=mas_processed_dataset
SESSION_NAME=mas_processed_dataset

pre_input="export UAV_NAME=uav25"

input=(
# run ros master as the first thing (other nodes wait for master)
  'roscore' 'roscore
'
# use timestamps from rosbag instead of current wall time
  'rosparam' './waitForRos.sh; rosparam set use_sim_time true
'
# publish static tfs
  'static_tfs' './waitForRos.sh; roslaunch mas_datasets static_tfs.launch
'
# play the whole bag
  'rosbag_play' './waitForRos.sh; rosbag play ../../bag_files/processed/'"$DATASET"'.bag --clock -r 1.0
'
# run rviz
  'rviz' './waitForRos.sh; rosrun rviz rviz -d ./rviz.rviz
'
)

# the name of the window to focus after start
init_window="rosbag_play"

# automatically attach to the new session?
# {true, false}, default true
attach=true

###########################
### DO NOT MODIFY BELOW ###
###########################

export TMUX_BIN="/usr/bin/tmux"

# find the session
FOUND=$( $TMUX_BIN ls | grep $SESSION_NAME )

if [ $? == "0" ]; then
  echo "The session already exists"
  $TMUX_BIN -2 attach-session -t $SESSION_NAME
  exit
fi

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

TMUX= $TMUX_BIN new-session -s "$SESSION_NAME" -d
echo "Starting new session."

# get the iterator
ITERATOR_FILE="$MAIN_DIR/$PROJECT_NAME"/iterator.txt
if [ -e "$ITERATOR_FILE" ]
then
  ITERATOR=`cat "$ITERATOR_FILE"`
  ITERATOR=$(($ITERATOR+1))
else
  echo "iterator.txt does not exist, creating it"
  mkdir -p "$MAIN_DIR/$PROJECT_NAME"
  touch "$ITERATOR_FILE"
  ITERATOR="1"
fi
echo "$ITERATOR" > "$ITERATOR_FILE"

# create file for logging terminals' output
LOG_DIR="$MAIN_DIR/$PROJECT_NAME/"
SUFFIX=$(date +"%Y_%m_%d_%H_%M_%S")
SUBLOG_DIR="$LOG_DIR/"$ITERATOR"_"$SUFFIX""
TMUX_DIR="$SUBLOG_DIR/tmux"
mkdir -p "$SUBLOG_DIR"
mkdir -p "$TMUX_DIR"

# link the "latest" folder to the recently created one
rm "$LOG_DIR/latest" > /dev/null 2>&1
rm "$MAIN_DIR/latest" > /dev/null 2>&1
ln -sf "$SUBLOG_DIR" "$LOG_DIR/latest"
ln -sf "$SUBLOG_DIR" "$MAIN_DIR/latest"

# create arrays of names and commands
for ((i=0; i < ${#input[*]}; i++));
do
  ((i%2==0)) && names[$i/2]="${input[$i]}"
  ((i%2==1)) && cmds[$i/2]="${input[$i]}"
done

# run tmux windows
for ((i=0; i < ${#names[*]}; i++));
do
  $TMUX_BIN new-window -t $SESSION_NAME:$(($i+1)) -n "${names[$i]}"
done

sleep 3

# start loggers
for ((i=0; i < ${#names[*]}; i++));
do
  $TMUX_BIN pipe-pane -t $SESSION_NAME:$(($i+1)) -o "ts | cat >> $TMUX_DIR/$(($i+1))_${names[$i]}.log"
done

# send commands
for ((i=0; i < ${#cmds[*]}; i++));
do
  $TMUX_BIN send-keys -t $SESSION_NAME:$(($i+1)) "cd $SCRIPTPATH;${pre_input};${cmds[$i]}"
done

# identify the index of the init window
init_index=0
for ((i=0; i < ((${#names[*]})); i++));
do
  if [ ${names[$i]} == "$init_window" ]; then
    init_index=$(expr $i + 1)
  fi
done

$TMUX_BIN select-window -t $SESSION_NAME:$init_index

if $attach; then

  if [ -z ${TMUX} ];
  then
    $TMUX_BIN -2 attach-session -t $SESSION_NAME
  else
    tmux detach-client -E "tmux a -t $SESSION_NAME"
  fi
else
  echo "The session was started"
  echo "You can later attach by calling:"
  echo "  tmux a -t $SESSION_NAME"
fi
