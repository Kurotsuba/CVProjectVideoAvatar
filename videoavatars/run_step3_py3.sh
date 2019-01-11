#!/bin/bash

if [ "$#" -le 1 ]; then
    echo "usage: run_step3_py3.sh <path_to_subject_directory> <output_directory> [options]" >&2
    exit 1
fi

SUBJ="$1"
OUT="$2"

if [[ $SUBJ = *"female"* ]]; then
  MODEL='--model vendor/smpl/models/basicModel_f_lbs_10_207_0_v1.0.0.pkl'
fi

python3 step3_texture_py3.py $SUBJ/consensus.pkl  $SUBJ/camera.pkl $SUBJ/$(basename $SUBJ).mp4 $SUBJ/reconstructed_poses.hdf5 $SUBJ/masks.hdf5 $OUT/tex-$(basename $SUBJ).jpg $MODEL ${@:3}
