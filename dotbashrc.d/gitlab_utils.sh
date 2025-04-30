glab_url() {
	local file="$1"
	local base="https://$(git config --get remote.origin.url | sed 's/git@//g; s/\.git//g; s/:/\//g')"
	echo $base/-/blob/main/$file
}