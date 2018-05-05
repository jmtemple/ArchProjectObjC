# SYSTEM IMPORTS
import os
import shutil
import sys


# PYTHON PROJECT IMPORTS


BEGIN_TAG = "---------- Begin Simulation Statistics ----------"
END_TAG = "---------- End Simulation Statistics   ----------"


def process_stats(out_exp_dir, stats_path):
    data = list()
    exp = list()
    with open(stats_path, "r") as f:
        for line in f:
            exp.append(line)
            if END_TAG in line:
                data.append(exp)
                exp = list()
    for i, d in enumerate(data):
        with open(os.path.join(out_exp_dir, "stats_%s.txt" % i), "w") as f:
            for l in d:
                if l.endswith("\n"):
                    f.write(l)
                else:
                    f.write(l + "\n")


def process_experiment_dir(out_dir, gem5_out_dir, exp_dir):
    out_exp_dir = os.path.join(out_dir, exp_dir)
    if not os.path.exists(out_exp_dir):
        os.makedirs(out_exp_dir)
    print("Entering directory [%s]" % exp_dir)

    for f in os.listdir(os.path.join(gem5_out_dir, exp_dir)):
        print("\tprocessing file [%s]" % f)
        if not f.endswith(".txt"):
            shutil.copy2(os.path.join(gem5_out_dir, exp_dir, f), os.path.join(out_exp_dir, f))
        else:
            process_stats(out_exp_dir, os.path.join(gem5_out_dir, exp_dir, f))

    print("Exiting directory [%s]" % exp_dir)


def main():
    cd = os.path.abspath(os.path.dirname(__file__))
    gem5_out_dir = os.path.join(cd, "..", "gem5_src", "gem5_out")
    out_dir = os.path.join(cd, "gem5_out")
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)
    for exp_dir in sorted(os.listdir(gem5_out_dir)):
        process_experiment_dir(out_dir, gem5_out_dir, exp_dir)
    
    # dirs = [d for d in os.listdir(gem5_out_dir) if "ipad" in d.lower() and "80" in d.lower()]
    # for d in sorted(dirs):
    #     process_experiment_dir(out_dir, gem5_out_dir, d)

if __name__ == "__main__":
    main()

