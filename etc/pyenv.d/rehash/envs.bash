#!/bin/bash
(
	set -eo pipefail
	[ -z "${DEBUG:-}" ] || set -x
	if [ -v BASH_SOURCE ]; then
		__filename="${BASH_SOURCE[0]}"
	else
		#FIXME: shfmt workaround
		eval '__filename="${(%):-%x}"'
	fi
	__filename="$(realpath -m "${__filename}")"
	__dirname="$(dirname "${__filename}")"
	readonly __filename
	readonly __dirname
	cd "${__dirname}" || exit 1

	# shellcheck disable=SC1091
	source ../../../src/index.sh
	: "$(type pin_declaration)"

	main() {
		case "$PYENV_SHIM_VERSION_LOCK" in
		y | Y | yes | Yes | YES | 1)
			pin_declaration '^exec' "${PROTOTYPE_SHIM_PATH:?}" PYENV_VERSION
			# shellcheck disable=SC2046
			make_shims $(list_executable_names | sort -u)
			;;
		esac

	}

	main "$@"

	exit 0
)
