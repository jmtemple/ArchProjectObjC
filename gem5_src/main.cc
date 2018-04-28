// SYSTEM IMPORTS
#include <pocketsphinx.h>


// C PROJECT IMPORTS

int predict(int current_filename, ps_decoder_t* ps)
{
    FILE* fh;
    int rv;
    char const *hyp, *uttid;
    int16 buf[512];
    int32 score;

    const char* static_file_tmp = "./test_files/%d.wav";
    char path_buf[30];
    sprintf(path_buf, static_file_tmp, current_filename);

    fh = fopen(path_buf, "rb");
    if(fh == NULL) {
        fprintf(stderr, "Unable to open input file\n");
        return -1;
    }

    rv = ps_start_utt(ps);
    while (!feof(fh)) {
        fprintf(stdout, "processing line ");
	    size_t nsamp;
	    nsamp = fread(buf, 2, 512, fh);
	    rv = ps_process_raw(ps, buf, nsamp, FALSE, FALSE);
    }

    rv = ps_end_utt(ps);
    hyp = ps_get_hyp(ps, &score);
    fclose(fh);
    return 0;
}

int main(int argc, char** argv)
{
    ps_decoder_t *ps;
    cmd_ln_t *config;
    int frate;
    char frate_buff[1000];
    int max_filename = 75;
    bool no_error = true;

    if(argc < 2) {
        fprintf(stderr, "Usage: <program> <window_size>");
        return -1;
    }
    if((frate = atoi(argv[1])) == 0) {
        fprintf(stderr, "INVALID ARG: frame rate could not be read or was 0.");
        return -1;
    }
    else if(frate > 1000) {
        fprintf(stderr, "INVALID ARG: frame rate must be between 0 -> 1000");
        return -1;
    }

    sprintf(frate_buff, "%d", frate);

    config = cmd_ln_init(NULL, ps_args(), TRUE,
		         "-hmm", MODELDIR "/cmusphinx-en-us-8khz-5.2",
		         "-lm", MODELDIR "/en-us/en-us-phone.lm.bin",
	    		 "-dict", MODELDIR "/en-us/cmudict.dic",
                 //"-allphone", "phone.lm",
                 "-feat", "1s_c_d_dd",
                 "-ceplen", "13",
                 "-ncep", "13",
                 "-lw", "10",
                 "-frate", frate_buff,
                 "-fwdflatlw", "10",
                 "-bestpathlw", "10",
                 "-beam", "1e-80",
                 "-wbeam", "1e-40",
                 "-fwdflatbeam", "1e-80",
                 "-fwdflatwbeam", "1e-40",
                 "-pbeam", "1e-80",
                 "-lpbeam", "1e-80",
                 "-lponlybeam", "1e-80",
                 "-wip", "0.2",
                 "-agc", "none",
                 "-varnorm", "no",
                 "-cmn", "current",
                 "-remove_noise", "no",
                 "-remove_silence", "no",
                 "-transform", "dct",
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

    int i = 0;
    while(i < max_filename && no_error) {
        fprintf(stdout, "predicting file ");
        no_error = predict(i, ps) == 0;
        ++i;
    }

    ps_free(ps);
    cmd_ln_free_r(config);

    return 0;
}

