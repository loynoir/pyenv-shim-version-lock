#!/bin/bash
insert_before_ere() {
	local ere="${1:?}"
	local file="${2:?}"
	cat | sed -ire $'/'"${ere}"$'/ {e cat\n}' "${file}"
}

export_declaration.zsh() {
	local var
	for var in "$@"; do
		# FIXME: shfmt workaround
		eval 'echo "export ${var}=\"${(P)var}\""'
	done
}

export_declaration.bash() {
	local var
	for var in "$@"; do
		echo "export ${var}=\"${!var}\""
	done
}

export_declaration() {
	local shell
	if [ -v BASH_VERSION ]; then
		shell=bash
	elif [ -v ZSH_VERSION ]; then
		shell=zsh
	else
		return 1
	fi
	export_declaration."$shell" "$@"
}

pin_declaration() {
	local ere="${1:?}"
	local file="${2:?}"
	shift
	shift
	local variables=("$@")
	# region heredoc
	insert_before_ere '^exec' "${PROTOTYPE_SHIM_PATH:?}" <<EOF
$(export_declaration "${variables[@]}")
EOF
	# endregion heredoc
}
