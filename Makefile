export:
	conda env export -n video-editor --from-history | grep -v "^prefix: " >| environment.yml
