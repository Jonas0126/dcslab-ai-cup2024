#!/bin/bash



for i in {0..7}
do
    python main.py -f IMAGE/1016_150000_151900/ -l yolov8/1016_150000_151900/ --out v8_result/labels/1016_150000_151900 --cam "$i"

    # Confirm whether the ground truth file exists.
    if ! [ -d MOT15/aicup_gt/1016_150000_151900 ]
    then
        echo python parseAicup.py -s aicup_gt/labels/1016_150000_151900 -l LABEL/1016_150000_151900/
        python parseAicup.py -s aicup_gt/labels/1016_150000_151900 -l LABEL/1016_150000_151900/

        echo python tools/datasets/AICUP_to_MOT15.py --AICUP_dir aicup_gt/labels/1016_150000_151900 --MOT15_dir MOT15/aicup_gt/1016_150000_151900
        python tools/datasets/AICUP_to_MOT15.py --AICUP_dir aicup_gt/labels/1016_150000_151900 --MOT15_dir MOT15/aicup_gt/1016_150000_151900
    fi

    # Convert the results from AICUP format to MOT15 format.
    echo python tools/datasets/AICUP_to_MOT15.py --AICUP_dir v8_result/labels/1016_150000_151900/"$i" --MOT15_dir MOT15/v8/1016_150000_151900
    python tools/datasets/AICUP_to_MOT15.py --AICUP_dir v8_result/labels/1016_150000_151900/"$i" --MOT15_dir MOT15/v8/1016_150000_151900

    # Evaluate the result.
    echo python tools/evaluate.py --gt_dir MOT15/aicup_gt/1016_150000_151900 --ts_dir MOT15/v8/1016_150000_151900 --mode single_cam --cam "$i"
    python tools/evaluate.py --gt_dir MOT15/aicup_gt/1016_150000_151900 --ts_dir MOT15/v8/1016_150000_151900 --mode single_cam --cam "$i"
done