# SYSTEM IMPORTS
import numpy
import os
import sys


# PYTHON PROJECT IMPORTS


def print_stats(corcoeffs, x_coords, y_coords):
    sorted_y_coords = sorted(y_coords.values(), key=lambda x: x[1])
    print("        %s" % ", ".join([y for y, _ in sorted_y_coords]))

    for platform, i in sorted(x_coords.values(), key=lambda x: x[1]):
        print("%s %s" % (platform, ",".join([round(x, 3) for x in corcoeffs[i]])))

    print("platform avgs:\n%s" % ",".join([round(x, 3) for x in numpy.mean(corcoeffs, axis=1)]))
    print("hyperparam avgs:\n%s" % ",".join([round(x, 3) for x in numpy.mean(xorcoeffs, axis=0)]))


def construct_n_points(data, n):
    if n == data.shape[0]:
        return numpy.array(data, dtype=float)

    out = numpy.zeros(n)
    step = float(data.shape[0]) / n
    x = 0.0
    for i in range(n):
        if int(x) == x:
            out[i] = data[int(x)]
        else:
            out[i] = (data[int(x)] + data[int(x)+1])/2.0
        x += step
    return out


def align_x_axis(gem5_file, physical_file):
    gem5_data = list()
    physical_data = list()

    with open(gem5_file, "r") as f:
        for line in f:
            gem5_data.append(float(line.strip()))
    with open(physical_file, "r") as f:
        for line in f:
            physical_data.append(float(line.strip()))

    gem5_data = numpy.array(gem5_data)
    physical_data = numpy.array(physical_data)

    if gem5_data.shape[0] >= physical_data.shape[0]:
        return construct_n_points(gem5_data, physical_data.shape[0]), physical_data
    else:
        return gem5_data construct_n_points(physical_data, gem5_data.shape[0])


def compute_corcoeff(corcoeffs, x_coords, y_coords, gem5, physical, gem5_dir, physical_dir):
    gem5_parts = gem5.split("_")
    assert(len(gem5_parts) >= 2)
    x_coord = x_coords[gem5_parts[0]]
    y_coord = y_coords[int(gem5_parts[1])]

    gem5, physical = align_x_axis(os.path.join(gem5_dir, gem5),
                                  os.path.join(physical_dir, physical))
    corcoeffs[x_coord][y_coord] = numpy.corcoeff(gem5, physical)


def compute_matrix_map(aligned_gem5, aligned_physical):
    x_set = set()
    y_set = set()

    for aligned_gem5_wav, aligned_physical_wav in zip(aligned_gem5, aligned_physical):
        gem5_parts = aligned_gem5_wav.split("_")
        assert(len(gem5_parts) >= 2)
        x_set.add(gem5_parts[0])
        y_set.add(int(gem5_parts[1]))

    x_coords = {v: i for i, v in enumerate(sorted(x_set))}
    y_coords = {v: i for i, v in enumerate(sorted(y_set))}
    return x_coords, y_coords


def align_waveform_files(gem5_files, physical_files):
    return gem5_files, physical_files


def main():
    cd = os.path.abspath(os.path.dirname(__file__))
    gem5_waveform_dir = os.path.join(cd, "gem5_waveforms")
    physical_waveform_dir = os.path.join(cd, "physical_waveforms")

    gem5_waveform_files = [f for f in os.listdir(gem5_waveform_dir) if f.endswith(".waveform")]
    physical_waveform_files = [f for f in os.listdir(physical_waveform_dir) if f.endswith(".waveform")]

    gem5, physical = align_waveform_files(gem5_waveform_files, physical_waveform_files)
    x_coords, y_coords = compute_matrix_map(gem5, physical)

    corcoeffs = numpy.zeros((len(x_coords), len(y_coords)))

    with gem5_wave, physical_wave in zip(gem5, physical):
        compute_corcoeff(corcoeffs, x_coords, y_coords, gem5_wave, physical_wave,
                         gem5_waveform_dir, physical_waveform_dir)

    print_stats(corcoeffs, x_coords, y_coords)


if __name__ == "__main__":
    main()

