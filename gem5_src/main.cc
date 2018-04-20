// SYSTEM IMPORTS
#include <pocketsphinx.h>
#include <string>
#include <vector>


// C++ PROJECT IMPORTS


std::string get_dir_of_file() {
    std::string current_path = __FILE__;
    size_t found = current_path.find_last_of("/\\');
    return current_path.substr(0, found);
}

std::string path_join(std::vector<std::string>& args)
{
    std::string joined_path;
    for(std::string& arg: args)
    {
        joined_path += "/";
        joined_path += arg;
    }
    return joined_path;
}

int main(int argc, char** argv)
{
    current_dir = get_dir_of_file();

    ps_decoder_t *ps;
    cmd_ln_t *config;
    FILE *fh;
    char const *hyp, *uttid;
    int16 buf[512];
    int rv;
    int32 score;

    config = cmd_ln_init(NULL, ps_args(), TRUE,
		         "-hmm", MODELDIR "/en-us/en-us",
		         "-lm", MODELDIR "/en-us/en-us.lm.bin",
	    		 "-dict", MODELDIR "/en-us/cmudict-en-us.dict",
		         NULL);
    if (config == NULL) {
	fprintf(stderr, "Failed to create config object, see log for details\n");
	return -1;
    }

    ps = ps_init(config);
    if (ps == NULL) {
	fprintf(stderr, "Failed to create recognizer, see log for details\n");
	return -1;
    }

    fh = fopen("goforward.raw", "rb");
    if (fh == NULL) {
	fprintf(stderr, "Unable to open input file goforward.raw\n");
	return -1;
    }

    rv = ps_start_utt(ps);

    while (!feof(fh)) {
	size_t nsamp;
	nsamp = fread(buf, 2, 512, fh);
	rv = ps_process_raw(ps, buf, nsamp, FALSE, FALSE);
    }

    rv = ps_end_utt(ps);
    hyp = ps_get_hyp(ps, &score);
    printf("Recognized: %s\n", hyp);

    fclose(fh);
    ps_free(ps);
    cmd_ln_free_r(config);

    return 0;
}
}

