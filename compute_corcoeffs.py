# SYSTEM IMPORTS
import collections
import numpy
import os
import sys


# PYTHON PROJECT IMPORTS


def print_stats(corcoeffs, x_coords, y_coords):
    sorted_y_coords = sorted(y_coords.items(), key=lambda x: x[1])
    # print(sorted_y_coords)
    print()
    print("Correlation Coefficients:")
    print("        %s" % (", ".join(["%s" % y for y, _ in sorted_y_coords])))

    platform_list = [p for p in sorted(x_coords.items(), key=lambda x: x[1])]

    for platform, i in platform_list:
        print("%s %s" % (platform, ",".join(["%s" % round(x, 3) for x in corcoeffs[i]])))

    print()
    print("platform avgs:")
    for (p, _), stat in zip(platform_list, [round(x, 3) for x in numpy.mean(corcoeffs, axis=1)]):
        print("\t%s: %s" % (p, stat))
    print()
    print("hyperparam avgs:")
    for (h, _), stat in zip(sorted_y_coords, [round(x, 3) for x in numpy.mean(corcoeffs, axis=0)]):
        print("\t%s: %s" % (h, stat))
    print("avg hyperparam correlation coef: %s" % round(numpy.mean(corcoeffs), 3))


def compress_into_n_points(data, n):
    if n == data.shape[0]:
        return numpy.array(data, dtype=float)

    new_x_coords = numpy.linspace(0, data.shape[0], num=n)
    old_x_coords = numpy.arange(data.shape[0])

    return numpy.interp(new_x_coords, old_x_coords, data)


def align_x_axis(gem5_file, physical_file):
    gem5_data = list()
    physical_data = list()

    with open(gem5_file, "r") as f:
        for line in f:
            if len(line.rstrip()) > 0:
                gem5_data.append(float(line.strip()))
    with open(physical_file, "r") as f:
        for line in f:
            if len(line.strip()) > 0:
                physical_data.append(float(line.strip()))

    gem5_data = numpy.array(gem5_data)
    physical_data = numpy.array(physical_data)

    if gem5_data.shape[0] >= physical_data.shape[0]:
        return compress_into_n_points(gem5_data, physical_data.shape[0]), physical_data
    else:
        return gem5_data, compress_into_n_points(physical_data, gem5_data.shape[0])


def compute_corcoeff(corcoeffs, x_coords, y_coords, gem5, physical, gem5_dir, physical_dir):
    gem5_parts = gem5.split("_")
    assert(len(gem5_parts) >= 2)
    x_coord = x_coords[gem5_parts[0]]
    y_coord = y_coords[int(gem5_parts[1])]

    gem5, physical = align_x_axis(os.path.join(gem5_dir, gem5),
                                  os.path.join(physical_dir, physical))
    corcoeffs[x_coord][y_coord] = abs(numpy.corrcoef(gem5, physical)[0][1])


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
    # lower_gem5 = [f.lower() for f in gem5_files]
    # lower_physical = [f.lower() for f in physical_files]

    # now to do alignment
    file_map = collections.defaultdict(lambda: collections.defaultdict(lambda: [None, None]))
    for g, p in zip(gem5_files, physical_files):
        g_parts = g.split("_")
        p_parts = p.split("_")

        g_platform = g_parts[0].lower()
        p_platform = p_parts[0].lower()

        g_hyperparam = int(g_parts[1])
        p_hyperparam = int(p_parts[1][:p_parts[1].index(".")])

        file_map[g_platform][g_hyperparam][0] = g
        file_map[p_platform][p_hyperparam][1] = p

    for p, d in file_map.items():
        print(p)
        for i, l in d.items():
            print("\t%s -> %s" % (i, l))

    for d in file_map.values():
        for l in d.values():
            assert(None not in l)

    aligned_gem5 = list()
    aligned_physical = list()

    for (_, d) in sorted(file_map.items(), key=lambda x: x[0]):
        for (_, l) in sorted(d.items(), key=lambda x: x[0]):
            aligned_gem5.append(l[0])
            aligned_physical.append(l[1])

    return aligned_gem5, aligned_physical

def main():
    cd = os.path.abspath(os.path.dirname(__file__))
    gem5_waveform_dir = os.path.join(cd, "gem5_waveforms")
    physical_waveform_dir = os.path.join(cd, "physical_waveforms")

    gem5_waveform_files = [f for f in os.listdir(gem5_waveform_dir) if f.endswith(".waveform")]
    physical_waveform_files = [f for f in os.listdir(physical_waveform_dir) if f.endswith(".waveform")]

    gem5, physical = align_waveform_files(gem5_waveform_files, physical_waveform_files)
    x_coords, y_coords = compute_matrix_map(gem5, physical)

    # print(x_coords)
    # print(y_coords)

    corcoeffs = numpy.zeros((len(x_coords), len(y_coords)))

    for gem5_wave, physical_wave in zip(gem5, physical):
        print("working on %s and %s" % (gem5_wave, physical_wave))
        compute_corcoeff(corcoeffs, x_coords, y_coords, gem5_wave, physical_wave,
                         gem5_waveform_dir, physical_waveform_dir)

    print_stats(corcoeffs, x_coords, y_coords)


if __name__ == "__main__":
    main()

