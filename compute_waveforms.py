# SYSTEM IMPORTS
import os
import sys


# PYTHON PROJECT IMPORTS


def process_file(waveform_file_handle, power_file_path):
    with open(power_file_path, "r") as f:
        for line in f:
            if "runtime dynamic" in line.lower():
                line_parts = line.split("=")
                assert(len(line_parts) == 2)
                waveform_file_handle.write("%s\n" % line_parts[1].strip().split(" ")[0])
                return True
    print("ERROR: No runtime dynamic line found!")
    return False


def process_directory(waveform_dir, mcpat_dir, d):
    waveform_file = os.path.join(waveform_dir, "%s.waveform" % d)
    power_dir = os.path.join(mcpat_dir, d)

    files = os.listdir(power_dir)
    file_tuples = list()
    for f in files:
        start_index = f.index("_")
        end_index = f.index(".txt")
        file_tuples.append((int(f[start_index+1:end_index]),f,))
    with open(waveform_file, "w") as wf:
        for f in sorted(file_tuples, key=lambda x: x[0]):
            print("\tProcessing file [%s]" % f[1])
            if not process_file(wf, os.path.join(power_dir, f[1])):
                return False
    return True

def main():
    cd = os.path.abspath(os.path.dirname(__file__))
    mcpat_dir = os.path.join(cd, "mcpat_src", "mcpat_out")
    waveform_dir = os.path.join(cd, "gem5_waveforms")

    if not os.path.exists(waveform_dir):
        os.makedirs(waveform_dir)

    for d in os.listdir(mcpat_dir):
        print("Entering directory [%s]" % d)
        if not process_directory(waveform_dir, mcpat_dir, d):
            return
        print("Exiting directory [%s]" % d)


if __name__ == "__main__":
    main()

