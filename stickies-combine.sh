#!/usr/bin/env sh
#	{{{3
#   vim: set tabstop=4 modeline modelines=10:
#   vim: set foldlevel=2 foldcolumn=2 foldmethod=marker:
#	{{{2
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
#set -o xtrace 

#	functions: echoerr, debug
#	{{{
echoerr() {
	echo $@ > /dev/stderr
	exit 2
}
log() {
	echo $@ > /dev/stderr
}
#	}}}

input_dir="./output"
output_file="stickies_combined.txt"
re_file="\./stickies_[0-9]*.txt"

main() {
	#	validate existance: input_dir
	#	{{{
	if [[ ! -d "$input_dir" ]]; then 
		echoerr "not found, input_dir=($input_dir)" 
	fi
	#	}}}

	log "input_dir=($input_dir)"
	cd "$input_dir"

	#	validate non-existance: output_file
	#	{{{
	if [[ -f "$output_file" ]]; then 
		echoerr "file exists=($output_file)" 
	fi
	#	}}}

	IFS_previous=$IFS
	IFS=$'\n'
	files=( `find . -regex "$re_file" | sort -V` )
	IFS=$IFS_previous

	#	validate non-empty: files
	#	{{{
	if [[ "${#files[@]}" -eq 0 ]]; then
		echoerr "error, no files found for re_file=($re_file)"
	fi
	#	}}}

	touch "$output_file"
	for f in "${files[@]}"; do
		echo "$f" >> "$output_file"
		cat "$f" >> "$output_file"
		echo "" >> "$output_file"
	done
}

main "$@"

