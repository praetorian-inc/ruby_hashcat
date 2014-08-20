require 'rprogram/task'

module RubyHashcat
  class HashcatTask < RProgram::Task

    # General:
    short_option :flag => '-m', :name => :hash_type
    short_option :flag => '-a', :name => :attack_mode
    short_option :flag => '-V', :name => :version
    long_option :flag => '--quiet', :name => :quiet

    # Benchmark:
    short_option :flag => '-b', :name => :benchmark

    # Misc:
    long_option :flag => '--hex-charset', :name => :hex_charset
    long_option :flag => '--hex-salt', :name => :hex_salt
    long_option :flag => '--hex-wordlist', :name => :hex_wordlist
    long_option :flag => '--force', :name => :force
    long_option :flag => '--status', :name => :status
    long_option :flag => '--status-timer', :equals => true, :name => :status_timer
    long_option :flag => '--status-automat', :name => :status_automat
    long_option :flag => '--loopback', :name => :loopback
    long_option :flag => '--weak-hash-threshold', :equals => true, :name => :weak_hash_threshold

    # Markov:
    long_option :flag => '--markov-hcstat', :equals => true, :name => :markov_hcstat
    long_option :flag => '--markov-disable', :name => :markov_disable
    long_option :flag => '--markov-classic', :name => :markov_classic
    short_option :flag => '-t', :name => :markov_threshold

    # Session:
    long_option :flag => '--runtime', :equals => true, :name => :runtime
    long_option :flag => '--session', :equals => true, :name => :session_name
    long_option :flag => '--restore', :name => :restore
    long_option :flag => '--disable-restore', :name => :disable_restore

    # Files:
    short_option :flag => '-o', :name => :outfile
    long_option :flag => '--outfile-format', :equals => true, :name => :outfile_format
    long_option :flag => '--outfile-autohex-disable', :name => :outfile_autohex_disable
    long_option :flag => '--outfile-check-timer', :name => :outfile_check_timer
    short_option :flag => '-p', :name => :separator
    long_option :flag => '--show', :name => :show
    long_option :flag => '--left', :name => :left
    long_option :flag => '--username', :name => :username
    long_option :flag => '--remove', :name => :remove
    long_option :flag => '--remove-timer', :equals => true, :name => :remove_timer
    long_option :flag => '--disable-potfile', :name => :disable_potfile
    long_option :flag => '--debug-mode', :equals => true, :name => :debug_mode
    long_option :flag => '--debug-file', :equals => true, :name => :debug_file
    long_option :flag => '--induction-dir', :equals => true, :name => :induction_dir
    long_option :flag => '--outfile-check-dir', :equals => true, :name => :outfile_check_dir
    long_option :flag => '--logfile-disable', :name => :logfile_disable

    # Resources:
    short_option :flag => '-c', :name => :segment_size
    long_option :flag => '--bitmap-max', :equals => true, :name => :bitmap_max
    long_option :flag => '--cpu-affinity', :equals => true, :name => :cpu_affinity
    long_option :flag => '--gpu-async', :name => :gpu_async
    short_option :flag => '-d', :name => :gpu_devices
    short_option :flag => '-w', :name => :workload_profile
    short_option :flag => '-n', :name => :gpu_accel
    short_option :flag => '-u', :name => :gpu_loops
    long_option :flag => '--gpu-temp-disable', :name => :gpu_temp_disable
    long_option :flag => '--gpu-temp-abort', :equals => true, :name => :gpu_temp_abort
    long_option :flag => '--gpu-temp-retain', :equals => true, :name => :gpu_temp_retain
    long_option :flag => '--powertune-disable', :name => :powertune_disable

    # Distributed:
    short_option :flag => '-s', :name => :skip
    short_option :flag => '-l', :name => :limit
    long_option :flag => '--keyspace', :name => :keyspace

    # Rules:
    short_option :flag => '-j', :name => :rule_left
    short_option :flag => '-k', :name => :rule_right
    short_option :flag => '-r', :name => :rules, :multiple  => true, :separator => ' -r '
    short_option :flag => '-g', :name => :generate_rules
    long_option :flag => '--generate-rules-func-min', :equals => true, :name => :generate_rules_func_min
    long_option :flag => '--generate-rules-func-max', :equals => true, :name => :generate_rules_func_max
    long_option :flag => '--generate-rules-seed', :equals => true, :name => :generate_rules_seed

    # Custom charsets:
    short_option :flag => '-1', :name => :custom_charset1
    short_option :flag => '-2', :name => :custom_charset2
    short_option :flag => '-3', :name => :custom_charset3
    short_option :flag => '-4', :name => :custom_charset4

    # Increment:
    short_option :flag => '-i', :name => :increment
    long_option :flag => '--increment-min', :equals => true, :name => :increment_min
    long_option :flag => '--increment-max', :equals => true, :name => :increment_max

    non_option :tailing => true, :name => :hash
    non_option :tailing => true, :name => :charset
    non_option :tailing => true, :name => :wordlist
  end
end